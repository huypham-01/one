import 'package:flutter/material.dart';
import 'package:mobile/cmms/data/models/repair_method_model.dart';
import 'package:mobile/cmms/data/models/issue_type_model.dart';
import 'package:mobile/cmms/data/models/equipment.dart';
import 'package:mobile/cmms/domain/usecases/get_repair_methods_usecase.dart';
import 'package:mobile/cmms/domain/usecases/get_issue_types_usecase.dart';
import 'package:mobile/cmms/domain/usecases/get_equipment_by_machine_id_usecase.dart';
import 'package:mobile/cmms/domain/usecases/submit_repair_result_usecase.dart';

class ReportProvider extends ChangeNotifier {
  final GetRepairMethodsUseCase getRepairMethodsUseCase;
  final GetIssueTypesUseCase getIssueTypesUseCase;
  final GetEquipmentByMachineIdUseCase getEquipmentByMachineIdUseCase;
  final SubmitRepairResultUseCase submitRepairResultUseCase;

  ReportProvider({
    required this.getRepairMethodsUseCase,
    required this.getIssueTypesUseCase,
    required this.getEquipmentByMachineIdUseCase,
    required this.submitRepairResultUseCase,
  });

  bool _isLoadingMethods = false;
  bool get isLoadingMethods => _isLoadingMethods;

  bool _isLoadingIssues = false;
  bool get isLoadingIssues => _isLoadingIssues;

  bool _isLoadingEquipment = false;
  bool get isLoadingEquipment => _isLoadingEquipment;

  bool _isSubmitting = false;
  bool get isSubmitting => _isSubmitting;

  List<RepairMethodModel> _repairMethods = [];
  List<RepairMethodModel> get repairMethods => _repairMethods;

  List<IssueTypeModel> _issueTypes = [];
  List<IssueTypeModel> get issueTypes => _issueTypes;

  EquipmentData? _equipment;
  EquipmentData? get equipment => _equipment;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  String? _submitErrorMessage;
  String? get submitErrorMessage => _submitErrorMessage;

  bool _submitSuccess = false;
  bool get submitSuccess => _submitSuccess;

  Future<void> fetchRepairMethods() async {
    _isLoadingMethods = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final methods = await getRepairMethodsUseCase.execute();
      _repairMethods = methods;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoadingMethods = false;
      notifyListeners();
    }
  }

  Future<void> fetchIssueTypes() async {
    _isLoadingIssues = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final issues = await getIssueTypesUseCase.execute();
      _issueTypes = issues;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoadingIssues = false;
      notifyListeners();
    }
  }

  Future<void> fetchEquipmentByMachineId(String machineId) async {
    _isLoadingEquipment = true;
    _equipment = null;
    _errorMessage = null;
    notifyListeners();

    try {
      _equipment = await getEquipmentByMachineIdUseCase.execute(machineId);
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoadingEquipment = false;
      notifyListeners();
    }
  }

  Future<void> submitRepairResult({
    required String breakdownUuid,
    required String issueTypeUuid,
    required String methodTypeUuid,
    required String otp,
  }) async {
    _isSubmitting = true;
    _submitErrorMessage = null;
    _submitSuccess = false;
    notifyListeners();

    try {
      await submitRepairResultUseCase.execute(
        breakdownUuid: breakdownUuid,
        issueTypeUuid: issueTypeUuid,
        methodTypeUuid: methodTypeUuid,
        otp: otp,
      );
      _submitSuccess = true;
    } catch (e) {
      _submitErrorMessage = e.toString();
    } finally {
      _isSubmitting = false;
      notifyListeners();
    }
  }

  void resetSubmitState() {
    _submitSuccess = false;
    _submitErrorMessage = null;
    _equipment = null;
  }
}
