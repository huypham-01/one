import '../entities/dashboard_report_entity.dart';

abstract class DashboardReportRepository {
  Future<DashboardReportEntity> getDashboardStats();
}
