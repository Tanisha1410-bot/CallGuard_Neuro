import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../widgets/app_background.dart';
import '../widgets/pill_button.dart';
import '../widgets/threat_gauge.dart';
// API Service Import Kiya
import '../services/api_services.dart';

class LiveCallScreen extends StatefulWidget {
  const LiveCallScreen({super.key});

  @override
  State<LiveCallScreen> createState() => _LiveCallScreenState();
}

class _LiveCallScreenState extends State<LiveCallScreen> {
  bool _holdSelected = false;
  bool _ignoreSelected = false;

  RichText _transcript() {
    return RichText(
      text: const TextSpan(
        style: TextStyle(
          color: AppColors.textSecondary,
          fontSize: 14,
          height: 1.55,
        ),
        children: [
          TextSpan(text: 'The caller says this is an '),
          TextSpan(
            text: 'urgent',
            style: TextStyle(
              color: AppColors.danger,
              fontWeight: FontWeight.w700,
            ),
          ),
          TextSpan(text: ' matter and asks for an '),
          TextSpan(
            text: 'immediate',
            style: TextStyle(
              color: AppColors.danger,
              fontWeight: FontWeight.w700,
            ),
          ),
          TextSpan(text: ' response. They say your account was '),
          TextSpan(
            text: 'flagged',
            style: TextStyle(
              color: AppColors.danger,
              fontWeight: FontWeight.w700,
            ),
          ),
          TextSpan(text: ' and request a '),
          TextSpan(
            text: 'verification code',
            style: TextStyle(
              color: AppColors.danger,
              fontWeight: FontWeight.w700,
            ),
          ),
          TextSpan(text: ' to continue.'),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textPrimary =
        isDark ? AppColors.textPrimaryDark : AppColors.textPrimary;
    final textSecondary =
        isDark ? AppColors.textSecondaryDark : AppColors.textSecondary;
    final surface = isDark
        ? AppColors.cardBgDark.withOpacity(0.84)
        : AppColors.warningBg;
    final border = isDark ? AppColors.cardBorderDark : AppColors.cardBorder;

    return AppBackground(
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.suspicious.withOpacity(0.16),
                  borderRadius: BorderRadius.circular(100),
                ),
                child: const Text(
                  '⚡ LIVE CALL',
                  style: TextStyle(
                    color: AppColors.suspicious,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Unknown',
                style: TextStyle(
                  color: textSecondary,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                '+1 (555) 019-2831',
                style: TextStyle(
                  color: textPrimary,
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 22),
              Center(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    const ThreatGauge(value: 0.55, strokeWidth: 10),
                    Column(
                      children: [
                        const Text(
                          '55',
                          style: TextStyle(
                            color: AppColors.suspicious,
                            fontSize: 28,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          '/100',
                          style: TextStyle(
                            color: textSecondary,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.suspicious.withOpacity(0.16),
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: const Text(
                            '⚠ SUSPICIOUS',
                            style: TextStyle(
                              color: AppColors.suspicious,
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1.1,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 22),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: surface,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: border),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x10000000),
                      blurRadius: 16,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '⚡ LIVE TRANSCRIPT',
                      style: TextStyle(
                        color: AppColors.suspicious,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _transcript(),
                  ],
                ),
              ),
              const SizedBox(height: 22),
              Row(
                children: [
                  Expanded(
                    child: PillButton.outlined(
                      label: _holdSelected ? 'Held' : 'Hold Call',
                      borderColor: AppColors.teal,
                      foregroundColor:
                          _holdSelected ? Colors.white : AppColors.tealDark,
                      onPressed: () =>
                          setState(() => _holdSelected = !_holdSelected),
                      icon: _holdSelected
                          ? Icons.check_rounded
                          : Icons.pause_circle_outline_rounded,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: PillButton.filled(
                      label: _ignoreSelected ? 'Ignored' : 'Ignore Alert',
                      backgroundColor: _ignoreSelected
                          ? (isDark
                              ? AppColors.cardBgDark.withOpacity(0.9)
                              : AppColors.cardBg.withOpacity(0.9))
                          : AppColors.danger,
                      foregroundColor:
                          _ignoreSelected ? AppColors.danger : Colors.white,
                      onPressed: () async {
                        setState(() => _ignoreSelected = !_ignoreSelected);

                        // Ignore trigger hone par data sync logic
                        if (_ignoreSelected) {
                          bool isSuccess = await ApiService.addCallLog(
                            title: "Live Call Guard Alerted",
                            callerId: "+1 (555) 019-2831",
                            status: "Suspicious",
                            threatScore: 55,
                          );

                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(isSuccess
                                    ? '🚀 Live call pushed to Notion!'
                                    : '❌ Sync failed! Check backend server.'),
                              ),
                            );
                          }
                        }
                      },
                      icon: _ignoreSelected
                          ? Icons.check_rounded
                          : Icons.close_rounded,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
