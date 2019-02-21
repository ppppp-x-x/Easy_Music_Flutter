import 'package:audioplayer/audioplayer.dart';

class PlayController {
  var _currentIndex;
  List _playList;
  get playList => _playList;
  get currentIndex => _currentIndex;
  set currentIndex(int val) => _currentIndex = val;

  bool _playing;
  get playing => _playing;
  set playing(val) => _playing = val;

  String _songUrl;
  get songUrl => _songUrl;
  set songUrl(val) => _songUrl = val;

  AudioPlayer _audioPlayer;
  get audioPlayer => _audioPlayer;

  Duration _songPosition;
  get songPosition => _songPosition;
  set songPosition(val) => _songPosition = val;

  PlayController.initState() {
    _playList = [];
    _currentIndex = 0;
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