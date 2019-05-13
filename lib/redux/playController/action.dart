import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';
import './../index.dart';

import './../../utils/commonFetch.dart';
import './../../utils/request.dart';
import './../../utils/url.dart';

enum Actions {
  pause,
  play,
  nextSong,
  prevSong,
  addPlayList,
  playSeek,
  next,
  switchSongComments
}

ThunkAction<AppState> playeNextSong = (Store<AppState> store) async {
  dynamic state = store.state.playControllerState;
  dynamic songDetail;
  dynamic _songListAction = new Map();
  var _songListActionPayLoad = new Map();
  if (state.songList.length == state.songIndex + 1) {
    songDetail = await getSongDetail(int.parse(state.songList[0]));
    dynamic songLyr = await fetchData('${localBaseUrl}lyric?id=${state.songList[state.songIndex + 1]}');
    songDetail['songLyr'] = songLyr;
    _songListActionPayLoad['songIndex'] = 0;
    _songListActionPayLoad['songUrl'] = 'http://m usic.163.com/song/media/outer/url?id=' + state.songList[0] + '.mp3';
  } else {
    songDetail = await getSongDetail(int.parse(state.songList[state.songIndex + 1]));
    dynamic songLyr = await fetchData('${localBaseUrl}lyric?id=${state.songList[state.songIndex + 1]}');
    songDetail['songLyr'] = songLyr;
    _songListActionPayLoad['songIndex'] = state.songIndex + 1;
    _songListActionPayLoad['songUrl'] = 'http://music.163.com/song/media/outer/url?id=' + state.songList[state.songIndex + 1] + '.mp3';
  }
  _songListActionPayLoad['songDetail'] = songDetail;
  _songListAction['payLoad'] = _songListActionPayLoad;
  _songListAction['type'] = Actions.nextSong;
  store.dispatch(_songListAction);
};