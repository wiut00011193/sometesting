import 'package:mars_it_app/mars_space/features/data/model/request/send_verification_code_request_model.dart';

class SendVerificationCodeRequestEntity {
  String? phone;

  SendVerificationCodeRequestEntity({
    required this.phone,
  });

  Future<SendVerificationCodeRequestModel> toModel() async {
    return SendVerificationCodeRequestModel(
      phone: phone,
    );
  }
}
