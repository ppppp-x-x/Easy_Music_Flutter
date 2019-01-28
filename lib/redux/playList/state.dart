class WishMoviesState {
  List _wishMoviesList;
  Map _wishMoviesIds;
  get wishMoviesList => _wishMoviesList;
  get wishMoviesIds => _wishMoviesIds;

  WishMoviesState(this._wishMoviesList, this._wishMoviesIds);
  WishMoviesState.initState() {
    _wishMoviesList = [];
    _wishMoviesIds = new Map();
  } 
}