class Common {
  bool _isRequesting;
  get isRequesting => _isRequesting;
  set isRequesting(v) => _isRequesting = v;

  bool _toastStatus;
  get toastStatus => _toastStatus;
  set toastStatus(v) => _toastStatus = v;

  String _toastMessage;
  get toastMessage => _toastMessage;
  set toastMessage(v) => _toastMessage = v;

  Common.initState() {
    this._isRequesting = false;
    this._toastStatus = false;
    this._toastMessage = '';
  }

  Common(this._isRequesting, this._toastStatus, this._toastMessage);
}