import '../../../domain/entity/request/add_child_request_entity.dart';

class AddChildRequestModel extends AddChildRequestEntity {
  AddChildRequestModel({
    required super.externalId,
    required super.code,
    required super.role,
  });

  Map<String, dynamic> toJson() {
    return {
      'external_id': externalId,
      'code': code,
      'role': role,
    };
  }
}
