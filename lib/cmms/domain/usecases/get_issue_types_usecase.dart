import 'package:mobile/cmms/data/models/issue_type_model.dart';
import 'package:mobile/cmms/domain/repositories/report_repository.dart';

class GetIssueTypesUseCase {
  final ReportRepository repository;

  GetIssueTypesUseCase({required this.repository});

  Future<List<IssueTypeModel>> execute() async {
    return await repository.getIssueTypes();
  }
}
