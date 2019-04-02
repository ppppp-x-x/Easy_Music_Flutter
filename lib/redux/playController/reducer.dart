import './state.dart';
import './action.dart';

List<dynamic> combinLyric (String source) {
  List<dynamic> outputLyric = [];
  source.split('[').forEach((item) {
    outputLyric.add(item.split(']'));
  });
  return outputLyric;
}

PlayController PlayControllerReducer(PlayController state, action) {
  if(action != null) {
    if (action['type'] == Actions.play) {
      state.audioPlayer.play(state.songUrl);
      state.playing = true;
    }
    if (action['type'] == Actions.pause) {
      state.audioPlayer.pause();
      state.playing = false;
    }
    if (action['type'] == Actions.nextSong) {
      if (state.playing) {
        state.audioPlayer.stop();
      }
      if (action['payLoad']['songDetail']['songLyr']['lrc']['lyric'] != null) {
        action['payLoad']['songDetail']['lyric'] = combinLyric(action['payLoad']['songDetail']['songLyr']['lrc']['lyric']);
      }
      state.playing = false;
      state.songIndex = action['payLoad']['songIndex'];
      state.playList.add(action['payLoad']['songDetail']);
      state.currentIndex = state.currentIndex + 1;
      state.songUrl = action['payLoad']['songUrl'];
      state.audioPlayer.play(state.songUrl);
      state.playing = true;
    }
    if(action['type'] == Actions.addPlayList) {
      if (state.playing) {
        state.audioPlayer.stop();
      }
      if (action['payLoad']['songList'] != null) {
        state.songList = action['payLoad']['songList'];
      }
      if (action['payLoad']['songDetail']['songLyr']['lrc']['lyric'] != null) {
        action['payLoad']['songDetail']['lyric'] = combinLyric(action['payLoad']['songDetail']['songLyr']['lrc']['lyric']);
      }
      state.playing = false;
      state.songIndex = action['payLoad']['songIndex'];
      state.playList.add(action['payLoad']['songDetail']);
      state.currentIndex = state.currentIndex + 1;
      state.songUrl = action['payLoad']['songUrl'];
      state.audioPlayer.play(state.songUrl);
      state.playing = true;
    }
    if (action['type'] == Actions.playSeek) {
      if(action['payLoad'] > 0) {
        state.audioPlayer.seek(action['payLoad']);
      }
    }
  }
  return state;
}