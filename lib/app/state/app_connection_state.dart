import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:messenger/screens/home/home_provider.dart';

class AppConnectionState {
  final Connectivity _connectivity;
  final HomeProvider _homeProvider;
  AppConnectionState(this._connectivity, this._homeProvider);

  StreamSubscription<ConnectivityResult>? _subscription;

  void iniState() {
    _subscription = _connectivity.onConnectivityChanged.listen((event) {
      if (event != ConnectivityResult.wifi &&
          event != ConnectivityResult.mobile) {
        _homeProvider.iniState();
      }
    });
  }

  void dispose() {
    _subscription?.cancel();
  }
}
