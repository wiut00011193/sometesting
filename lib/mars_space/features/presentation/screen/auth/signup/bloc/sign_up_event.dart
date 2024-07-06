part of 'sign_up_bloc.dart';

@immutable
abstract class SignUpEvent {}

class SignUpUserEvent extends SignUpEvent {
  final SignUpRequestModel signUpRequestModel;

  SignUpUserEvent({required this.signUpRequestModel});
}

class SendVerificationCodeEvent extends SignUpEvent {
  final SendVerificationCodeRequestModel sendVerificationCodeRequestModel;

  SendVerificationCodeEvent({required this.sendVerificationCodeRequestModel});
}

class VerifyPhoneNumberEvent extends SignUpEvent {
  final VerifyPhoneNumberRequestModel verifyPhoneNumberRequestModel;

  VerifyPhoneNumberEvent({required this.verifyPhoneNumberRequestModel});
}

class CheckUserExistsEvent extends SignUpEvent {
  final LoginRequestModel logInRequestModel;

  CheckUserExistsEvent({required this.logInRequestModel});
}
