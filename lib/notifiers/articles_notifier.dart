import 'package:flutter/material.dart';
import 'package:provider_mvvm_sample/models/network/api_client.dart';
import 'package:provider_mvvm_sample/models/entities/entities.dart';

// TODO: あえて Fat な作りにするので可能ならリファクタ.
class ArticlesNotifier with ChangeNotifier {
  final APIClient _apiClient = APIClient();

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  void _setIsLoading(bool isLoading) {
    _isLoading = isLoading;
    notifyListeners();
  }
  
  List<QiitaItem> _items = [];
  List<QiitaItem> get items => _items;

  void _setItems(List<QiitaItem> items) {
    _items = items;
    notifyListeners();
  }

  String _error = '';
  String get error => _error;

  void _setError(String error) {
    _error = error;
    notifyListeners();
  }

  ArticlesNotifier() {
    // NOTE: build() メソッドなどのライフサイクルイベント上では
    // notifyListeners() を呼べないので、
    // コンストラクタで初回フェッチの処理を行う.
    fetch();
  }

  void fetch() async {
    try {
      final all = await _apiClient.getAllItems(1);
      _setIsLoading(false);
      _setItems(all.items);
    } catch (error) {
      _setIsLoading(false);
      _setError(error.toString());
    }
  }
}