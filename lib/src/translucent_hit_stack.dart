import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class TranslucenHitStack extends Stack {
  TranslucenHitStack(
      {key,
      alignment = AlignmentDirectional.topStart,
      textDirection,
      fit = StackFit.loose,
      overflow = Overflow.clip,
      children = const <Widget>[]})
      : super(key: key, alignment: alignment, textDirection: textDirection, fit: fit, overflow: overflow, children: children);

  @override
  CustomRenderStack createRenderObject(BuildContext context) {
    return CustomRenderStack(
      alignment: alignment,
      textDirection: textDirection ?? Directionality.of(context),
      fit: fit,
      overflow: overflow,
    );
  }
}

class CustomRenderStack extends RenderStack {
  CustomRenderStack({alignment, textDirection, fit, overflow})
      : super(alignment: alignment, textDirection: textDirection, fit: fit, overflow: overflow);

  @override
  bool hitTestChildren(BoxHitTestResult result, {Offset position}) {
    var child = lastChild;
    final List<bool> isChildrenHit = [];
    while (child != null) {
      final StackParentData childParentData = child.parentData;
      final bool isHit = result.addWithPaintOffset(
        offset: childParentData.offset,
        position: position,
        hitTest: (BoxHitTestResult result, Offset transformed) {
          assert(transformed == position - childParentData.offset);
          return child.hitTest(result, position: transformed);
        },
      );
      isChildrenHit.add(isHit);
      child = childParentData.previousSibling;
    }
    return isChildrenHit.contains(true);
  }
}
