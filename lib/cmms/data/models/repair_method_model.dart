class RepairMethodModel {
  final String uuid;
  final String methodCode;
  final String methodVi;
  final String methodCn;

  RepairMethodModel({
    required this.uuid,
    required this.methodCode,
    required this.methodVi,
    required this.methodCn,
  });

  factory RepairMethodModel.fromJson(Map<String, dynamic> json) {
    return RepairMethodModel(
      uuid: json['uuid'] ?? '',
      methodCode: json['method_code'] ?? '',
      methodVi: json['method_vi'] ?? '',
      methodCn: json['method_cn'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uuid': uuid,
      'method_code': methodCode,
      'method_vi': methodVi,
      'method_cn': methodCn,
    };
  }

  // Phương thức hiển thị tên tùy theo ngôn ngữ, mặc định hiện tiếng Việt
  String getDisplayName() {
    return methodVi.isNotEmpty ? methodVi : methodCode;
  }

  String getDisplayNameByLocale(String languageCode) {
    if (languageCode == 'zh') {
      return methodCn.isNotEmpty ? methodCn : methodCode;
    }
    return methodVi.isNotEmpty ? methodVi : methodCode;
  }
}
