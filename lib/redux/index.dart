import './playController/state.dart';

import './playController/reducer.dart';

class AppState {
  PlayController playControllerState;

  AppState({this.playControllerState});
}

AppState appReducer(AppState state, action) {
  return AppState(
    playControllerState: PlayControllerReducer(state.playControllerState, action)
  );
}