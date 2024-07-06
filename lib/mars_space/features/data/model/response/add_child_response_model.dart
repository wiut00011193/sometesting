import 'package:mars_it_app/mars_space/features/domain/entity/response/add_child_response_entity.dart';

class AddChildResponseModel extends AddChildResponseEntity {
  AddChildResponseModel({
    required super.parentId,
    required super.studentId,
    required super.id,
    required super.uuid,
    required super.createdAt,
  });

  factory AddChildResponseModel.fromJson(Map<String, dynamic> json) {
    return AddChildResponseModel(
      parentId: json['parent_id'] as int?,
      studentId: json['student_id'] as int?,
      id: json['id'] as int?,
      uuid: json['uuid'] as String?,
      createdAt: json['created_at'] as String?,
    );
  }
}
