import 'dart:developer';

import 'package:docs_clone_flutter/models/user_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';

final authRepoProvider = Provider(
  (ref) => AuthRepo(
    GoogleSignIn(),
  ),
);

class AuthRepo {
  final GoogleSignIn _googleSignIn;

  AuthRepo(GoogleSignIn googleSignIn) : _googleSignIn = googleSignIn;

  void signInWithGoogle() async {
    final GoogleSignInAccount? user = await _googleSignIn.signIn();
    if (user != null) {
      final UserModel userAcc = UserModel(
        name: user.displayName!,
        email: user.email,
        profilePic: user.photoUrl!,
        token: '',
        uid: '',
      );
    }
  }
}
