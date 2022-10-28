import 'package:docs_clone_flutter/models/document_model.dart';
import 'package:docs_clone_flutter/models/error_model.dart';
import 'package:docs_clone_flutter/repo/auth_repo.dart';
import 'package:docs_clone_flutter/repo/doc_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  void signOut(WidgetRef ref) {
    ref.read(authRepoProvider).signOut();
    ref.read(userProvider.notifier).update((state) => null);
  }

  void createDocument(BuildContext context, WidgetRef ref) async {
    String token = ref.read(userProvider)!.token!;
    final navigator = Routemaster.of(context);
    final snackbar = ScaffoldMessenger.of(context);

    final ErrorModel errorModel =
        await ref.read(documentReopProvider).createDocument(token);
    if (errorModel.data != null) {
      navigator.push('/document/${errorModel.data.id}');
    } else {
      snackbar.showSnackBar(
        const SnackBar(
          content: Text(
            "Something Went Wrong",
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              createDocument(context, ref);
            },
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
      body: FutureBuilder(
        future: ref.watch(documentReopProvider).getDocuments(
              ref.watch(userProvider)!.token!,
            ),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator.adaptive(),
            );
          }
          if (snapshot.data?.data != null) {
            return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: MediaQuery.of(context).size.width ~/ 300,
              ),
              itemCount: snapshot.data?.data.length,
              itemBuilder: (context, index) => InkWell(
                onTap: () => Routemaster.of(context).push(
                  '/document/${snapshot.data!.data[index].id}',
                ),
                child: Card(
                  child: Center(
                    child: Text(
                      snapshot.data!.data[index].title,
                      style: const TextStyle(
                        fontSize: 17,
                      ),
                    ),
                  ),
                ),
              ),
            );
          }
          return Container();
        },
      ),
    );
  }
}
