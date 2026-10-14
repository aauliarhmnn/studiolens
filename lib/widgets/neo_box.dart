import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class NeoBox extends StatelessWidget {
  const NeoBox({
    super.key,
    required this.child,
    this.color = Colors.white,
    this.padding = const EdgeInsets.all(16),
    this.borderWidth = 3,
    this.shadowOffset = 6,
    this.clip = false,
  });

  final Widget child;
  final Color color;
  final EdgeInsets padding;
  final double borderWidth;
  final double shadowOffset;
  final bool clip;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      clipBehavior: clip ? Clip.hardEdge : Clip.none,
      decoration: BoxDecoration(
        color: color,
        border: Border.all(color: AppColors.black, width: borderWidth),
        boxShadow: [
          BoxShadow(
            color: AppColors.black,
            offset: Offset(shadowOffset, shadowOffset),
            blurRadius: 0,
          ),
        ],
      ),
      child: child,
    );
  }
}