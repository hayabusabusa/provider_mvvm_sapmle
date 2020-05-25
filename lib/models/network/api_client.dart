import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:provider_mvvm_sample/secret.dart';
import 'package:provider_mvvm_sample/models/entities/entities.dart';

class _APIPath {
  static const String items = '/items';
}

class APIClient {
  static const String baseURL = 'https://qiita.com/api/v2';
  static const String token = 'Bearer ' + qiitaAccessToken;

  final http.Client httpClient = http.Client();

  Future<QiitaAllItems> getAllItems(int page) async {
    final url = baseURL + _APIPath.items + '?page=$page';
    final headers = {
      HttpHeaders.contentTypeHeader: "application/json",
      HttpHeaders.authorizationHeader: token,
    };
    final response = await httpClient.get(url, headers: headers);
    final totalCount = response.headers['Total-Count'] as int;

    if (response.statusCode == 200) {
      final List<dynamic> array = json.decode(response.body);
      final List<QiitaItem> items = array.map((i) => QiitaItem.fromJson(i)).toList();
      return QiitaAllItems(items: items, totalCount: totalCount);
    } else {
      throw Exception('Failed to GET /items. (code=${response.statusCode})');
    }
  }
}