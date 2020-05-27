import 'package:flutter/material.dart';
import 'package:provider_mvvm_sample/models/network/api_client.dart';
import 'package:provider_mvvm_sample/models/entities/entities.dart';

// TODO: あえて Fat な作りにするので可能ならリファクタ.
class ArticlesNotifier with ChangeNotifier {
  final APIClient _apiClient = APIClient();
  final ScrollController scrollController = ScrollController();

  int _page = 1;
  bool _isFetchNext = false;
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

  void _appendItems(List<QiitaItem> items) {
    _items.addAll(items);
    notifyListeners();
  }

  String _error = '';
  String get error => _error;

  void _setError(String error) {
    _error = error;
    notifyListeners();
  }

  // MARK: Lifecycle

  ArticlesNotifier() {
    // NOTE: build() メソッドなどのライフサイクルイベント上では
    // notifyListeners() を呼べないので、
    // コンストラクタで初回フェッチの処理を行う.
    fetch();

    scrollController.addListener(() { 
      double position = scrollController.offset / scrollController.position.maxScrollExtent;
      if (position >= 1) {
        fetchNext();
      }
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  // MARK: Public methods

  void fetch() async {
    try {
      final all = await _apiClient.getAllItems(_page);
      _setIsLoading(false);
      _setItems(all.items);
    } catch (error) {
      _setIsLoading(false);
      _setError(error.toString());
    }
  }

  void fetchNext() async {
    if (_isFetchNext) return;

    _isFetchNext = true;

    try {
      final all = await _apiClient.getAllItems(_page + 1);
      _page += 1;
      _isFetchNext = false;
      _appendItems(all.items);
    } catch (error) {
      _isFetchNext = false;
      _setError(error.toString());
    }
  }
}