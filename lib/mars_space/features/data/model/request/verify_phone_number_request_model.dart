import 'package:mars_it_app/mars_space/features/domain/entity/request/verify_phone_number_request_entity.dart';

class VerifyPhoneNumberRequestModel extends VerifyPhoneNumberRequestEntity {
  VerifyPhoneNumberRequestModel({
    required super.phone,
    required super.code,
  });

  Map<String, dynamic> toJson() {
    return {
      'phone': phone,
      'code': code,
    };
  }
}
