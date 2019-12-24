import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';
import './../index.dart';

enum CommonActions {
  switchIsRequesting
}

final Map switchIsRequestingAction = {
  'type': CommonActions.switchIsRequesting
};