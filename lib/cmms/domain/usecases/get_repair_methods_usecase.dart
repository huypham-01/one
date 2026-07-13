import 'package:mobile/cmms/data/models/repair_method_model.dart';
import 'package:mobile/cmms/domain/repositories/report_repository.dart';

class GetRepairMethodsUseCase {
  final ReportRepository repository;

  GetRepairMethodsUseCase({required this.repository});

  Future<List<RepairMethodModel>> execute() async {
    return await repository.getRepairMethods();
  }
}
