import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mars_it_app/mars_space/core/error/failures.dart';
import 'package:mars_it_app/mars_space/core/usecase/usecase.dart';
import 'package:mars_it_app/mars_space/features/data/enum/loading_state_enum.dart';
import 'package:mars_it_app/mars_space/features/domain/entity/request/add_extra_lesson_request_entity.dart';
import 'package:mars_it_app/mars_space/features/domain/entity/request/get_user_slots_request_entity.dart';
import 'package:mars_it_app/mars_space/features/domain/entity/response/get_extra_lessons_response_entity.dart';
import 'package:mars_it_app/mars_space/features/domain/entity/response/get_tutors_response_entity.dart';
import 'package:mars_it_app/mars_space/features/domain/entity/response/get_user_slots_response_entity.dart';
import 'package:mars_it_app/mars_space/features/domain/usecase/book_extra_lesson_usecase.dart'
    as book_extra_lesson_usecase;
import 'package:mars_it_app/mars_space/features/domain/usecase/get_extra_lessons_usecase.dart';
import 'package:mars_it_app/mars_space/features/domain/usecase/get_tutors_usecase.dart';
import 'package:mars_it_app/mars_space/features/domain/usecase/get_user_slots_usecase.dart'
    as get_user_slots_usecase;

part 'booking_event.dart';
part 'booking_state.dart';

class BookingBloc extends Bloc<BookingEvent, BookingState> {
  final GetExtraLessonsUseCase getExtraLessonsUseCase;
  final GetTutorsUseCase getTutorsUseCase;
  final get_user_slots_usecase.GetUserSlotsUseCase getUserSlotsUseCase;
  final book_extra_lesson_usecase.BookExtraLessonUseCase bookExtraLessonUseCase;

  BookingBloc({
    required this.getExtraLessonsUseCase,
    required this.getTutorsUseCase,
    required this.getUserSlotsUseCase,
    required this.bookExtraLessonUseCase,
  }) : super(const BookingState()) {
    on<BookingEvent>(
      (event, emit) async {
        switch (event) {
          case GetExtraLessonsEvent():
            emit(state.copyWith(status: LoadingState.LOADING));
            final result = await getExtraLessonsUseCase(NoParams());
            _getExtraLessons(state, emit, result);
            break;
          case GetTutorsEvent():
            emit(state.copyWith(status: LoadingState.LOADING));
            final result = await getTutorsUseCase(NoParams());
            _getTutors(state, emit, result);
            break;
          case GetUserSlotsEvent():
            emit(state.copyWith(status: LoadingState.LOADING));
            final result = await getUserSlotsUseCase(
                get_user_slots_usecase.Params(
                    request: event.getUserSlotsRequest));
            _getUserSlots(state, emit, result);
            break;
          case BookExtraLessonEvent():
            emit(state.copyWith(status: LoadingState.LOADING));
            final result = await bookExtraLessonUseCase(
                book_extra_lesson_usecase.Params(
                    request: event.addExtraLessonRequest));
            _bookExtraLesson(state, emit, result);
            break;
        }
      },
    );
  }

  void _getExtraLessons(
    BookingState state,
    Emitter<BookingState> emit,
    Either<Failure, List<GetExtraLessonsResponseEntity>> result,
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
          getExtraLessonsResult: Right(success),
          status: LoadingState.LOADED,
        ));
      },
    );
  }

  void _getTutors(
    BookingState state,
    Emitter<BookingState> emit,
    Either<Failure, List<GetTutorsResponseEntity>> result,
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
          getTutorsResult: Right(success),
          status: LoadingState.LOADED,
        ));
      },
    );
  }

  void _getUserSlots(
    BookingState state,
    Emitter<BookingState> emit,
    Either<Failure, List<GetUserSlotsResponseEntity>> result,
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
          getUserSlotsResult: Right(success),
          status: LoadingState.LOADED,
        ));
      },
    );
  }

  void _bookExtraLesson(
    BookingState state,
    Emitter<BookingState> emit,
    Either<Failure, void> result,
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
        ));
      },
    );
  }
}
