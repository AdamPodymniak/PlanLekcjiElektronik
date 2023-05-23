import 'package:flutter/material.dart';
import 'dart:ui';

class GlassMorphism extends StatelessWidget {
  final double blur;
  final double opacity;
  final Color color;
  final Widget? child;
  final BorderRadius borderRadius;

  const GlassMorphism({
    required this.blur,
    required this.opacity,
    this.child,
    this.color = Colors.white,
    this.borderRadius = const BorderRadius.all(Radius.zero),
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius,
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: blur,
          sigmaY: blur,
        ),
        child: Container(
          decoration: BoxDecoration(
            color: color.withOpacity(opacity),
            borderRadius: borderRadius,
          ),
          child: child,
        ),
      ),
    );
  }
}
