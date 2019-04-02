import 'package:audioplayer/audioplayer.dart';

class PlayController {
  // 已经播放过或者正要播放的歌曲索引
  var _currentIndex;
  get currentIndex => _currentIndex;
  set currentIndex(int val) => _currentIndex = val;

  // 已经播放过或者正在添加的歌曲数组（包含歌曲详细信息）
  List _playList;
  get playList => _playList;

  // 当前所播放的歌单位置索引
  int _songIndex;
  get songIndex => _songIndex;
  set songIndex(val) => _songIndex = val;

  // 当前所播放的歌单（只包含歌曲Id）
  dynamic _songList;
  get songList => _songList;
  set songList(val) => _songList = val;

  // 当前是否正在播放歌曲
  bool _playing;
  get playing => _playing;
  set playing(val) => _playing = val;

  // 当前正在播放的歌曲Url
  String _songUrl;
  get songUrl => _songUrl;
  set songUrl(val) => _songUrl = val;

  // 音乐播放器实例
  AudioPlayer _audioPlayer;
  get audioPlayer => _audioPlayer;

  // 当前歌曲播放进度Duration
  Duration _songPosition;
  get songPosition => _songPosition;
  set songPosition(val) => _songPosition = val;

  PlayController.initState() {
    _playList = [];
    _currentIndex = -1;
    _playing = false;
    songUrl = '';
    _audioPlayer = new AudioPlayer();
    _audioPlayer.onPlayerStateChanged.listen((d) {
      print(_audioPlayer.duration);
    });
    _audioPlayer.onAudioPositionChanged.listen((d) {
      songPosition = d;
    });
  } 

  PlayController(this._playing, this._playList, this._currentIndex);
}