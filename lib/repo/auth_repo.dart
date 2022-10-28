import 'dart:convert';

import 'package:docs_clone_flutter/constants.dart';
import 'package:docs_clone_flutter/models/error_model.dart';
import 'package:docs_clone_flutter/models/user_model.dart';
import 'package:docs_clone_flutter/repo/local_storage_repo.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart';

final authRepoProvider = Provider(
  (ref) => AuthRepo(
    GoogleSignIn(),
    Client(),
    LocalStorageRepo(),
  ),
);

final userProvider = StateProvider<UserModel?>((ref) => null);

class AuthRepo {
  final GoogleSignIn _googleSignIn;
  final Client _client;
  final LocalStorageRepo _storageRepo;

  AuthRepo(GoogleSignIn googleSignIn, Client client,
      LocalStorageRepo localStorageRepo)
      : _googleSignIn = googleSignIn,
        _client = client,
        _storageRepo = localStorageRepo;

  Future<ErrorModel> signInWithGoogle() async {
    ErrorModel error = ErrorModel(
      error: 'Some unexpected error occurred.',
      data: null,
    );

    final GoogleSignInAccount? user = await _googleSignIn.signIn();
    if (user != null) {
      final UserModel userAcc = UserModel(
        name: user.displayName!,
        email: user.email,
        profilePic: user.photoUrl!,
        token: '',
        uid: '',
      );
      Response res = await _client.post(
        Uri.parse('$kHost/api/signup'),
        body: userAcc.toJson(),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      switch (res.statusCode) {
        case 200:
          final newUser = userAcc.copyWith(
            uid: jsonDecode(res.body)['user']['_id'],
            token: jsonDecode(res.body)['token'],
          );
          error = ErrorModel(error: null, data: newUser);
          _storageRepo.setToke(newUser.token!);
          break;
        default:
          error = ErrorModel(error: jsonDecode(res.body)['error'], data: null);
          throw error.error ?? 'Something went wrong';
      }
    }
    return error;
  }

  Future<ErrorModel> getUserData() async {
    ErrorModel error = ErrorModel(
      error: 'Some unexpected error occurred.',
      data: null,
    );
    String? token = await _storageRepo.readToken();
    if (token != null) {
      Response res = await _client.get(
        Uri.parse('$kHost/api/profile'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'auth-token': token,
        },
      );
      switch (res.statusCode) {
        case 200:
          final newUser = UserModel.fromJson(
            jsonEncode(
              jsonDecode(res.body)['user'],
            ),
          ).copyWith(
            token: token,
          );
          error = ErrorModel(error: null, data: newUser);
          break;
        default:
          error = ErrorModel(error: jsonDecode(res.body)['error'], data: null);
          throw error.error ?? 'Something went wrong';
      }
    }
    return error;
  }

  void signOut() {
    _storageRepo.setToke('');
  }
}
