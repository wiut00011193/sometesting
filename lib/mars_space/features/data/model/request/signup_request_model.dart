import 'package:mars_it_app/mars_space/features/domain/entity/request/signup_request_entity.dart';

class SignUpRequestModel extends SignUpRequestEntity {
  SignUpRequestModel({
    required super.phone,
    required super.password,
  });

  Map<String, dynamic> toJson() {
    return {
      'first_name': '',
      'last_name': '',
      'phone': phone,
      'password': password,
      'type': 'user',
    };
  }
}
