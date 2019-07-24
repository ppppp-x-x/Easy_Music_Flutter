import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';
import './../index.dart';

import './../../utils/commonFetch.dart';
import './../../utils//api.dart';

enum Actions {
  pause,
  play,
  nextSong,
  prevSong,
  addPlayList,
  playSeek,
  next,
  switchSongComments,
  addCollectSong,
  deleteCollectSong
}

ThunkAction<AppState> playeNextSong = (Store<AppState> store) async {
  Map _songListActionPayLoad = new Map();
  dynamic state = store.state.playControllerState;
  dynamic songDetail;
  dynamic _songListAction = new Map();
  dynamic songLyr = await getData('lyric', {
    'id': state.songList[state.songIndex + 1]
  });
  songDetail['songLyr'] = songLyr;
  if (state.songList.length == state.songIndex + 1) {
    songDetail = await getSongDetail(int.parse(state.songList[0]));
    _songListActionPayLoad['songIndex'] = 0;
    _songListActionPayLoad['songUrl'] = 'http://music.163.com/song/media/outer/url?id=' + state.songList[0] + '.mp3';
  } else {
    songDetail = await getSongDetail(int.parse(state.songList[state.songIndex + 1]));
    _songListActionPayLoad['songIndex'] = state.songIndex + 1;
    _songListActionPayLoad['songUrl'] = 'http://music.163.com/song/media/outer/url?id=' + state.songList[state.songIndex + 1] + '.mp3';
  }
  _songListActionPayLoad['songDetail'] = songDetail;
  _songListAction['payLoad'] = _songListActionPayLoad;
  _songListAction['type'] = Actions.nextSong;
  store.dispatch(_songListAction);
};