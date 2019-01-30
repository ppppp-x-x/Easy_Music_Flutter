import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:redux/redux.dart';

import './app.dart';
import './redux/playList/state.dart';
import './redux/playList/reducer.dart';

void main() {
  final store = Store<PlayListModelState>(reducer, initialState: PlayListModelState.initState());
  runApp(MyApp(store));
  if (Platform.isAndroid) {
  // 以下两行 设置android状态栏为透明的沉浸。写在组件渲染之后，是为了在渲染后进行set赋值，覆盖状态栏，写在渲染之前MaterialApp组件会覆盖掉这个值。
    SystemUiOverlayStyle systemUiOverlayStyle = SystemUiOverlayStyle(statusBarColor: Colors.transparent);
    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
  }
}
