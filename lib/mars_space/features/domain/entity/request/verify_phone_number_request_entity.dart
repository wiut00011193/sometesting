import 'package:mars_it_app/mars_space/features/data/model/request/verify_phone_number_request_model.dart';

class VerifyPhoneNumberRequestEntity {
  String? phone;
  String? code;

  VerifyPhoneNumberRequestEntity({
    required this.phone,
    required this.code,
  });

  Future<VerifyPhoneNumberRequestModel> toModel() async {
    return VerifyPhoneNumberRequestModel(
      phone: phone,
      code: code,
    );
  }
}
