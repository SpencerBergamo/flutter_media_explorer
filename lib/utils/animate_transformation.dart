import 'package:flutter/material.dart';

void animateTransformation({
  required TransformationController transformationController,
  required Matrix4 targetMatrix,
  required TickerProvider vsync,
}) {
  final Matrix4 initialMatrix = transformationController.value;
  final AnimationController animController = AnimationController(
    vsync: vsync,
    duration: const Duration(milliseconds: 300),
  );
  final Animation<Matrix4> animation = Matrix4Tween(
    begin: initialMatrix,
    end: targetMatrix,
  ).animate(CurvedAnimation(
    parent: animController,
    curve: Curves.easeInOut,
  ));

  animation.addListener(() {
    transformationController.value = animation.value;
  });

  animController.forward().then((_) => animController.dispose());
}
