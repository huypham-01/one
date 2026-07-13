import 'package:mobile/cmms/data/datasources/report_remote_datasource.dart';
import 'package:mobile/cmms/data/models/repair_method_model.dart';
import 'package:mobile/cmms/data/models/issue_type_model.dart';
import 'package:mobile/cmms/data/models/equipment.dart';
import 'package:mobile/cmms/data/models/breakdown_report_model.dart';
import 'package:mobile/cmms/domain/repositories/report_repository.dart';

class ReportRepositoryImpl implements ReportRepository {
  final ReportRemoteDataSource remoteDataSource;

  ReportRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<RepairMethodModel>> getRepairMethods() async {
    return await remoteDataSource.getRepairMethods();
  }

  @override
  Future<List<IssueTypeModel>> getIssueTypes() async {
    return await remoteDataSource.getIssueTypes();
  }

  @override
  Future<EquipmentData> getEquipmentByMachineId(String machineId) async {
    return await remoteDataSource.getEquipmentByMachineId(machineId);
  }

  @override
  Future<void> submitRepairResult({
    required String breakdownUuid,
    required String issueTypeUuid,
    required String methodTypeUuid,
    required String otp,
  }) async {
    return await remoteDataSource.submitRepairResult(
      breakdownUuid: breakdownUuid,
      issueTypeUuid: issueTypeUuid,
      methodTypeUuid: methodTypeUuid,
      otp: otp,
    );
  }

  @override
  Future<BreakdownReportPage> getAllReports({
    required int page,
    required int limit,
    required String search,
  }) async {
    return await remoteDataSource.getAllReports(
      page: page,
      limit: limit,
      search: search,
    );
  }

  @override
  Future<BreakdownReportPage> getOnWaitReports({
    required int page,
    required int limit,
  }) async {
    return await remoteDataSource.getOnWaitReports(
      page: page,
      limit: limit,
    );
  }
}
