class Common {
  bool _isRequesting;
  get isRequesting => _isRequesting;
  set isRequesting(v) => _isRequesting = v;

  Common.initState() {
    this._isRequesting = false;
  }

  Common(this._isRequesting);
}