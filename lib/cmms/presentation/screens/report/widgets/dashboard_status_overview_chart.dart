import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../../domain/entities/dashboard_report_entity.dart';

class DashboardStatusOverviewChart extends StatelessWidget {
  final DashboardReportEntity dashboard;

  const DashboardStatusOverviewChart({
    super.key,
    required this.dashboard,
  });

  @override
  Widget build(BuildContext context) {
    final int total = dashboard.total;
    final int onWait = dashboard.onWait;
    final int fixed = total - onWait;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.04),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Status Overview',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF111827),
                ),
              ),
              Text(
                'All time',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF6B7280).withOpacity(0.8),
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          SizedBox(
            height: 200,
            child: Stack(
              children: [
                PieChart(
                  PieChartData(
                    sectionsSpace: 0,
                    centerSpaceRadius: 70,
                    startDegreeOffset: -90,
                    sections: _buildPieChartSections(onWait, fixed, total),
                  ),
                ),
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '$total',
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF111827),
                          height: 1.1,
                        ),
                      ),
                      const Text(
                        'TOTAL',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF6B7280),
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          _buildLegendItem('On Wait', onWait, const Color(0xFFFF6B6B)),
          const SizedBox(height: 16),
          _buildLegendItem('Fixed', fixed, const Color(0xFF20C997)),
        ],
      ),
    );
  }

  List<PieChartSectionData> _buildPieChartSections(int onWait, int fixed, int total) {
    if (total == 0) {
      return [
        PieChartSectionData(
          color: const Color(0xFFE5E7EB),
          value: 1,
          title: '',
          radius: 24,
        ),
      ];
    }

    return [
      PieChartSectionData(
        color: const Color(0xFF20C997), // Green for fixed
        value: fixed.toDouble(),
        title: '',
        radius: 24,
      ),
      PieChartSectionData(
        color: const Color(0xFFFF6B6B), // Red for on wait
        value: onWait.toDouble(),
        title: '',
        radius: 24,
      ),
    ];
  }

  Widget _buildLegendItem(String title, int value, Color color) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: Color(0xFF111827),
          ),
        ),
        const Spacer(),
        Text(
          '$value',
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: Color(0xFF111827),
          ),
        ),
      ],
    );
  }
}
