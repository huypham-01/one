import 'package:flutter/material.dart';

import '../../../../../utils/routes/cmms_routes.dart';
import '../../../../domain/entities/dashboard_report_entity.dart';

class DashboardSummarySection extends StatelessWidget {
  final DashboardReportEntity dashboard;
  final ValueChanged<int>? onCardTap;

  const DashboardSummarySection({
    super.key,
    required this.dashboard,
    this.onCardTap,
  });

  @override
  Widget build(BuildContext context) {
    final cards = <_SummaryCardData>[
      _SummaryCardData(
        title: 'Waiting for Repair',
        value: dashboard.onWait,
        icon: Icons.warning_rounded,
        color: const Color(0xFFEF4444),
        route: CmmsRoutes.waitingRepairTemplate,
      ),
      _SummaryCardData(
        title: 'Reported Today',
        value: dashboard.todayTotal,
        icon: Icons.access_time_rounded,
        color: const Color(0xFF6366F1),
        route: CmmsRoutes.reportedTodayTemplate,
      ),
      _SummaryCardData(
        title: 'Fixed Today',
        value: dashboard.todayFixed,
        icon: Icons.check_circle_rounded,
        color: const Color(0xFF22C55E),
        route: CmmsRoutes.fixedTodayTemplate,
      ),
      _SummaryCardData(
        title: 'Total History',
        value: dashboard.total,
        icon: Icons.build_rounded,
        color: const Color(0xFFA855F7),
        route: CmmsRoutes.breakHistory,
      ),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: cards.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.8,
      ),
      itemBuilder: (context, index) {
        final data = cards[index];
        return _SummaryCard(
          data: data,
          onTap: () {
            if (onCardTap != null) {
              onCardTap!(index);
            }
            if (data.route.isNotEmpty) {
              Navigator.pushNamed(context, data.route);
            }
          },
        );
      },
    );
  }
}

class _SummaryCardData {
  final String title;
  final int value;
  final IconData icon;
  final Color color;
  final String route;

  const _SummaryCardData({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    required this.route,
  });
}

class _SummaryCard extends StatelessWidget {
  final _SummaryCardData data;
  final VoidCallback? onTap;

  const _SummaryCard({required this.data, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.04),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: data.color.withOpacity(.12),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(data.icon, color: data.color, size: 28),
            ),

            const SizedBox(width: 16),

            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TweenAnimationBuilder<int>(
                    tween: IntTween(begin: 0, end: data.value),
                    duration: const Duration(milliseconds: 500),
                    builder: (context, value, _) {
                      return Text(
                        "$value",
                        style: const TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w800,
                          color: Color(0xff111827),
                          height: 1,
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 6),

                  Text(
                    data.title,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Color(0xff6B7280),
                      height: 1.2,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
