import 'package:mobile/cmms/data/models/repair_method_model.dart';
import 'package:mobile/cmms/data/models/issue_type_model.dart';
import 'package:mobile/cmms/data/models/equipment.dart';
import 'package:mobile/cmms/data/models/breakdown_report_model.dart';

abstract class ReportRepository {
  Future<List<RepairMethodModel>> getRepairMethods();
  Future<List<IssueTypeModel>> getIssueTypes();
  Future<EquipmentData> getEquipmentByMachineId(String machineId);
  Future<void> submitRepairResult({
    required String breakdownUuid,
    required String issueTypeUuid,
    required String methodTypeUuid,
    required String otp,
  });
  Future<BreakdownReportPage> getAllReports({
    required int page,
    required int limit,
    required String search,
  });
  Future<BreakdownReportPage> getOnWaitReports({
    required int page,
    required int limit,
  });
}
