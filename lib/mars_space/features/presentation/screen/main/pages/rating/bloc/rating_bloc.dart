import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mars_it_app/mars_space/core/error/failures.dart';
import 'package:mars_it_app/mars_space/core/usecase/usecase.dart';
import 'package:mars_it_app/mars_space/features/data/enum/loading_state_enum.dart';
import 'package:mars_it_app/mars_space/features/domain/entity/response/get_ratings_response_entity.dart';
import 'package:mars_it_app/mars_space/features/domain/usecase/get_ratings_usecase.dart';

part 'rating_event.dart';

part 'rating_state.dart';

class RatingBloc extends Bloc<RatingEvent, RatingState> {
  final GetRatingsUseCase getRatingsUseCase;

  RatingBloc({
    required this.getRatingsUseCase,
  }) : super(const RatingState()) {
    on<RatingEvent>((event, emit) async {
      switch (event) {
        case GetRatingsEvent():
          emit(state.copyWith(status: LoadingState.LOADING));
          final result = await getRatingsUseCase(NoParams());
          await _getRatings(state, emit, result);
          break;
      }
    });
  }

  Future<void> _getRatings(
    RatingState state,
    Emitter<RatingState> emit,
    Either<Failure, GetRatingsResponseEntity> result,
  ) async {
    result.fold(
      (failure) async {
        emit(state.copyWith(
          status: LoadingState.ERROR,
          errorMessage: failure.errorMessage,
        ));
      },
      (success) async {
        emit(state.copyWith(
          status: LoadingState.LOADED,
          getRatingsResult: Right(success),
        ));
      },
    );
  }
}
