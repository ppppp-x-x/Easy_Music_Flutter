import './playController/state.dart';
import './commonController/state.dart';

import './playController/reducer.dart';
import './commonController/reducer.dart';

class AppState {
  PlayController playControllerState;
  Common commonState;

  AppState({this.playControllerState, this.commonState});
}

AppState appReducer(AppState state, action) {
  return AppState(
    playControllerState: PlayControllerReducer(state.playControllerState, action),
    commonState: CommonReducer(state.commonState, action)
  );
}