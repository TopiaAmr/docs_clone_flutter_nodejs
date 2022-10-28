import 'dart:convert';

import 'package:docs_clone_flutter/constants.dart';
import 'package:docs_clone_flutter/models/error_model.dart';
import 'package:docs_clone_flutter/models/user_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart';

final authRepoProvider = Provider(
  (ref) => AuthRepo(
    GoogleSignIn(),
    Client(),
  ),
);

final userProvider = StateProvider<UserModel?>((ref) => null);

class AuthRepo {
  final GoogleSignIn _googleSignIn;
  final Client _client;

  AuthRepo(GoogleSignIn googleSignIn, Client client)
      : _googleSignIn = googleSignIn,
        _client = client;

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
}
