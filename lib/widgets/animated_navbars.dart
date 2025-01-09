import 'package:flutter/material.dart';

class AnimatedAppBar extends StatelessWidget implements PreferredSizeWidget {
  const AnimatedAppBar({
    super.key,
    required this.appBar,
    required this.animationController,
    required this.isVisible,
  });

  final PreferredSizeWidget appBar;
  final AnimationController animationController;
  final bool isVisible;

  @override
  Size get preferredSize => appBar.preferredSize;

  @override
  Widget build(BuildContext context) {
    isVisible ? animationController.reverse() : animationController.forward();

    return SlideTransition(
      position: Tween<Offset>(
        begin: Offset.zero,
        end: const Offset(0, -1),
      ).animate(
        CurvedAnimation(
          parent: animationController,
          curve: Curves.fastOutSlowIn,
        ),
      ),
      child: appBar,
    );
  }
}

class AnimatedBottomAppBar extends StatelessWidget {
  const AnimatedBottomAppBar({
    super.key,
    required this.bottomAppBar,
    required this.animationController,
    required this.isVisible,
  });

  final BottomAppBar bottomAppBar;
  final AnimationController animationController;
  final bool isVisible;

  @override
  Widget build(BuildContext context) {
    isVisible ? animationController.reverse() : animationController.forward();

    return SlideTransition(
      position: Tween<Offset>(
        begin: Offset.zero,
        end: const Offset(0, 1),
      ).animate(
        CurvedAnimation(
          parent: animationController,
          curve: Curves.fastOutSlowIn,
        ),
      ),
      child: bottomAppBar,
    );
  }
}
