import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

typedef sizeBuilder = Widget Function(BuildContext, Size);

class SizedBoxO extends RenderObjectWidget {
  // final void Function(Size)? onSizeChanged;
  final sizeBuilder? builder;

  const SizedBoxO({Key? key, this.builder}) : super(key: key);

  @override
  _SizedBoxRenderBox createRenderObject(BuildContext context) {
    return _SizedBoxRenderBox().._widget = this;
  }

  @override
  void updateRenderObject(
      BuildContext context, covariant RenderObject renderObject) {
    _SizedBoxRenderBox().._widget = this;
  }

  @override
  _SizedBoxOElement createElement() {
    return _SizedBoxOElement(this);
  }
}

class _SizedBoxOElement extends RenderObjectElement {
  _SizedBoxOElement(RenderObjectWidget widget) : super(widget);

  @override
  SizedBoxO get widget => super.widget as SizedBoxO;

  Element? _child;
  Element? get context => _child;

  @override
  void visitChildren(ElementVisitor visitor) {
    if (_child != null) visitor(_child!);
  }

  @override
  void forgetChild(Element child) {
    assert(child == _child);
    _child = null;
    super.forgetChild(child);
  }

  @override
  void mount(Element? parent, dynamic newSlot) {
    super.mount(parent, newSlot);
    _child = updateChild(_child,
        widget.builder!(_child!, widget.createRenderObject(_child!).s), null);
  }

  @override
  void update(SingleChildRenderObjectWidget newWidget) {
    super.update(newWidget);
    assert(widget == newWidget);
    _child = updateChild(_child,
        widget.builder!(_child!, widget.createRenderObject(_child!).s), null);
  }

  @override
  void insertRenderObjectChild(RenderObject child, dynamic slot) {
    final RenderObjectWithChildMixin<RenderObject> renderObject =
        this.renderObject as RenderObjectWithChildMixin<RenderObject>;
    assert(slot == null);
    assert(renderObject.debugValidateChild(child));
    renderObject.child = child;
    assert(renderObject == this.renderObject);
  }

  @override
  void moveRenderObjectChild(
      RenderObject child, dynamic oldSlot, dynamic newSlot) {
    assert(false);
  }

  @override
  void removeRenderObjectChild(RenderObject child, dynamic slot) {
    final RenderObjectWithChildMixin<RenderObject> renderObject =
        this.renderObject as RenderObjectWithChildMixin<RenderObject>;
    assert(slot == null);
    assert(renderObject.child == child);
    renderObject.child = null;
    assert(renderObject == this.renderObject);
  }
}

class _SizedBoxRenderBox extends RenderBox
    with RenderObjectWithChildMixin<RenderBox> {
  var _widget = const SizedBoxO();
  // final context = BuildOwner();
  Size get s => size;

  var _lastSize = Size.zero;

  @override
  void performLayout() {
    final child = this.child;
    if (child != null) {
      child.layout(constraints, parentUsesSize: true);
      size = child.size;
    } else {
      size = constraints.smallest;
    }

    if (_lastSize != size) {
      _lastSize = size;
      _widget.builder?.call(_widget.createElement().context!, size);
    }
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    final child = this.child;
    if (child != null) context.paintChild(child, offset);
  }

  // @override
  // bool hitTest(BoxHitTestResult result, {required Offset position}) {
  // TODO: implement hitTest
  // return super.hitTest(result, position);
  // }

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) {
    return child?.hitTest(result, position: position) == true;
  }
}
