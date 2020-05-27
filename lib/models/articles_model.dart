import 'dart:async';
import 'package:rxdart/rxdart.dart';

import 'package:provider_mvvm_sample/models/network/api_client.dart';
import 'package:provider_mvvm_sample/models/entities/entities.dart';

class ArticlesModel {
  final APIClient _apiClient = APIClient();

  final PublishSubject<bool> _isLoadingSubject = PublishSubject<bool>();
  Stream<bool> get isLoadingStream => _isLoadingSubject.stream;

  final BehaviorSubject<List<QiitaItem>> _articlesSubject = BehaviorSubject<List<QiitaItem>>.seeded([]);
  Stream<List<QiitaItem>> get articlesStream => _articlesSubject.stream;

  final PublishSubject<String> _errorSubject = PublishSubject<String>();
  Stream<String> get errorStream => _errorSubject.stream;

  /// 現在取得したページのインデックス
  int _page = 1;
  /// 次のページを読み込み中かどうか
  bool _isLoadingNext = false;
  
  void fetch() async {
    _isLoadingSubject.add(true);

    try {
      final all = await _apiClient.getAllItems(_page);
      _isLoadingSubject.add(false);
      _articlesSubject.add(all.items);
    } catch (error) {
      _isLoadingSubject.add(false);
      _errorSubject.add(error.toString());
    }
  }

  void fetchNext() async {
    if (_isLoadingNext) return;

    // NOTE: ここでは画面にインジケーターを出したくないので
    // 別の変数でロードを管理する
    _isLoadingNext = true;

    try {
      final all = await _apiClient.getAllItems(_page + 1);
      _page += 1;

      // NOTE: last で最新の値を出そうとしたら ` Bad state: Stream has already been listened to.` でエラーになった.
      // これは Stream がデフォルトでは Single Subscription Stream になっているため、二回以降 listen すると発生するエラー.
      // last の実装を見ると、内部で listen して Future を返しているので、このエラーが発生する.
      //List<QiitaItem> newItems = await _articlesStream.stream.last;

      // NOTE: そんなわけで BehaviorSubject で対応.
      List<QiitaItem> newItems = _articlesSubject.value;
      newItems.addAll(all.items);
      
      _isLoadingNext = false;
      _articlesSubject.add(newItems);
    } catch (error) {
      _isLoadingNext = false;
      _errorSubject.add(error.toString());
    }
  }

  // NOTE: dispose のライフサイクルメソッドがないので
  // まとめて `close()` させるメソッドを生やす必用がある.
  void dispose() {
    _isLoadingSubject.close();
    _articlesSubject.close();
    _errorSubject.close();
  }
}