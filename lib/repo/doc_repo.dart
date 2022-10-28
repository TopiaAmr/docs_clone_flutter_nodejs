// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:docs_clone_flutter/constants.dart';
import 'package:docs_clone_flutter/models/document_model.dart';
import 'package:docs_clone_flutter/models/error_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';

final documentReopProvider = Provider(
  ((ref) => DocumentRepo(
        client: Client(),
      )),
);

class DocumentRepo {
  final Client _client;
  DocumentRepo({
    required Client client,
  }) : _client = client;

  Future<ErrorModel> createDocument(String token) async {
    ErrorModel error = ErrorModel(
      error: 'Some unexpected error occurred.',
      data: null,
    );

    Response res = await _client.post(
      Uri.parse('$kHost/doc/create'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'auth-token': token,
      },
      body: jsonEncode(
        {
          'createdAt': DateTime.now().millisecondsSinceEpoch,
        },
      ),
    );
    switch (res.statusCode) {
      case 200:
        error = ErrorModel(
          error: null,
          data: DocumentModel.fromJson(res.body),
        );
        break;
      default:
        error = ErrorModel(error: jsonDecode(res.body)['error'], data: null);
        throw error.error ?? 'Something went wrong';
    }
    return error;
  }

  Future<ErrorModel> getDocuments(String token) async {
    ErrorModel error = ErrorModel(
      error: 'Some unexpected error occurred.',
      data: null,
    );
    try {
      Response res = await _client.get(
        Uri.parse('$kHost/doc'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'auth-token': token,
        },
      );
      switch (res.statusCode) {
        case 200:
          List<DocumentModel> docs = [];
          List data = jsonDecode(res.body);
          for (int i = 0; i < data.length; i++) {
            docs.add(
              DocumentModel.fromJson(
                jsonEncode(
                  data[i],
                ),
              ),
            );
          }
          error = ErrorModel(
            error: null,
            data: docs,
          );
          break;
        default:
          error = ErrorModel(error: jsonDecode(res.body)['error'], data: null);
          throw error.error ?? 'Something went wrong';
      }
    } catch (e) {
      print(e);
    }
    return error;
  }
}
