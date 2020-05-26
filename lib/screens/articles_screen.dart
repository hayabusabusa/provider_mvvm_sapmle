import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:provider_mvvm_sample/notifiers/notifiers.dart';
import 'package:provider_mvvm_sample/widgets/widgets.dart';

class ArticlesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Qiita', style: TextStyle(color: Colors.green, fontSize: 20, fontWeight: FontWeight.w600),),
        brightness: Brightness.light,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.green),
      ),
      // NOTE: Cunsummer だとその都度 context が再発行されて無限ループになるのでは.
      body: context.select((ArticlesNotifier value) => value.isLoading
          ? Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.green[300]),
            )
          )
          : Scrollbar(
            child: ListView.builder(
              controller: value.scrollController,
              itemCount: value.items.length,
              itemBuilder: (context, index) => ArticleItem(
                qiitaItem: value.items[index], 
                onTap: (item) { print(item); },
              ),
            ),
          )
        ),
    );
  }
}