import './audioController/state.dart';
import './playList/state.dart';

import './audioController/reducer.dart';
import './playList/reducer.dart';

class AppState {
  AudioControllerState audioControllerState;
  PlayListModelState playListModelState;

  AppState({this.audioControllerState, this.playListModelState});
}

AppState appReducer(AppState state, action) {
  return AppState(
    audioControllerState: audioControllerStateReducer(state.audioControllerState, action),
    playListModelState: playListModelStateReducer(state.playListModelState, action)
  );
}