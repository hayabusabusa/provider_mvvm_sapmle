import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:provider_mvvm_sample/notifiers/notifiers.dart';
import 'package:provider_mvvm_sample/screens/screens.dart';

void main() {
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'provider mvvm sample',
      home: ChangeNotifierProvider<ArticlesNotifier>(
        create: (_) => ArticlesNotifier(),
        child: ArticlesScreen(),
      ),
    );
  }
}