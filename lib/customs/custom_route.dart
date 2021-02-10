import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomRoute<T> extends PageRoute<T> {
  final WidgetBuilder builder;

  CustomRoute({this.builder});

  @override
  bool get opaque => false;

  @override
  bool get barrierDismissible => false;

  @override
  Color get barrierColor => Colors.transparent;

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return builder(context);
  }

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    return new FadeTransition(
        opacity:
            new CurvedAnimation(parent: animation, curve: Curves.easeInOut),
        child: child);
  }

  @override
  bool get maintainState => true;

  @override
  Duration get transitionDuration => const Duration(milliseconds: 500);

  @override
  bool get fullscreenDialog => true;

  @override
  String get barrierLabel => "";
}
