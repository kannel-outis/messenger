import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomRoute<T> extends PageRoute<T> {
  final WidgetBuilder? builder;

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
    return builder!(context);
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
  String get barrierLabel => "";
}

class CustomNoFadePageRoute<T> extends PageRoute<T> {
  final WidgetBuilder? builder;
  CustomNoFadePageRoute({this.builder});
  @override
  Color? get barrierColor => Colors.transparent;

  @override
  String? get barrierLabel => "b";

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    print(secondaryAnimation.value);

    return builder!(context);
  }

  // CupertinoPageRoute();

  ///use stack

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    return SlideTransition(
      position: Tween<Offset>(
        end: Offset.zero,
        begin: const Offset(1.0, 0.0),
      ).animate(animation),
      child: Align(
        child: SizeTransition(
          sizeFactor:
              CurvedAnimation(curve: Curves.easeInOut, parent: animation),
          axis: Axis.horizontal,
          axisAlignment: 0.0,
          child: child,
        ),
      ),
    );
  }

  @override
  bool get maintainState => true;

  @override
  Duration get transitionDuration => const Duration(milliseconds: 500);
}
