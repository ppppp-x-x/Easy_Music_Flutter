import 'package:audioplayers/audioplayers.dart';

class PlayController {
  var _currentIndex;
  List _playList;
  get playList => _playList;
  get currentIndex => _currentIndex;
  set currentIndex(int val) => _currentIndex = val;

  bool _playing;
  get playing => _playing;
  set playing(val) => _playing = !_playing;

  String _songUrl;
  get songUrl => _songUrl;
  set songUrl(val) => _songUrl = val;

  AudioPlayer _audioPlayer;
  get audioPlayer => _audioPlayer;

  PlayController.initState() {
    _playList = [];
    _currentIndex = 0;
    _playing = false;
    songUrl = '';
    _audioPlayer = new AudioPlayer();
  } 

  PlayController(this._playing, this._playList, this._currentIndex);
}