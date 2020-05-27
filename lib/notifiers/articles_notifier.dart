import 'package:flutter/material.dart';

import 'package:provider_mvvm_sample/models/models.dart';
import 'package:provider_mvvm_sample/models/entities/entities.dart';

class ArticlesNotifier with ChangeNotifier {
  final ArticlesModel _model = ArticlesModel();
  final ScrollController scrollController = ScrollController();

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
    // NOTE: Observe
    _model.isLoadingStream.listen((event) => _setIsLoading(event));
    _model.articlesStream.listen((event) => _setItems(event));
    _model.errorStream.listen((event) => _setError(event));

    // NOTE: build() メソッドなどのライフサイクルイベント上では
    // notifyListeners() を呼べないので、
    // コンストラクタで初回フェッチの処理を行う.
    _model.fetch();

    scrollController.addListener(() { 
      double position = scrollController.offset / scrollController.position.maxScrollExtent;
      if (position >= 1) {
        _model.fetchNext();
      }
    });
  }

  @override
  void dispose() {
    // NOTE: Model の dispose を忘れない.
    _model.dispose();
    scrollController.dispose();
    super.dispose();
  }
}