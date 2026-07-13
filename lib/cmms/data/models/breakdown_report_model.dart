// lib/cmms/data/models/breakdown_report_model.dart

class BreakdownReportModel {
  final String uuid;
  final String machineId;
  final String equipmentUuid;
  final String shift;
  final String status;
  final String? description;
  final String createdAt;
  final String? updatedAt;
  final String? issueCode;
  final String? issueVi;
  final String? issueCn;
  final String? family;
  final String? category;
  final String? reportedByName;
  final String? reportedByEmployeeId;
  final String? maintenanceUuid;
  final String? note;
  final String? fixedAt;
  final String? methodCode;
  final String? methodVi;
  final String? fixedByName;
  final String? fixedByEmployeeId;

  BreakdownReportModel({
    required this.uuid,
    required this.machineId,
    required this.equipmentUuid,
    required this.shift,
    required this.status,
    this.description,
    required this.createdAt,
    this.updatedAt,
    this.issueCode,
    this.issueVi,
    this.issueCn,
    this.family,
    this.category,
    this.reportedByName,
    this.reportedByEmployeeId,
    this.maintenanceUuid,
    this.note,
    this.fixedAt,
    this.methodCode,
    this.methodVi,
    this.fixedByName,
    this.fixedByEmployeeId,
  });

  factory BreakdownReportModel.fromJson(Map<String, dynamic> json) {
    return BreakdownReportModel(
      uuid: json['uuid'] ?? '',
      machineId: json['machine_id'] ?? '',
      equipmentUuid: json['equipment_uuid'] ?? '',
      shift: json['shift'] ?? 'day',
      status: json['status'] ?? 'on_wait',
      description: json['description'],
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'],
      issueCode: json['issue_code'],
      issueVi: json['issue_vi'],
      issueCn: json['issue_cn'],
      family: json['family'],
      category: json['category'],
      reportedByName: json['reported_by_name'],
      reportedByEmployeeId: json['reported_by_employee_id'],
      maintenanceUuid: json['maintenance_uuid'],
      note: json['note'],
      fixedAt: json['fixed_at'],
      methodCode: json['method_code'],
      methodVi: json['method_vi'],
      fixedByName: json['fixed_by_name'],
      fixedByEmployeeId: json['fixed_by_employee_id'],
    );
  }
}

class BreakdownReportPage {
  final List<BreakdownReportModel> data;
  final int totalItems;
  final int totalPages;
  final int page;
  final int limit;

  BreakdownReportPage({
    required this.data,
    required this.totalItems,
    required this.totalPages,
    required this.page,
    required this.limit,
  });

  factory BreakdownReportPage.fromJson(Map<String, dynamic> json) {
    final List<dynamic> rawData = json['data'] ?? [];
    return BreakdownReportPage(
      data: rawData.map((e) => BreakdownReportModel.fromJson(e)).toList(),
      totalItems: int.tryParse(json['total_items']?.toString() ?? '0') ?? 0,
      totalPages: int.tryParse(json['total_pages']?.toString() ?? '1') ?? 1,
      page: int.tryParse(json['page']?.toString() ?? '1') ?? 1,
      limit: int.tryParse(json['limit']?.toString() ?? '10') ?? 10,
    );
  }
}
