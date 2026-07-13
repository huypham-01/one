// lib/cmms/domain/usecases/get_all_reports_usecase.dart

import 'package:mobile/cmms/data/models/breakdown_report_model.dart';
import 'package:mobile/cmms/domain/repositories/report_repository.dart';

class GetAllReportsUseCase {
  final ReportRepository repository;

  GetAllReportsUseCase({required this.repository});

  Future<BreakdownReportPage> execute({
    required int page,
    required int limit,
    required String search,
  }) async {
    return await repository.getAllReports(
      page: page,
      limit: limit,
      search: search,
    );
  }
}
