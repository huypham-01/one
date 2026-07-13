class IssueTypeModel {
  final String uuid;
  final String machineType;
  final String issueCode;
  final String issueVi;
  final String issueCn;

  IssueTypeModel({
    required this.uuid,
    required this.machineType,
    required this.issueCode,
    required this.issueVi,
    required this.issueCn,
  });

  factory IssueTypeModel.fromJson(Map<String, dynamic> json) {
    return IssueTypeModel(
      uuid: json['uuid'] ?? '',
      machineType: json['machine_type'] ?? '',
      issueCode: json['issue_code'] ?? '',
      issueVi: json['issue_vi'] ?? '',
      issueCn: json['issue_cn'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uuid': uuid,
      'machine_type': machineType,
      'issue_code': issueCode,
      'issue_vi': issueVi,
      'issue_cn': issueCn,
    };
  }

  String getDisplayName() {
    return issueVi.isNotEmpty ? issueVi : issueCode;
  }

  String getDisplayNameByLocale(String languageCode) {
    if (languageCode == 'zh') {
      return issueCn.isNotEmpty ? issueCn : issueCode;
    }
    return issueVi.isNotEmpty ? issueVi : issueCode;
  }
}
