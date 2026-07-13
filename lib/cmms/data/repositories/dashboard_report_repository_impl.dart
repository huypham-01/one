import '../../domain/entities/dashboard_report_entity.dart';
import '../../domain/repositories/dashboard_report_repository.dart';
import '../datasources/dashboard_report_remote_datasource.dart';

class DashboardReportRepositoryImpl implements DashboardReportRepository {
  final DashboardReportRemoteDatasource remoteDatasource;

  DashboardReportRepositoryImpl(this.remoteDatasource);

  @override
  Future<DashboardReportEntity> getDashboardStats() async {
    try {
      final model = await remoteDatasource.getDashboardStats();
      return model.toEntity();
    } catch (e) {
      throw Exception('Failed to get dashboard stats: $e');
    }
  }
}
