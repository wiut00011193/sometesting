import 'package:mars_it_app/mars_space/features/domain/entity/request/delete_child_request_entity.dart';

class DeleteChildRequestModel extends DeleteChildRequestEntity {
  DeleteChildRequestModel({required super.id});

  Map<String, dynamic> toJson() {
    return {
      'id': id,
    };
  }
}