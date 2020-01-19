import 'dart:async';

import './state.dart';
import './action.dart';


Common commonReducer(Common state, action) {
  if (action != null) {
    if (action['type'] == CommonActions.switchIsRequesting) {
      state.isRequesting = !state.isRequesting;
    }
    if (action['type'] == CommonActions.openToast) {
      state.toastMessage = action['payload']['message'];
      state.toastStatus = true;
      Duration timeout = action['payload']['timeout'];
      if (timeout != null) {
        Timer(timeout, () {
          state.toastMessage = '';
          state.toastStatus = false;
        });
      }
    }
    if (action['type'] == CommonActions.closeToast) {
      state.toastStatus = false;
    }
  }
  return state;
}