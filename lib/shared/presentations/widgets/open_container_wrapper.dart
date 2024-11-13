import 'package:flutter/material.dart';

import 'package:animations/animations.dart';

class OpenContainerWrapper extends StatelessWidget {
  const OpenContainerWrapper({
    super.key,
    required this.closedBuilder,
    required this.transitionType,
    required this.pageDetail,
    this.transitionDuration,
    this.closedShapeRadius,
  });

  final CloseContainerBuilder closedBuilder;
  final ContainerTransitionType transitionType;
  final Widget pageDetail;
  final Duration? transitionDuration;
  final double? closedShapeRadius;
  @override
  Widget build(BuildContext context) {
    return OpenContainer(
      closedElevation: 0,
      openElevation: 0,
      closedColor: Colors.transparent,
      openColor: Colors.transparent,
      transitionType: transitionType,
      closedShape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.all(Radius.circular(closedShapeRadius ?? 16))),
      transitionDuration: transitionDuration ?? const Duration(seconds: 1),
      openBuilder: (BuildContext context, VoidCallback _) {
        return pageDetail;
      },
      tappable: false,
      closedBuilder: closedBuilder,
    );
  }
}
