import 'dart:core';

class MessengerError implements Exception {
  final String message;

  const MessengerError(this.message);

  @override
  String toString() {
    return 'MessengerError::::::::::::::::::: $message';
  }
}

class PermissionError extends MessengerError {
  final String message;
  const PermissionError(this.message) : super(message);

  @override
  String toString() {
    return 'PermissionError::::::::::::::::::: $message';
  }
}
