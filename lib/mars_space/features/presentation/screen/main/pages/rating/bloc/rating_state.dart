part of 'rating_bloc.dart';

@immutable
class RatingState {
  final LoadingState status;
  final String errorMessage;
  final Either<Failure, GetRatingsResponseEntity> getRatingsResult;

  const RatingState({
    this.status = LoadingState.EMPTY,
    this.errorMessage = "",
    this.getRatingsResult = const Left(Failure(errorMessage: 'NO RATINGS')),
  });
  
  RatingState copyWith({
    LoadingState? status,
    String? errorMessage,
    Either<Failure, GetRatingsResponseEntity>? getRatingsResult,
  }) {
    return RatingState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      getRatingsResult: getRatingsResult ?? this.getRatingsResult,
    );
  }
}