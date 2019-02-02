import 'package:audioplayers/audioplayers.dart';

class AudioControllerState {
  bool _playing;
  get playing => _playing;
  set playing(val) => _playing = !_playing;

  String _songUrl;
  get songUrl => _songUrl;
  set songUrl(val) => _songUrl = val;

  AudioPlayer _audioPlayer;
  get audioPlayer => _audioPlayer;

  AudioControllerState(this._playing);
  AudioControllerState.initState() {
    _playing = false;
    songUrl = '';
    _audioPlayer = new AudioPlayer();
  } 
}