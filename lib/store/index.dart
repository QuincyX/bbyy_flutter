/*
 * @Date: 2020-02-18 16:13:06
 * @LastEditors: Quincy
 * @LastEditTime: 2020-02-19 18:09:47
 * @Description: redux => index
 */
import './user.dart';

class AppReduxStore {
  Map _appReduxStore;
  UserReduxStore _userReduxStore;

  get state => _appReduxStore;
  get global => {'user': _userReduxStore};
  get user => UserReduxStore.initState();
  AppReduxStore.initState() {
    UserReduxStore.initState();
    _appReduxStore = {
      'user': _userReduxStore,
      'global': {
        'counter': 0,
      },
      'user': {},
      'play': 'stop',
    };
  }
  AppReduxStore(_appReduxStore);
  static AppReduxStore fromJson(dynamic json) =>
      json != null ? AppReduxStore(json) : AppReduxStore({});
  dynamic toJson() => _appReduxStore;
}

AppReduxStore reducer(AppReduxStore store, action) {
  print(">>>>>> redux action: $action");
  if (action['module'] == 'user') {
    return AppReduxStore({'user': userReducer(store.user, action)});
  }
  if (action['type'] == 'counterPlus') {
    store.global['counter']++;
    return AppReduxStore(store.state);
  }
  return store;
}
