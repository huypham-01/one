import '../entities/dashboard_report_entity.dart';
import '../repositories/dashboard_report_repository.dart';

class GetDashboardReportUseCase {
  final DashboardReportRepository repository;

  GetDashboardReportUseCase(this.repository);

  Future<DashboardReportEntity> call() async {
    return await repository.getDashboardStats();
  }
}
