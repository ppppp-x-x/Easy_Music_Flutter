import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';
import 'package:color_thief_flutter/color_thief_flutter.dart';

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
  Map _songListActionPayload = new Map();
  dynamic state = store.state.playControllerState;
  Map songDetail = {};
  dynamic _songListAction = new Map();
  dynamic songLyr = await getData('lyric', {
    'id': state.songList[state.songIndex + 1]
  });
  if (state.songList.length == state.songIndex + 1) {
    songDetail = await getSongDetail(int.parse(state.songList[0]));
    _songListActionPayload['songIndex'] = 0;
    _songListActionPayload['songUrl'] = 'http://music.163.com/song/media/outer/url?id=' + state.songList[0] + '.mp3';
  } else {
    songDetail = await getSongDetail(int.parse(state.songList[state.songIndex + 1]));
    _songListActionPayload['songIndex'] = state.songIndex + 1;
    _songListActionPayload['songUrl'] = 'http://music.163.com/song/media/outer/url?id=' + state.songList[state.songIndex + 1] + '.mp3';
  }
  songDetail['songLyr'] = songLyr;
  _songListActionPayload['songDetail'] = songDetail;
  List<int> coverMainColor = await getColorFromUrl(songDetail['al']['picUrl']);
  _songListActionPayload['coverMainColor'] = coverMainColor;
  _songListAction['payload'] = _songListActionPayload;
  _songListAction['type'] = Actions.nextSong;
  store.dispatch(_songListAction);
};

ThunkAction<AppState> addPlayList (action) {
  return (Store<AppState> store) async {
    List<int> coverMainColor = await getColorFromUrl(action['payload']['songDetail']['al']['picUrl']);
    action['payload']['coverMainColor'] = coverMainColor;
    store.dispatch(action);
  };
}