class PlayListState {
  var _currentSong;
  List _playList;
  get playList => _playList;
  get currentSong => _currentSong;

  PlayListState(this._playList);
  PlayListState.initState() {
    _playList = [];
    _currentSong = null;
  } 
}