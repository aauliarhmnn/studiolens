import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class NeoTag extends StatelessWidget {
  const NeoTag({
    super.key,
    required this.text,
    this.color = AppColors.grey,
    this.textColor = AppColors.black,
    this.fontSize = 11,
    this.shadow = false,
  });

  final String text;
  final Color color;
  final Color textColor;
  final double fontSize;
  final bool shadow;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color,
        border: Border.all(color: AppColors.black, width: 2),
        boxShadow: shadow
            ? const [
                BoxShadow(
                    color: AppColors.black,
                    offset: Offset(3, 3),
                    blurRadius: 0)
              ]
            : null,
      ),
      child: Text(text, style: AppText.label(fontSize, color: textColor)),
    );
  }
}