class GetStudentResponseEntity {
  int? id;
  String? name;
  List<Group>? groups;

  GetStudentResponseEntity({
    required this.id,
    required this.name,
    required this.groups,
  });
}

class Group {
  int? id;
  String? name;
  int? categoryId;
  int? externalId;
  String? dateStarted;
  String? dateFinished;
  int? status;

  Group({
    required this.id,
    required this.name,
    required this.categoryId,
    required this.externalId,
    required this.dateStarted,
    required this.dateFinished,
    required this.status,
  });
}
