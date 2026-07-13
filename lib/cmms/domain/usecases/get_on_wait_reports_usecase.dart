// lib/cmms/domain/usecases/get_on_wait_reports_usecase.dart

import 'package:mobile/cmms/data/models/breakdown_report_model.dart';
import 'package:mobile/cmms/domain/repositories/report_repository.dart';

class GetOnWaitReportsUseCase {
  final ReportRepository repository;

  GetOnWaitReportsUseCase({required this.repository});

  Future<BreakdownReportPage> execute({
    required int page,
    required int limit,
  }) async {
    return await repository.getOnWaitReports(
      page: page,
      limit: limit,
    );
  }
}
