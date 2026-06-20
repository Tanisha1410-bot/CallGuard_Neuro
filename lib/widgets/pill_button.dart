import 'package:flutter/material.dart';

class PillButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final IconData icon;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final Color? borderColor;
  final bool isFilled;

  const PillButton.filled({
    super.key,
    required this.label,
    required this.onPressed,
    required this.icon,
    this.backgroundColor,
    this.foregroundColor,
  })  : borderColor = null,
        isFilled = true;

  const PillButton.outlined({
    super.key,
    required this.label,
    required this.onPressed,
    required this.icon,
    this.borderColor,
    this.foregroundColor,
  })  : backgroundColor = null,
        isFilled = false;

  @override
  Widget build(BuildContext context) {
    if (isFilled) {
      return ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 20),
        label: Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: foregroundColor,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: const StadiumBorder(),
          elevation: 0,
        ),
      );
    } else {
      return OutlinedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 20),
        label: Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
        style: OutlinedButton.styleFrom(
          foregroundColor: foregroundColor,
          side: BorderSide(color: borderColor ?? Colors.transparent, width: 1.5),
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: const StadiumBorder(),
        ),
      );
    }
  }
}
