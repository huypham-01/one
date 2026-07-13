// lib/cmms/domain/entities/issue_entity.dart

enum IssueStatus { onWait, fixed, inProgress, cancelled }
enum Shift { day, night }

class IssueEntity {
  final String machineCode;
  final String category;
  final String family;
  final String issueCode;
  final String issueDescription;
  final Shift shift;
  final IssueStatus status;
  final String reportedBy;
  final String reportedAt;
  final String? method;
  final String? fixedBy;
  final String? fixedAt;
  final String downtime;

  IssueEntity({
    required this.machineCode,
    required this.category,
    required this.family,
    required this.issueCode,
    required this.issueDescription,
    required this.shift,
    required this.status,
    required this.reportedBy,
    required this.reportedAt,
    this.method,
    this.fixedBy,
    this.fixedAt,
    required this.downtime,
  });
}
