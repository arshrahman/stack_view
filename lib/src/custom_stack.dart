// import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';

// //To Detect gesture dectector inside stack

// class CustomStack extends Stack {
//   CustomStack({key, alignment = AlignmentDirectional.topStart, textDirection, fit = StackFit.loose, children = const <Widget>[]})
//       : super(key: key, alignment: alignment, textDirection: textDirection, fit: fit, children: children);

//   @override
//   CustomRenderStack createRenderObject(BuildContext context) {
//     return CustomRenderStack(
//       alignment: alignment,
//       textDirection: textDirection ?? Directionality.of(context),
//       fit: fit,
//     );
//   }
// }

// class CustomRenderStack extends RenderStack {
//   CustomRenderStack({alignment, textDirection, fit, overflow}) : super(alignment: alignment, textDirection: textDirection, fit: fit);

//   @override
//   bool hitTestChildren(BoxHitTestResult result, {Offset position}) {
//     var child = lastChild;
//     final List<bool> isChildrenHit = [];
//     while (child != null) {
//       final StackParentData childParentData = child.parentData;
//       final bool isHit = result.addWithPaintOffset(
//         offset: childParentData.offset,
//         position: position,
//         hitTest: (BoxHitTestResult result, Offset transformed) {
//           assert(transformed == position - childParentData.offset);
//           return child.hitTest(result, position: transformed);
//         },
//       );
//       isChildrenHit.add(isHit);
//       child = childParentData.previousSibling;
//     }
//     return isChildrenHit.contains(true);
//   }
// }
