import 'package:flutter/material.dart';
import '../../../design_system/tokens/colors.dart';

class WidgetIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final Color? backgroundColor;
  final Color? iconColor;

  const WidgetIconButton({
    super.key,
    required this.icon,
    required this.onTap,
    this.backgroundColor,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: backgroundColor ?? AppColors.neutral100,
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Icon(icon, color: iconColor ?? AppColors.neutral700, size: 20),
        ),
      ),
    );
  }
}
