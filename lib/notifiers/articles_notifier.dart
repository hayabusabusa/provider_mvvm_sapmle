import 'package:flutter/material.dart';
import 'package:provider_mvvm_sample/models/network/api_client.dart';
import 'package:provider_mvvm_sample/models/entities/entities.dart';

import '../models/entities/entities.dart';

// TODO: あえて Fat な作りにするので可能ならリファクタ.
class ArticlesNotifier with ChangeNotifier {
  final APIClient _apiClient = APIClient();

  bool _isLoading = false;
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

  void fetch() async {
    _setIsLoading(true);

    try {
      final all = await _apiClient.getAllItems(0);
      _setIsLoading(false);
      _setItems(all.items);
    } catch (error) {
      _setIsLoading(false);
      _setError(error.toString());
    }
  }
}