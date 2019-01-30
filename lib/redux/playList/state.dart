class PlayListModelState {
  var _currentIndex;
  List _playList;
  get playList => _playList;
  get currentIndex => _currentIndex;
  
  set currentIndex(int val) => _currentIndex = val;
  PlayListModelState(this._playList, this._currentIndex);
  PlayListModelState.initState() {
    _playList = [];
    _currentIndex = 0;
  } 
}