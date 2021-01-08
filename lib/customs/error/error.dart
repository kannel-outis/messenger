import 'dart:core';

class MessengerError implements Exception {
  final String message;

  const MessengerError(this.message);

  @override
  String toString() {
    return 'MessengerError::::::::::::::::::: $message';
  }
}
