part of 'login_bloc.dart';

@immutable
class LoginState {
  final LoadingState status;
  final String errorMessage;
  final bool isChildExist;

  const LoginState({
    this.status = LoadingState.EMPTY,
    this.errorMessage = "",
    this.isChildExist = false,
  });

  LoginState copyWith({
    LoadingState? status,
    String? errorMessage,
    bool? isChildExist,
  }) {
    return LoginState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      isChildExist: isChildExist ?? this.isChildExist,
    );
  }
}
