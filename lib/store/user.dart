/*
 * @Date: 2020-02-18 16:13:06
 * @LastEditors: Quincy
 * @LastEditTime: 2020-02-19 18:08:11
 * @Description: redux => user module
 */
import 'package:redux/redux.dart';

class UserReduxStore {
  Map _userReduxStore;
  get state => _userReduxStore;
  UserReduxStore.initState() {
    _userReduxStore = {
      'nickName': "",
    };
  }
  UserReduxStore(this._userReduxStore);
}

// UserReduxStore reducer(UserReduxStore store, action) {
//   if (action['type'] == 'nickName') {
//     store.state['nickName'] = "new nick name";
//     return UserReduxStore(store.state);
//   }
//   return store;
// }

final userReducer = combineReducers<UserReduxStore>([
  TypedReducer<UserReduxStore, UpdateUserAction>(updateUser),
]);

UserReduxStore updateUser(UserReduxStore store, action) {
  print(">>>>>> store");
  print(store);
  store.state['nickName'] = "new nick name";
  return store;
}

class UpdateUserAction {
  String type;
  dynamic payload;
}
