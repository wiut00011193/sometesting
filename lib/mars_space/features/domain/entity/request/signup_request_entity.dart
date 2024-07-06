import 'package:mars_it_app/mars_space/features/data/model/request/signup_request_model.dart';

class SignUpRequestEntity {
  String? phone;
  String? password;

  SignUpRequestEntity({
    this.phone,
    this.password,
  });

  Future<SignUpRequestModel> toModel() async {
    return SignUpRequestModel(
      phone: phone,
      password: password,
    );
  }
}
