import './state.dart';
import './action.dart';


Common CommonReducer(Common state, action) {
  if (action != null) {
    if (action['type'] == CommonActions.switchIsRequesting) {
      state.isRequesting = !state.isRequesting;
    }
  }
  return state;
}