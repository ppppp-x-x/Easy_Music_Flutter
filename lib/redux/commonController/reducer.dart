import './state.dart';
import './action.dart';


Common commonReducer(Common state, action) {
  if (action != null) {
    if (action['type'] == CommonActions.switchIsRequesting) {
      state.isRequesting = !state.isRequesting;
    }
  }
  return state;
}