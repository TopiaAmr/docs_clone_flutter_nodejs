import 'package:docs_clone_flutter/models/error_model.dart';
import 'package:docs_clone_flutter/repo/auth_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:routemaster/routemaster.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  void signInWithGoogle(WidgetRef ref, BuildContext context) async {
    final sMessenger = ScaffoldMessenger.of(context);
    final navigator = Routemaster.of(context);
    final ErrorModel error =
        await ref.read(authRepoProvider).signInWithGoogle();
    if (error.error == null) {
      ref.read(userProvider.notifier).update((state) => error.data);
      navigator.replace('/');
    } else {
      sMessenger.showSnackBar(
        SnackBar(
          content: Text(error.error!),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Center(
        child: ElevatedButton.icon(
          onPressed: () => signInWithGoogle(ref, context),
          icon: const Icon(FontAwesomeIcons.google),
          label: const Text("Login with Google"),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black,
          ),
        ),
      ),
    );
  }
}
