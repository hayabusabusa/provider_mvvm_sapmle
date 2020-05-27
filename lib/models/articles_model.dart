import 'dart:async';

import 'package:provider_mvvm_sample/models/network/api_client.dart';
import 'package:provider_mvvm_sample/models/entities/entities.dart';

class ArticlesModel {
  final APIClient _apiClient = APIClient();

  final StreamController<bool> _isLoadingStream = StreamController<bool>();
  StreamController<bool> get isLoadingStream => _isLoadingStream;

  final StreamController<List<QiitaItem>> _articlesStream = StreamController<List<QiitaItem>>();
  StreamController<List<QiitaItem>> get articlesStream => _articlesStream;

  final StreamController<String> _errorStream = StreamController<String>();
  StreamController<String> get errorStream => _errorStream;

  int _page = 1;
  bool _isLoadingNext = false;
  
  void fetch() async {
    _isLoadingStream.sink.add(true);

    try {
      final all = await _apiClient.getAllItems(_page);
      _isLoadingStream.sink.add(false);
      _articlesStream.sink.add(all.items);
    } catch (error) {
      _isLoadingStream.sink.add(false);
      _errorStream.sink.add(error.toString());
    }
  }

  void fetchNext() async {
    if (_isLoadingNext) return;

    _isLoadingStream.sink.add(true);

    try {
      final all = await _apiClient.getAllItems(_page + 1);
      _page += 1;
      _isLoadingStream.sink.add(false);
      _articlesStream.sink.add(all.items);
    } catch (error) {
      _isLoadingStream.sink.add(false);
      _errorStream.sink.add(error.toString());
    }
  }

  void dispose() {
    _isLoadingStream.close();
    _articlesStream.close();
    _errorStream.close();
  }
}