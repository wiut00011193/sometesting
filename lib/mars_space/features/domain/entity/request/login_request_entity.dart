import 'package:mars_it_app/mars_space/features/data/model/request/login_request_model.dart';

class LoginRequestEntity {
  String? phone;
  String? password;

  LoginRequestEntity({
    this.phone,
    this.password,
  });

  Future<LoginRequestModel> toModel() async {
    return LoginRequestModel(
      phone: phone,
      password: password,
    );
  }
}
