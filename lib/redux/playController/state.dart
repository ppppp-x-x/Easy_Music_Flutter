import 'package:audioplayers/audioplayers.dart';
import 'package:color_thief_flutter/color_thief_flutter.dart';
import 'package:flutter_redux/flutter_redux.dart';

import './../../utils/commonFetch.dart';
import './../../utils/api.dart';
import './../index.dart';
import './action.dart' as playControllerActions;

class PlayController {
  // 已经播放过或者正要播放的歌曲索引
  var _currentIndex;
  get currentIndex => _currentIndex;
  set currentIndex(int val) => _currentIndex = val;

  // 已经播放过或者正在添加的歌曲数组（包含歌曲详细信息）
  List _playList;
  get playList => _playList;

  // 当前所播放的歌曲封面主色调
  List<int> _coverMainColor;
  get coverMainColor => _coverMainColor;
  set coverMainColor(val) => _coverMainColor = val;

  // 当前所播放的歌曲长度
  Duration _duration;
  get duration => _duration;
  set duration(val) => _duration = val;

  // 当前所播放的歌单位置索引
  int _songIndex;
  get songIndex => _songIndex;
  set songIndex(val) => _songIndex = val;

  // 当前所播放的歌单（只包含歌曲Id）
  dynamic songList;

  // 当前用户喜欢歌曲
  List<dynamic> _collectSongs;
  get collectSongs => _collectSongs;
  set collectSongs(val) => _collectSongs = val;

  // 当前是否正在播放歌曲
  bool _playing;
  get playing => _playing;
  set playing(val) => _playing = val;

  // 当前正在播放的歌曲Url
  String _songUrl;
  get songUrl => _songUrl;
  set songUrl(val) => _songUrl = val;


  // 当前播放页面是否显示评论
  bool _showSongComments;
  get showSongComments => _showSongComments;
  set showSongComments(val) => _showSongComments = val;

  // 音乐播放器实例
  AudioPlayer _audioPlayer;
  get audioPlayer => _audioPlayer;

  // 当前歌曲播放进度Duration
  Duration _songProgress;
  get songProgress => _songProgress;
  set songProgress(val) => _songProgress = val;

  PlayController.initState() {
    _playList = [];
    _collectSongs = [];
    _currentIndex = -1;
    _playing = false;
    _showSongComments = false;
    songUrl = '';
    _coverMainColor = [0, 0, 0];
    _audioPlayer = new AudioPlayer();
    // 监听当前歌曲长度
    _audioPlayer.onDurationChanged.listen((d) {
      duration = d;
    });
  } 

  PlayController(this._playing, this._playList, this._currentIndex, this._coverMainColor, this._audioPlayer);
}