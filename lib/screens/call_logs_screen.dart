import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../widgets/app_background.dart';
import '../widgets/call_log_tile.dart';
// API Service Import Kiya
import '../services/api_services.dart';

class CallLogsScreen extends StatefulWidget {
  const CallLogsScreen({super.key});

  @override
  State<CallLogsScreen> createState() => _CallLogsScreenState();
}

class _CallLogsScreenState extends State<CallLogsScreen> {
  String _selectedFilter = 'All';

  final List<Map<String, dynamic>> _logs = const [
    {
      'number': '+1 (555) 019-2831',
      'time': 'Jun 18, 11:32 AM',
      'label': 'SCAM',
      'color': AppColors.danger,
    },
    {
      'number': '+1 (800) 123-4567',
      'time': 'Jun 17, 4:15 PM',
      'label': 'SUSPICIOUS',
      'color': AppColors.suspicious,
    },
    {
      'number': '+1 (555) 987-6543',
      'time': 'Jun 17, 1:05 PM',
      'label': 'SAFE',
      'color': AppColors.safe,
    },
    {
      'number': '+1 (212) 555-7789',
      'time': 'Jun 16, 9:20 AM',
      'label': 'SAFE',
      'color': AppColors.safe,
    },
  ];

  List<String> get _filters => const ['All', 'Scam', 'Suspicious', 'Safe'];

  List<Map<String, dynamic>> get _filteredLogs {
    if (_selectedFilter == 'All') return _logs;
    return _logs
        .where((log) =>
            (log['label'] as String).toLowerCase() ==
            _selectedFilter.toLowerCase())
        .toList();
  }

  Widget _filterChip(String label) {
    final isActive = _selectedFilter == label;
    Color chipColor = AppColors.cardBg;
    Color textColor = AppColors.textSecondary;

    if (isActive) {
      chipColor = label == 'All'
          ? AppColors.teal
          : label == 'Scam'
              ? AppColors.danger
              : label == 'Suspicious'
                  ? AppColors.suspicious
                  : AppColors.safe;
      textColor = Colors.white;
    }

    return GestureDetector(
      onTap: () => setState(() => _selectedFilter = label),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: chipColor,
          borderRadius: BorderRadius.circular(100),
          border: Border.all(color: AppColors.cardBorder),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: textColor,
            fontSize: 12,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppBackground(
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Call Logs',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.72),
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: AppColors.cardBorder),
                    ),
                    child: const TextField(
                      decoration: InputDecoration(
                        icon: Icon(Icons.search_rounded,
                            color: AppColors.textSecondary),
                        hintText: 'Search calls',
                        hintStyle: TextStyle(color: AppColors.textSecondary),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        ..._filters.map(
                          (filter) => Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: _filterChip(filter),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                itemCount: _filteredLogs.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final log = _filteredLogs[index];

                  // Wrap with GestureDetector for log push activity
                  return GestureDetector(
                    onTap: () async {
                      int defaultScore = log['label'] == 'SCAM'
                          ? 95
                          : log['label'] == 'SUSPICIOUS'
                              ? 55
                              : 10;
                      String notionStatus = log['label'] == 'SCAM'
                          ? 'Scam'
                          : log['label'] == 'SUSPICIOUS'
                              ? 'Suspicious'
                              : 'Safe';

                      bool isSuccess = await ApiService.addCallLog(
                        title: "Archived Log Pushed From List",
                        callerId: log['number'] as String,
                        status: notionStatus,
                        threatScore: defaultScore,
                      );

                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(isSuccess
                                ? '📁 Call log synced to Notion database!'
                                : '❌ Sync Error.'),
                          ),
                        );
                      }
                    },
                    child: CallLogTile(
                      phoneNumber: log['number'] as String,
                      timeLabel: log['time'] as String,
                      label: log['label'] as String,
                      iconColor: log['color'] as Color,
                    ),
                  );
                },
              ),
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.82),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.cardBorder),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x14000000),
                    blurRadius: 20,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _StatFooterItem(
                      value: '24', label: 'Total', color: AppColors.tealDark),
                  _StatFooterItem(
                      value: '3', label: 'Scams', color: AppColors.danger),
                  _StatFooterItem(
                      value: '7',
                      label: 'Suspicious',
                      color: AppColors.suspicious),
                  _StatFooterItem(
                      value: '14', label: 'Safe', color: AppColors.safe),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatFooterItem extends StatelessWidget {
  const _StatFooterItem({
    required this.value,
    required this.label,
    required this.color,
  });

  final String value;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            color: color,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: 11,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
