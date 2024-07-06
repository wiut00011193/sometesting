part of 'sign_up_bloc.dart';

@immutable
class SignUpState {
  final LoadingState status;
  final String errorMessage;
  final Either<Failure, VerifyPhoneNumberResponseEntity> verificationResult;
  final Either<Failure, bool> checkUserExistsResult;

  const SignUpState({
    this.status = LoadingState.EMPTY,
    this.errorMessage = "",
    this.verificationResult = const Left(Failure(errorMessage: 'NO VERIFY PHONE NUMBER')),
    this.checkUserExistsResult = const Left(Failure(errorMessage: 'USER EXISTS NOT CHECKED')),
  });

  SignUpState copyWith({
    LoadingState? status,
    String? errorMessage,
    Either<Failure, VerifyPhoneNumberResponseEntity>? verificationResult,
    Either<Failure, bool>? checkUserExistsResult,
  }) {
    return SignUpState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      verificationResult: verificationResult ?? this.verificationResult,
      checkUserExistsResult: checkUserExistsResult ?? this.checkUserExistsResult,
    );
  }
}
