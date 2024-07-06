part of 'login_bloc.dart';

@immutable
abstract class LoginEvent {}

class LoginUserEvent extends LoginEvent {
  final LoginRequestModel requestModel;

  LoginUserEvent({required this.requestModel});
}
