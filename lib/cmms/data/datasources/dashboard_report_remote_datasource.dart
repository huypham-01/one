import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:mobile/cmms/data/models/dashboard_report_model.dart';
import 'package:mobile/cmms/data/services/api_service.dart';
import 'package:mobile/utils/constants.dart';

abstract class DashboardReportRemoteDatasource {
  Future<DashboardReportModel> getDashboardStats();
}

class DashboardReportRemoteDatasourceImpl
    implements DashboardReportRemoteDatasource {
  @override
  Future<DashboardReportModel> getDashboardStats() async {
    final url = Uri.parse(
      '$baseUrl/cmms/cip3/index.php?c=BreakdownDashboardController&m=getStats',
    );

    try {
      final token = await ApiService.getToken();

      final response = await http
          .get(
            url,
            headers: {
              'Content-Type': 'application/json',
              if (token != null) 'Authorization': 'Bearer $token',
            },
          )
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);

        if (body['status'] == 'success' && body['data'] != null) {
          return DashboardReportModel.fromJson(
            body['data'] as Map<String, dynamic>,
          );
        }

        throw Exception(body['message'] ?? 'Failed to load dashboard report');
      }

      throw Exception(
        'HTTP ${response.statusCode}: Failed to load dashboard report',
      );
    } catch (e) {
      throw Exception('Error calling API: $e');
    }
  }
}
