import 'package:mars_it_app/mars_space/features/domain/entity/request/send_verification_code_request_entity.dart';

class SendVerificationCodeRequestModel
    extends SendVerificationCodeRequestEntity {
  SendVerificationCodeRequestModel({
    required super.phone,
  });

  Map<String, dynamic> toJson() {
    return {
      'phone': phone,
    };
  }
}
