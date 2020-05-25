import 'package:http/http.dart' as http;

import 'package:provider_mvvm_sample/secret.dart';
import 'package:provider_mvvm_sample/models/entities/entities.dart';

class APIClient {
  static const String baseURL = 'https://qiita.com/api/v2';
  static const String token = 'Bearer ' + qiitaAccessToken;

  final http.Client httpClient = http.Client();

  Future<http.Response> get() async {

  }
}