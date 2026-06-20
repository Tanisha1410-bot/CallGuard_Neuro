import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class ThreatGauge extends StatelessWidget {
  final double value; // 0.0 to 1.0
  final double strokeWidth;

  const ThreatGauge({
    super.key,
    required this.value,
    this.strokeWidth = 10,
  });

  Color _getColor(double val) {
    if (val < 0.3) return AppColors.safe;
    if (val < 0.7) return AppColors.suspicious;
    return AppColors.danger;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 140,
      height: 140,
      child: CircularProgressIndicator(
        value: value,
        strokeWidth: strokeWidth,
        backgroundColor: Colors.grey.withOpacity(0.15),
        color: _getColor(value),
        strokeCap: StrokeCap.round,
      ),
    );
  }
}
