import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';

class CustomPageScrollPhysics extends ScrollPhysics {
  const CustomPageScrollPhysics({ScrollPhysics parent}) : super(parent: parent);

  @override
  CustomPageScrollPhysics applyTo(ScrollPhysics ancestor) {
    return CustomPageScrollPhysics(parent: buildParent(ancestor));
  }

  @override
  SpringDescription get spring => const SpringDescription(
        mass: 100,
        stiffness: 100,
        damping: 1,
      );
}
