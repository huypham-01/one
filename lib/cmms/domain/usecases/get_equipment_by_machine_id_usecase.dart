import 'package:mobile/cmms/data/models/equipment.dart';
import 'package:mobile/cmms/domain/repositories/report_repository.dart';

class GetEquipmentByMachineIdUseCase {
  final ReportRepository repository;

  GetEquipmentByMachineIdUseCase({required this.repository});

  Future<EquipmentData> execute(String machineId) async {
    return await repository.getEquipmentByMachineId(machineId);
  }
}
