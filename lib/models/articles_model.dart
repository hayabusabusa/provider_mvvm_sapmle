import 'dart:async';

import 'package:provider_mvvm_sample/models/network/api_client.dart';
import 'package:provider_mvvm_sample/models/entities/entities.dart';

class ArticlesModel {
  final APIClient _apiClient = APIClient();

  final StreamController<bool> _isLoadingStream = StreamController<bool>();
  Stream<bool> get isLoadingStream => _isLoadingStream.stream;

  final StreamController<List<QiitaItem>> _articlesStream = StreamController<List<QiitaItem>>.broadcast();
  Stream<List<QiitaItem>> get articlesStream => _articlesStream.stream;

  final StreamController<String> _errorStream = StreamController<String>();
  Stream<String> get errorStream => _errorStream.stream;

  /// 現在取得したページのインデックス
  int _page = 1;
  /// 次のページを読み込み中かどうか
  bool _isLoadingNext = false;
  /// Stream だとキャッシュなどしてくれないので、仕方なくここで持つ
  List<QiitaItem> _items = [];
  
  void fetch() async {
    _isLoadingStream.sink.add(true);

    try {
      final all = await _apiClient.getAllItems(_page);
      _items = all.items;
      _isLoadingStream.sink.add(false);
      _articlesStream.sink.add(_items);
    } catch (error) {
      _isLoadingStream.sink.add(false);
      _errorStream.sink.add(error.toString());
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
      _items.addAll(all.items);
      
      _isLoadingNext = false;
      _articlesStream.sink.add(_items);
    } catch (error) {
      _isLoadingNext = false;
      _errorStream.sink.add(error.toString());
    }
  }

  // NOTE: dispose のライフサイクルメソッドがないので
  // まとめて `close()` させるメソッドを生やす必用がある.
  void dispose() {
    _isLoadingStream.close();
    _articlesStream.close();
    _errorStream.close();
  }
}