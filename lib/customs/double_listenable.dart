import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:messenger/utils/typedef.dart';

class DoubleValueListenableBuilder<T, E> extends StatefulWidget {
  const DoubleValueListenableBuilder({
    Key? key,
    required this.valueListenable,
    required this.builder,
    required this.valueListenable2,
    this.child,
  }) : super(key: key);

  final ValueListenable<T> valueListenable;
  final ValueListenable<E> valueListenable2;

  final DoubleValueListenableWidgetBuilder<T, E> builder;

  final Widget? child;

  @override
  State<StatefulWidget> createState() =>
      _DoubleValueListenableBuilderState<T, E>();
}

class _DoubleValueListenableBuilderState<T, E>
    extends State<DoubleValueListenableBuilder<T?, E?>> {
  T? value;
  E? value2;

  @override
  void initState() {
    super.initState();
    value = widget.valueListenable.value;
    value2 = widget.valueListenable2.value;
    widget.valueListenable.addListener(_valueChanged);
    widget.valueListenable2.addListener(_valueChanged2);
  }

  @override
  void didUpdateWidget(DoubleValueListenableBuilder<T?, E?> oldWidget) {
    if (oldWidget.valueListenable != widget.valueListenable ||
        oldWidget.valueListenable2 != widget.valueListenable2) {
      oldWidget.valueListenable.removeListener(_valueChanged);
      oldWidget.valueListenable2.removeListener(_valueChanged2);
      value = widget.valueListenable.value;
      value2 = widget.valueListenable2.value;
      widget.valueListenable.addListener(_valueChanged);
      widget.valueListenable2.addListener(_valueChanged2);
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    widget.valueListenable.removeListener(_valueChanged);
    widget.valueListenable2.removeListener(_valueChanged2);
    super.dispose();
  }

  void _valueChanged() {
    setState(() {
      value = widget.valueListenable.value;
    });
  }

  void _valueChanged2() {
    setState(() {
      value2 = widget.valueListenable2.value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, value, value2, widget.child);
  }
}
