import 'package:audioplayer/audioplayer.dart';
import './../../utils/url.dart';
import './../../utils/request.dart';
import './../../utils/commonFetch.dart';

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


  // 当前播放页面是否显示评论
  bool _showSongComments;
  get showSongComments => _showSongComments;
  set showSongComments(val) => _showSongComments = val;

  // 音乐播放器实例
  AudioPlayer _audioPlayer;
  get audioPlayer => _audioPlayer;

  // 当前歌曲播放进度Duration
  Duration _songPosition;
  get songPosition => _songPosition;
  set songPosition(val) => _songPosition = val;

  List<dynamic> combinLyric (String source) {
    List<dynamic> outputLyric = [];
    source.split('[').forEach((item) {
      outputLyric.add(item.split(']'));
    });
    return outputLyric;
  }

  double stringDurationToDouble (String duration) {
    return double.parse(duration.substring(0, 2)) * 60 + double.parse(duration.substring(3, 5));
  }

  void goNextSong (String id) async {
    int idNum = int.parse(id);
    dynamic songDetail = await getSongDetail(idNum);
    dynamic songLyr = await fetchData('${localBaseUrl}lyric?id=${idNum}');
    _songIndex = _songIndex + 1;
    _currentIndex = _currentIndex + 1;
    songDetail['lyric'] = combinLyric(songLyr['lrc']['lyric']);
    _playList.add(songDetail);
    _songUrl = 'http://music.163.com/song/media/outer/url?id=' + id + '.mp3';
    _audioPlayer.play(_songUrl);
    _playing = true;
  }

  PlayController.initState() {
    _playList = [];
    _currentIndex = -1;
    _playing = false;
    _showSongComments = false;
    songUrl = '';
    _audioPlayer = new AudioPlayer();
    _audioPlayer.onPlayerStateChanged.listen((d) {
      print(_audioPlayer.duration);
    });
    _audioPlayer.onAudioPositionChanged.listen((d) {
      songPosition = d;
      /*
      自动切换下一曲功能
      当前播放歌曲长度等于当前播放进度
      精确度：秒
      */
      if (stringDurationToDouble(songPosition.toString().substring(2, 7)) == stringDurationToDouble(_audioPlayer.duration.toString().substring(2, 7)) && _songList != null && _songList.length > 1) {
        _audioPlayer.stop();
        _playing = false;
        goNextSong(_songIndex == _songList.length - 1 ? _songList[0] : _songList[_songIndex + 1]);
        }  
    });
  } 

  PlayController(this._playing, this._playList, this._currentIndex);
}