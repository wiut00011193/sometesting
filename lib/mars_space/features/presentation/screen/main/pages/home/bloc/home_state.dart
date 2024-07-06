part of 'home_bloc.dart';

@immutable
class HomeState {
  final LoadingState status;
  final AuthState authStatus;
  final String errorMessage;
  final Either<Failure, List<GetStoriesResponseEntity>> stories;
  final Either<Failure, ChildBalanceResponseEntity> childBalance;
  final Either<Failure, List<AttendanceResponseEntity>> childAttendance;
  final Either<Failure, List<AttendanceResponseEntity>> monthAttendance;
  final Either<Failure, List<GetExtraLessonsResponseEntity>> getExtraLessonsResult;
  final Either<Failure, GetGroupAttendanceResponseEntity> getGroupAttendanceResult;

  const HomeState({
    this.status = LoadingState.EMPTY,
    this.authStatus = AuthState.HOME,
    this.errorMessage = "",
    this.stories = const Left(Failure(errorMessage: 'NO STORIES')),
    this.childBalance = const Left(Failure(errorMessage: 'NO BALANCE')),
    this.childAttendance = const Left(Failure(errorMessage: 'NO ATTENDANCE')),
    this.monthAttendance = const Left(Failure(errorMessage: 'NO MONTH ATTENDANCE')),
    this.getExtraLessonsResult = const Left(Failure(errorMessage: 'NO EXTRA LESSONS')),
    this.getGroupAttendanceResult = const Left(Failure(errorMessage: 'NO GROUP ATTENDANCE')),
  });

  HomeState copyWith({
    LoadingState? status,
    AuthState? authStatus,
    String? errorMessage,
    Either<Failure, List<GetStoriesResponseEntity>>? stories,
    Either<Failure, ChildBalanceResponseEntity>? childBalance,
    Either<Failure, List<AttendanceResponseEntity>>? childAttendance,
    Either<Failure, List<AttendanceResponseEntity>>? monthAttendance,
    Either<Failure, List<GetExtraLessonsResponseEntity>>? getExtraLessonsResult,
    Either<Failure, GetGroupAttendanceResponseEntity>? getGroupAttendanceResult,
  }) {
    return HomeState(
      status: status ?? this.status,
      authStatus: authStatus ?? this.authStatus,
      errorMessage: errorMessage ?? this.errorMessage,
      stories: stories ?? this.stories,
      childBalance: childBalance ?? this.childBalance,
      childAttendance: childAttendance ?? this.childAttendance,
      monthAttendance: monthAttendance ?? this.monthAttendance,
      getExtraLessonsResult: getExtraLessonsResult ?? this.getExtraLessonsResult,
      getGroupAttendanceResult: getGroupAttendanceResult ?? this.getGroupAttendanceResult,
    );
  }
}
