import 'package:mars_it_app/mars_space/features/domain/entity/response/verify_phone_number_response_entity.dart';

class VerifyPhoneNumberResponseModel extends VerifyPhoneNumberResponseEntity {
  VerifyPhoneNumberResponseModel({
    required super.isVerified,
  });

  factory VerifyPhoneNumberResponseModel.fromJson(Map<String, dynamic> json) {
    return VerifyPhoneNumberResponseModel(
      isVerified: json['detail']['message'] as bool?,
    );
  }
}
