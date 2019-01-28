import './state.dart';
import './action.dart';

PlayListState reducer(PlayListState state, action) {
  if(action['type'] == Actions.addPlayList) {
    state.playList.add(action.payLoad);
  }
  return state;
}