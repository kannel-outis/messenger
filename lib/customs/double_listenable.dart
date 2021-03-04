import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

typedef DoubleListenableWidgetBuilder<T, E> = Widget Function(
    BuildContext context, T value1, E value2, Widget child);

class DoubleListenableBuilder<T, E> extends StatefulWidget {
  const DoubleListenableBuilder({
    Key key,
    @required this.valueListenable,
    @required this.builder,
    @required this.valueListenable2,
    this.child,
  })  : assert(valueListenable != null),
        assert(valueListenable2 != null),
        assert(builder != null),
        super(key: key);

  final ValueListenable<T> valueListenable;
  final ValueListenable<E> valueListenable2;

  final DoubleListenableWidgetBuilder<T, E> builder;

  final Widget child;

  @override
  State<StatefulWidget> createState() => _DoubleListenableBuilderState<T, E>();
}

class _DoubleListenableBuilderState<T, E>
    extends State<DoubleListenableBuilder<T, E>> {
  T value;
  E value2;

  @override
  void initState() {
    super.initState();
    value = widget.valueListenable.value;
    value2 = widget.valueListenable2.value;
    widget.valueListenable.addListener(_valueChanged);
  }

  @override
  void didUpdateWidget(DoubleListenableBuilder<T, E> oldWidget) {
    if (oldWidget.valueListenable != widget.valueListenable ||
        oldWidget.valueListenable2 != widget.valueListenable2) {
      oldWidget.valueListenable.removeListener(_valueChanged);
      oldWidget.valueListenable2.removeListener(_valueChanged);
      value = widget.valueListenable.value;
      value2 = widget.valueListenable2.value;
      widget.valueListenable.addListener(_valueChanged);
      widget.valueListenable2.addListener(_valueChanged);
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    widget.valueListenable.removeListener(_valueChanged);
    widget.valueListenable2.removeListener(_valueChanged);
    super.dispose();
  }

  void _valueChanged() {
    setState(() {
      value = widget.valueListenable.value;
      value2 = widget.valueListenable2.value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, value, value2, widget.child);
  }
}
