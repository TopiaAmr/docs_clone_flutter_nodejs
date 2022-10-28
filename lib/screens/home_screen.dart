import 'package:docs_clone_flutter/repo/auth_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  void signOut(WidgetRef ref) {
    ref.read(authRepoProvider).signOut();
    ref.read(userProvider.notifier).update((state) => null);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.add,
              color: Colors.indigo,
            ),
          ),
          IconButton(
            onPressed: () => signOut(ref),
            icon: const Icon(
              Icons.logout,
              color: Colors.red,
            ),
          ),
        ],
      ),
      body: Center(
        child: Text(ref.watch(userProvider)!.uid),
      ),
    );
  }
}
