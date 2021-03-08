import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

typedef VoidUserCallBack = void Function(User);
typedef VoidStringCallBack = void Function(String);
typedef DoubleValueListenableWidgetBuilder<T, E> = Widget Function(
    BuildContext context, T? value1, E? value2, Widget? child);
