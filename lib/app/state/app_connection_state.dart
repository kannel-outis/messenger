import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:messenger/services/online/online.dart';

class AppConnectionState {
  final Connectivity _connectivity;
  final Online _online;
  AppConnectionState(this._connectivity, this._online);

  StreamSubscription<ConnectivityResult>? _subscription;

  void iniState() {
    _subscription = _connectivity.onConnectivityChanged.listen((event) {
      if (event != ConnectivityResult.wifi &&
          event != ConnectivityResult.mobile) {
        // _homeProvider.iniState();

      }
    });
  }

  void dispose() {
    _subscription?.cancel();
  }
}
