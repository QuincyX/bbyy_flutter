/*
 * @Date: 2020-02-18 16:13:06
 * @LastEditors: Quincy
 * @LastEditTime: 2020-02-19 23:27:58
 * @Description: redux => index
 */

class AppReduxStore {
  AppReduxStore(this._appReduxStore);
  Map _appReduxStore;

  get state => _appReduxStore;
  get global => _appReduxStore['global'];

  AppReduxStore.initState() {
    _appReduxStore = {
      'user': {},
      'global': {
        'counter': 0,
      },
      'play': 'stop',
    };
  }
  static AppReduxStore fromJson(dynamic json) =>
      json != null ? AppReduxStore(json) : AppReduxStore({});
  dynamic toJson() => _appReduxStore;
}

AppReduxStore reducer(AppReduxStore store, action) {
  print(">>>>>> redux action: $action");
  print(store.state);
  print(store.global);
  if (action['type'] == 'counterPlus') {
    print(">>>>>> redux action: counterPlus");
    // store.state['global']['counter']++;
    return AppReduxStore(store.state);
  }
  return store;
}
