import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mobile/utils/constants.dart';
import 'package:mobile/cmms/data/models/repair_method_model.dart';
import 'package:mobile/cmms/data/models/issue_type_model.dart';
import 'package:mobile/cmms/data/models/equipment.dart';
import 'package:mobile/cmms/data/models/breakdown_report_model.dart';
import 'package:mobile/cmms/data/services/api_service.dart';

abstract class ReportRemoteDataSource {
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

class ReportRemoteDataSourceImpl implements ReportRemoteDataSource {
  @override
  Future<List<RepairMethodModel>> getRepairMethods() async {
    final url = Uri.parse(
        '$baseUrl/cmms/cip3/index.php?c=BreakdownMasterController&m=getMethodTypes');

    try {
      final token = await ApiService.getToken();

      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
      ).timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        if (body['status'] == 'success' && body['data'] != null) {
          final List<dynamic> data = body['data'];
          return data.map((json) => RepairMethodModel.fromJson(json)).toList();
        }
      }
      throw Exception('Failed to load repair methods from API');
    } catch (e) {
      throw Exception('Error calling API: $e');
    }
  }

  @override
  Future<List<IssueTypeModel>> getIssueTypes() async {
    final url = Uri.parse(
        '$baseUrl/cmms/cip3/index.php?c=BreakdownMasterController&m=getIssueTypes&limit=200&page=1');

    try {
      final token = await ApiService.getToken();

      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
      ).timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        if (body['status'] == 'success' && body['data'] != null) {
          final List<dynamic> data = body['data'];
          return data.map((json) => IssueTypeModel.fromJson(json)).toList();
        }
      }
      throw Exception('Failed to load issue types from API');
    } catch (e) {
      throw Exception('Error calling API: $e');
    }
  }

  @override
  Future<EquipmentData> getEquipmentByMachineId(String machineId) async {
    final url = Uri.parse(
        '$baseUrl/cmms/cip3/?c=EquipmentController&m=getEquipmentByMachineId&machine_id=$machineId');

    try {
      final token = await ApiService.getToken();

      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
      ).timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        if (body['status'] == 'success' && body['data'] != null) {
          return EquipmentData.fromJson(body['data'] as Map<String, dynamic>);
        }
        throw Exception(body['message'] ?? 'Failed to load equipment');
      }
      throw Exception('HTTP ${response.statusCode}: Failed to load equipment');
    } catch (e) {
      throw Exception('Error calling API: $e');
    }
  }

  @override
  Future<void> submitRepairResult({
    required String breakdownUuid,
    required String issueTypeUuid,
    required String methodTypeUuid,
    required String otp,
  }) async {
    final url = Uri.parse(
        '$baseUrl/cmms/cip3/index.php?c=BreakdownController&m=fix');

    try {
      final token = await ApiService.getToken();

      final payload = jsonEncode({
        'breakdown_uuid': breakdownUuid,
        'issue_type_uuid': issueTypeUuid,
        'method_type_uuid': methodTypeUuid,
        'otp': otp,
      });

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
        body: payload,
      ).timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        if (body['status'] == 'success') return;
        throw Exception(body['message'] ?? 'Submit failed');
      }
      throw Exception('HTTP ${response.statusCode}: Submit failed');
    } catch (e) {
      throw Exception('Error calling API: $e');
    }
  }

  @override
  Future<BreakdownReportPage> getAllReports({
    required int page,
    required int limit,
    required String search,
  }) async {
    final url = Uri.parse(
        '$baseUrl/cmms/cip3/index.php?c=BreakdownController&m=getAllReports&page=$page&limit=$limit&search=${Uri.encodeComponent(search)}');

    try {
      final token = await ApiService.getToken();

      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
      ).timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        if (body['status'] == 'success') {
          return BreakdownReportPage.fromJson(body);
        }
        throw Exception(body['message'] ?? 'Failed to load reports');
      }
      throw Exception('HTTP ${response.statusCode}: Failed to load reports');
    } catch (e) {
      throw Exception('Error calling API: $e');
    }
  }

  @override
  Future<BreakdownReportPage> getOnWaitReports({
    required int page,
    required int limit,
  }) async {
    final url = Uri.parse(
        '$baseUrl/cmms/cip3/index.php?c=BreakdownController&m=getOnWaitReports&page=$page&limit=$limit');

    try {
      final token = await ApiService.getToken();

      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
      ).timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        if (body['status'] == 'success') {
          return BreakdownReportPage.fromJson(body);
        }
        throw Exception(body['message'] ?? 'Failed to load waiting reports');
      }
      throw Exception('HTTP ${response.statusCode}: Failed to load waiting reports');
    } catch (e) {
      throw Exception('Error calling API: $e');
    }
  }
}
