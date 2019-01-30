import './state.dart';
import './action.dart';

PlayListModelState reducer(PlayListModelState state, action) {
  if(action['type'] == Actions.addPlayList) {
    state.playList.add(action['payLoad']);
    state.currentIndex = state.currentIndex + 1;
  }
  return state;
}