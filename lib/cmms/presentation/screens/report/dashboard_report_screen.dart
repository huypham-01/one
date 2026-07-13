import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../data/datasources/dashboard_report_remote_datasource.dart';
import '../../../data/repositories/dashboard_report_repository_impl.dart';
import '../../../domain/usecases/get_dashboard_report_usecase.dart';
import '../../providers/dashboard_report_provider.dart';
import 'widgets/dashboard_category_chart.dart';
import 'widgets/dashboard_skeleton_loading.dart';
import 'widgets/dashboard_status_overview_chart.dart';
import 'widgets/dashboard_summary_section.dart';
import 'widgets/dashboard_trend_chart.dart';

class DashboardReportScreen extends StatelessWidget {
  const DashboardReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) {
        final datasource = DashboardReportRemoteDatasourceImpl();
        final repository = DashboardReportRepositoryImpl(datasource);
        final usecase = GetDashboardReportUseCase(repository);
        return DashboardReportProvider(usecase);
      },
      child: const _DashboardReportView(),
    );
  }
}

class _DashboardReportView extends StatelessWidget {
  const _DashboardReportView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      body: Consumer<DashboardReportProvider>(
        builder: (context, provider, child) {
          return RefreshIndicator(
            onRefresh: () async {
              await provider.loadDashboardReport();
            },
            child: _buildBody(context, provider),
          );
        },
      ),
    );
  }

  Widget _buildBody(BuildContext context, DashboardReportProvider provider) {
    if (provider.state == DashboardReportState.loading ||
        provider.state == DashboardReportState.initial) {
      return const DashboardSkeletonLoading();
    } else if (provider.state == DashboardReportState.error) {
      return ListView(
        children: [
          SizedBox(height: MediaQuery.of(context).size.height * 0.3),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, color: Colors.red, size: 48),
                const SizedBox(height: 16),
                const Text('Unable to load dashboard.'),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    provider.loadDashboardReport();
                  },
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        ],
      );
    } else if (provider.state == DashboardReportState.loaded) {
      final dashboard = provider.dashboard;

      if (dashboard == null ||
          dashboard.categoryBreakdown.isEmpty ||
          dashboard.trend7d.isEmpty) {
        return ListView(
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.3),
            const Center(
              child: Text(
                'No dashboard data available.',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ),
          ],
        );
      }

      return SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DashboardSummarySection(dashboard: dashboard),
            const SizedBox(height: 16),
            DashboardStatusOverviewChart(dashboard: dashboard),
            const SizedBox(height: 16),
            DashboardCategoryChart(categories: dashboard.categoryBreakdown),
            const SizedBox(height: 16),
            DashboardTrendChart(trendData: dashboard.trend7d),
            const SizedBox(height: 16),
          ],
        ),
      );
    }

    return const SizedBox.shrink();
  }
}
