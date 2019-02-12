import './state.dart';
import './action.dart';

PlayController PlayControllerReducer(PlayController state, action) {
  if (action['type'] == Actions.play) {
    state.audioPlayer.play(state.songUrl);
    state.playing = true;
  }
  if (action['type'] == Actions.pause) {
    state.audioPlayer.pause();
    state.playing = false;
  }
  if (action['type'] == Actions.changeSong) {
    if(action['payLoad'] != state.songUrl) {
      state.audioPlayer.stop();
      state.songUrl = action['payLoad'];
      state.audioPlayer.play(state.songUrl);
      state.playing = true;
    }
  }
  if(action['type'] == Actions.addPlayList) {
    state.playList.add(action['payLoad']['songDetail']);
    state.audioPlayer.stop();
    state.songUrl = action['payLoad']['songUrl'];
    state.audioPlayer.play(state.songUrl);
    state.playing = true;
    state.currentIndex = state.currentIndex + 1;
  }
  return state;
}