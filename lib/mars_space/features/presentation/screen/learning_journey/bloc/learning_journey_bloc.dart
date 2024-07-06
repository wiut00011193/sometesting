import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mars_it_app/mars_space/core/error/failures.dart';
import 'package:mars_it_app/mars_space/core/usecase/usecase.dart';
import 'package:mars_it_app/mars_space/features/data/enum/loading_state_enum.dart';
import 'package:mars_it_app/mars_space/features/domain/entity/request/get_course_modules_request_entity.dart';
import 'package:mars_it_app/mars_space/features/domain/entity/response/get_course_modules_response_entity.dart';
import 'package:mars_it_app/mars_space/features/domain/entity/response/get_student_response_entity.dart';
import 'package:mars_it_app/mars_space/features/domain/usecase/get_course_modules_usecase.dart';
import 'package:mars_it_app/mars_space/features/domain/usecase/get_student_usecase.dart';

part 'learning_journey_event.dart';
part 'learning_journey_state.dart';

class LearningJourneyBloc
    extends Bloc<LearningJourneyEvent, LearningJourneyState> {
  final GetStudentUseCase getStudentUseCase;
  final GetCourseModulesUseCase getCourseModulesUseCase;

  LearningJourneyBloc({
    required this.getStudentUseCase,
    required this.getCourseModulesUseCase,
  }) : super(const LearningJourneyState()) {
    on<LearningJourneyEvent>((event, emit) async {
      switch (event) {
        case GetStudentEvent():
          emit(state.copyWith(status: LoadingState.LOADING));
          final result = await getStudentUseCase(NoParams());
          _getStudent(state, emit, result);
          break;
        case GetCourseModulesEvent():
          emit(state.copyWith(status: LoadingState.LOADING));
          final result = await getCourseModulesUseCase(
              Params(request: event.getCourseModulesRequestEntity));
          _getCourseModules(state, emit, result);
          break;
      }
    });
  }

  void _getStudent(
    LearningJourneyState state,
    Emitter<LearningJourneyState> emit,
    Either<Failure, GetStudentResponseEntity> result,
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
          getStudentResult: Right(success),
          status: LoadingState.LOADED,
        ));
      },
    );
  }

  void _getCourseModules(
    LearningJourneyState state,
    Emitter<LearningJourneyState> emit,
    Either<Failure, GetCourseModulesResponseEntity> result,
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
          getCourseModulesResult: Right(success),
          status: LoadingState.LOADED,
        ));
      },
    );
  }
}
