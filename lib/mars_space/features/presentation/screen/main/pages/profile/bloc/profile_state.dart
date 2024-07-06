part of 'profile_bloc.dart';

@immutable
class ProfileState {
  final LoadingState status;
  final String errorMessage;
  final Either<Failure, GetProfileResponseEntity> getStudentResult;
  final Either<Failure, List<GetChildrenResponseEntity>> getChildrenResult;

  const ProfileState({
    this.status = LoadingState.EMPTY,
    this.errorMessage = "",
    this.getStudentResult = const Left(Failure(errorMessage: 'NO STUDENT')),
    this.getChildrenResult = const Left(Failure(errorMessage: 'NO CHILDREN')),
  });

  ProfileState copyWith({
    LoadingState? status,
    String? errorMessage,
    Either<Failure, GetProfileResponseEntity>? getStudentResult,
    Either<Failure, List<GetChildrenResponseEntity>>? getChildrenResult,
  }) {
    return ProfileState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      getStudentResult: getStudentResult ?? this.getStudentResult,
      getChildrenResult: getChildrenResult ?? this.getChildrenResult,
    );
  }
}
