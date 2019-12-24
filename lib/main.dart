import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';

import './app.dart';
import './redux/index.dart';
import './redux/playController/state.dart';
import './redux/commonController/state.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final store = Store<AppState>(appReducer, middleware: [thunkMiddleware], initialState: AppState(
    playControllerState: PlayController.initState(),
    commonState: Common.initState()
  ));
  runApp(MyApp(store));
  if (Platform.isAndroid) {
  // 以下两行 设置android状态栏为透明的沉浸。写在组件渲染之后，是为了在渲染后进行set赋值，覆盖状态栏，写在渲染之前MaterialApp组件会覆盖掉这个值。
    SystemUiOverlayStyle systemUiOverlayStyle = SystemUiOverlayStyle(statusBarColor: Colors.transparent);
    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
  }
}
