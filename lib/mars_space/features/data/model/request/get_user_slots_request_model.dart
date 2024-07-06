import 'package:mars_it_app/mars_space/features/domain/entity/request/get_user_slots_request_entity.dart';

class GetUserSlotsRequestModel extends GetUserSlotsRequestEntity {
  GetUserSlotsRequestModel({
    required super.userId,
  });

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
    };
  }
}
