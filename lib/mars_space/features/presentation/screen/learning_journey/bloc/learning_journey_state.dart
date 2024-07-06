part of 'learning_journey_bloc.dart';

class LearningJourneyState {
  final LoadingState status;
  final String errorMessage;
  final Either<Failure, GetStudentResponseEntity> getStudentResult;
  final Either<Failure, GetCourseModulesResponseEntity> getCourseModulesResult;

  const LearningJourneyState({
    this.status = LoadingState.EMPTY,
    this.errorMessage = "",
    this.getStudentResult = const Left(Failure(errorMessage: "NO STUDENT")),
    this.getCourseModulesResult = const Left(Failure(errorMessage: 'NO COURSE MODULES')),
  });

  LearningJourneyState copyWith({
    LoadingState? status,
    String? errorMessage,
    Either<Failure, GetStudentResponseEntity>? getStudentResult,
    Either<Failure, GetCourseModulesResponseEntity>? getCourseModulesResult,
  }) {
    return LearningJourneyState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      getStudentResult: getStudentResult ?? this.getStudentResult,
      getCourseModulesResult: getCourseModulesResult ?? this.getCourseModulesResult,
    );
  }
}
