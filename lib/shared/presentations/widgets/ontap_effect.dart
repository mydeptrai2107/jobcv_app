import 'package:flutter/material.dart';

class OntapEffect extends StatelessWidget {
  final VoidCallback onTap;
  final Widget child;
  final double radius;
  const OntapEffect({
    super.key,
    required this.onTap,
    required this.child,
    required this.radius,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(radius),
      child: child,
    );
  }
}
