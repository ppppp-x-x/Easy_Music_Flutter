import './state.dart';
import './action.dart';

PlayListModelState playListModelStateReducer(PlayListModelState state, action) {
  if(action['type'] == Actions.addPlayList) {
    state.playList.add(action['payLoad']);
    state.currentIndex = state.currentIndex + 1;
  }
  return state;
}