import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class NeoButton extends StatefulWidget {
  const NeoButton({
    super.key,
    required this.label,
    required this.onTap,
    this.color = AppColors.lime,
    this.textColor = AppColors.black,
    this.fontSize = 13,
    this.padding = const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
  });

  final String label;
  final VoidCallback? onTap; // null = disabled
  final Color color;
  final Color textColor;
  final double fontSize;
  final EdgeInsets padding;

  @override
  State<NeoButton> createState() => _NeoButtonState();
}

class _NeoButtonState extends State<NeoButton> {
  bool _down = false;

  @override
  Widget build(BuildContext context) {
    final enabled = widget.onTap != null;
    final pressed = _down && enabled;
    final shadow = pressed ? 1.0 : 4.0;
    final shift = pressed ? 3.0 : 0.0;

    return MouseRegion(
      cursor:
          enabled ? SystemMouseCursors.click : SystemMouseCursors.forbidden,
      child: GestureDetector(
        onTapDown: enabled ? (_) => setState(() => _down = true) : null,
        onTapUp: (_) => setState(() => _down = false),
        onTapCancel: () => setState(() => _down = false),
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 70),
          transform: Matrix4.translationValues(shift, shift, 0),
          padding: widget.padding,
          decoration: BoxDecoration(
            color: enabled ? widget.color : AppColors.grey,
            border: Border.all(color: AppColors.black, width: 3),
            boxShadow: [
              BoxShadow(
                color: AppColors.black,
                offset: Offset(shadow, shadow),
                blurRadius: 0,
              ),
            ],
          ),
          child: Text(
            widget.label,
            textAlign: TextAlign.center,
            style: AppText.label(
              widget.fontSize,
              color: enabled ? widget.textColor : Colors.black38,
            ),
          ),
        ),
      ),
    );
  }
}