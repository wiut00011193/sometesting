part of 'booking_bloc.dart';

class BookingState {
  final LoadingState status;
  final String errorMessage;
  final Either<Failure, List<GetExtraLessonsResponseEntity>> getExtraLessonsResult;
  final Either<Failure, List<GetTutorsResponseEntity>> getTutorsResult;
  final Either<Failure, List<GetUserSlotsResponseEntity>> getUserSlotsResult;

  const BookingState({
    this.status = LoadingState.EMPTY,
    this.errorMessage = "",
    this.getExtraLessonsResult = const Left(Failure(errorMessage: 'NO EXTRA LESSONS')),
    this.getTutorsResult = const Left(Failure(errorMessage: 'NO TUTORS')),
    this.getUserSlotsResult = const Left(Failure(errorMessage: 'NO USER SLOTS')),
  });

  BookingState copyWith({
    LoadingState? status,
    String? errorMessage,
    Either<Failure, List<GetExtraLessonsResponseEntity>>? getExtraLessonsResult,
    Either<Failure, List<GetTutorsResponseEntity>>? getTutorsResult,
    Either<Failure, List<GetUserSlotsResponseEntity>>? getUserSlotsResult,
  }) {
    return BookingState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      getExtraLessonsResult: getExtraLessonsResult ?? this.getExtraLessonsResult,
      getTutorsResult: getTutorsResult ?? this.getTutorsResult,
      getUserSlotsResult: getUserSlotsResult ?? this.getUserSlotsResult,
    );
  }
}
