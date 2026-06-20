import 'package:flutter/material.dart';

class AppBackground extends StatelessWidget {
  final Widget child;

  const AppBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark
                ? [
                    const Color(0xFF0F172A), // Dark Navy
                    const Color(0xFF1E293B), // Dark Slate
                  ]
                : [
                    const Color(0xFFF1F5F9), // Light Slate
                    const Color(0xFFE2E8F0), // Lighter Slate
                  ],
          ),
        ),
        child: child,
      ),
    );
  }
}
