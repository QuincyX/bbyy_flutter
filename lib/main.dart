import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux_persist/redux_persist.dart';
import 'package:redux_persist_flutter/redux_persist_flutter.dart';

import 'package:by_flutter/plugins/dio.dart';
import 'package:by_flutter/store/global.dart';
import 'package:by_flutter/store/index.dart';
import 'package:by_flutter/router/index.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final persistor = Persistor<AppReduxStore>(
    storage: FlutterStorage(),
    serializer: JsonSerializer<AppReduxStore>(AppReduxStore.fromJson),
  );
  final initialState = await persistor.load();
  final store = Store<AppReduxStore>(
    reducer,
    initialState: initialState ?? AppReduxStore.initState(),
    middleware: [persistor.createMiddleware()],
  );
  Global.init().then((e) {
    initHttpInstance();
    runApp(MyApp(store));
  });
}

class MyApp extends StatelessWidget {
  final Store<AppReduxStore> store;
  MyApp(this.store);
  @override
  Widget build(BuildContext context) {
    return StoreProvider<AppReduxStore>(
      store: store,
      child: MaterialApp(
        title: 'BY live demo',
        theme: ThemeData(
          primarySwatch: Colors.yellow,
        ),
        routes: routes,
      ),
    );
  }
}
