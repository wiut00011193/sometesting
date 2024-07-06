import 'package:mars_it_app/mars_space/features/domain/entity/response/get_student_response_entity.dart';

class GetStudentResponseModel extends GetStudentResponseEntity {
  GetStudentResponseModel({
    required super.id,
    required super.name,
    required super.groups,
  });

  factory GetStudentResponseModel.fromJson(Map<String, dynamic> json) {
    return GetStudentResponseModel(
      id: json['id'] as int?, 
      name: json['name'] as String?, 
      groups: List<Group>.from(json['groups'].map((x) => GroupModel.fromJson(x))),
    );
  }
}

class GroupModel extends Group {
  GroupModel({
    required super.id,
    required super.name, 
    required super.categoryId, 
    required super.externalId, 
    required super.dateStarted,
    required super.dateFinished,
    required super.status,
  });

  factory GroupModel.fromJson(Map<String, dynamic> json) {
    return GroupModel(
      id: json['id'], 
      name: json['name'], 
      categoryId: json['category_id'], 
      externalId: json['external_id'],
      dateStarted:  json['date_started'],
      dateFinished: json['date_finished'], 
      status: json['status'],
    );
  }
}
