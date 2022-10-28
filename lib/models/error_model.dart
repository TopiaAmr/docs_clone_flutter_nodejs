import 'dart:convert';

class ErrorModel {
  final String? error;
  final dynamic data;
  ErrorModel({
    required this.error,
    required this.data,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'error': error,
      'data': data,
    };
  }

  factory ErrorModel.fromMap(Map<String, dynamic> map) {
    return ErrorModel(
      error: map['error'] as String,
      data: map['data'] as dynamic,
    );
  }

  String toJson() => json.encode(toMap());

  factory ErrorModel.fromJson(String source) =>
      ErrorModel.fromMap(json.decode(source) as Map<String, dynamic>);

  ErrorModel copyWith({
    String? error,
    dynamic data,
  }) {
    return ErrorModel(
      error: error ?? this.error,
      data: data ?? this.data,
    );
  }

  @override
  String toString() => 'ErrorModel(error: $error, data: $data)';
}
