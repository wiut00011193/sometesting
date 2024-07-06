import 'package:mars_it_app/mars_space/features/data/model/request/get_user_slots_request_model.dart';

class GetUserSlotsRequestEntity {
  int? userId;

  GetUserSlotsRequestEntity({
    required this.userId,
  });

  Future<GetUserSlotsRequestModel> toModel() async {
    return GetUserSlotsRequestModel(
      userId: userId,
    );
  }
}
