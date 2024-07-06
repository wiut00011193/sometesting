import 'package:mars_it_app/mars_space/features/domain/entity/request/login_request_entity.dart';

class LoginRequestModel extends LoginRequestEntity {
  LoginRequestModel({
    required super.phone,
    required super.password,
  });

  Map<String, dynamic> toJson() {
    return {
      'user': {
        'phone': phone,
        'password': password,
      },
    };
  }
}
