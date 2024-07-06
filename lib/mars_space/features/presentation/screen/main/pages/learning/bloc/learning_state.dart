part of 'learning_bloc.dart';

@immutable
class LearningState {
  final LoadingState status;
  final String errorMessage;
  final int studentId;
  final Either<Failure, GetStudentResponseEntity> getStudentResult;
  final Either<Failure, List<GetCourseElementsResponseEntity>> getCourseElementsResult;
  final Either<Failure, GetCourseElementResponseEntity> getCourseElementResult;
  final Either<Failure, GetExamResultResponseEntity> getExamResult;
  final Either<Failure, GetCourseModulesResponseEntity> getCourseModulesResult;

  const LearningState({
    this.status = LoadingState.EMPTY,
    this.errorMessage = "",
    this.studentId = -1,
    this.getStudentResult = const Left(Failure(errorMessage: 'NO STUDENT')),
    this.getCourseElementsResult = const Left(Failure(errorMessage: 'NO COURSE ELEMENTS')),
    this.getCourseElementResult = const Left(Failure(errorMessage: 'NO COURSE ELEMENT')),
    this.getExamResult = const Left(Failure(errorMessage: 'NO EXAM RESULT')),
    this.getCourseModulesResult = const Left(Failure(errorMessage: 'NO COURSE MODULES'))
  });

  LearningState copyWith({
    LoadingState? status,
    AuthState? authStatus,
    String? errorMessage,
    int? studentId,
    Either<Failure, GetStudentResponseEntity>? getStudentResult,
    Either<Failure, List<GetCourseElementsResponseEntity>>? getCourseElementsResult,
    Either<Failure, GetCourseElementResponseEntity>? getCourseElementResult,
    Either<Failure, GetExamResultResponseEntity>? getExamResult,
    Either<Failure, GetCourseModulesResponseEntity>? getCourseModulesResult,
  }) {
    return LearningState(
      status: status ?? this.status,
      studentId:  studentId ?? this.studentId,
      errorMessage: errorMessage ?? this.errorMessage,
      getStudentResult: getStudentResult ?? this.getStudentResult,
      getCourseElementsResult: getCourseElementsResult ?? this.getCourseElementsResult,
      getCourseElementResult: getCourseElementResult ?? this.getCourseElementResult,
      getExamResult: getExamResult ?? this.getExamResult,
      getCourseModulesResult: getCourseModulesResult ?? this.getCourseModulesResult,
    );
  }
}

