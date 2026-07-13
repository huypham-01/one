import 'package:mobile/cmms/domain/repositories/report_repository.dart';

class SubmitRepairResultUseCase {
  final ReportRepository repository;

  SubmitRepairResultUseCase({required this.repository});

  Future<void> execute({
    required String breakdownUuid,
    required String issueTypeUuid,
    required String methodTypeUuid,
    required String otp,
  }) async {
    return await repository.submitRepairResult(
      breakdownUuid: breakdownUuid,
      issueTypeUuid: issueTypeUuid,
      methodTypeUuid: methodTypeUuid,
      otp: otp,
    );
  }
}
