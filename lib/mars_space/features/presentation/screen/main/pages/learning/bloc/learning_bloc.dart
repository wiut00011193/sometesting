import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:mars_it_app/injection_handler.dart';
import 'package:mars_it_app/mars_space/core/error/failures.dart';
import 'package:mars_it_app/mars_space/core/local_db/shared_pref.dart';
import 'package:mars_it_app/mars_space/core/usecase/usecase.dart';
import 'package:mars_it_app/mars_space/features/data/enum/loading_state_enum.dart';
import 'package:mars_it_app/mars_space/features/data/model/request/get_course_element_request_model.dart';
import 'package:mars_it_app/mars_space/features/data/model/request/get_course_elements_request_model.dart';
import 'package:mars_it_app/mars_space/features/data/model/request/get_exam_result_request_model.dart';
import 'package:mars_it_app/mars_space/features/domain/entity/request/get_course_modules_request_entity.dart';
import 'package:mars_it_app/mars_space/features/domain/entity/response/get_course_element_response_entity.dart';
import 'package:mars_it_app/mars_space/features/domain/entity/response/get_course_elements_response_entity.dart';
import 'package:mars_it_app/mars_space/features/domain/entity/response/get_course_modules_response_entity.dart';
import 'package:mars_it_app/mars_space/features/domain/entity/response/get_exam_result_response_entity.dart';
import 'package:mars_it_app/mars_space/features/domain/entity/response/get_student_response_entity.dart';
import 'package:mars_it_app/mars_space/features/domain/usecase/get_course_element_usecase.dart'
    as get_course_element_use_case;
import 'package:mars_it_app/mars_space/features/domain/usecase/get_course_elements_usecase.dart'
    as get_course_elements_use_case;
import 'package:mars_it_app/mars_space/features/domain/usecase/get_exam_result_usecase.dart'
    as get_exam_result_use_case;
import 'package:mars_it_app/mars_space/features/domain/usecase/get_course_modules_usecase.dart'
    as get_course_modules_usecase;
import 'package:mars_it_app/mars_space/features/domain/usecase/get_student_usecase.dart';

part 'learning_event.dart';

part 'learning_state.dart';

class LearningBloc extends Bloc<LearningEvent, LearningState> {
  final GetStudentUseCase getStudentUseCase;
  final get_course_elements_use_case.GetCourseElementsUseCase
      getCourseElementsUseCase;
  final get_course_element_use_case.GetCourseElementUseCase
      getCourseElementUseCase;
  final get_exam_result_use_case.GetExamResultUseCase getExamResultUseCase;
  final get_course_modules_usecase.GetCourseModulesUseCase
      getCourseModulesUseCase;

  LearningBloc({
    required this.getStudentUseCase,
    required this.getCourseElementsUseCase,
    required this.getCourseElementUseCase,
    required this.getExamResultUseCase,
    required this.getCourseModulesUseCase,
  }) : super(const LearningState()) {
    on<LearningEvent>((event, emit) async {
      switch (event) {
        case GetStudentEvent():
          emit(state.copyWith(status: LoadingState.LOADING));
          final result = await getStudentUseCase(NoParams());
          final studentId = await di.get<MySharedPref>().getStudentModmeId();
          _getStudent(state, emit, result, studentId);
          break;
        case GetExamResultEvent():
          emit(state.copyWith(
            status: LoadingState.LOADING,
            getExamResult: const Left(Failure(errorMessage: 'NO EXAM RESULT')),
          ));
          final result = await getExamResultUseCase(
              get_exam_result_use_case.Params(
                  request: event.getExamResultRequestModel));
          _getExamResult(state, emit, result);
          break;
        case GetCourseElementsEvent():
          emit(state.copyWith(
            status: LoadingState.LOADING,
            getCourseElementsResult:
                const Left(Failure(errorMessage: 'NO COURSE ELEMENTS')),
          ));
          final result = await getCourseElementsUseCase(
              get_course_elements_use_case.Params(
                  request: event.getCourseElementsRequestModel));
          _getCourseElements(state, emit, result);
          break;
        case GetCourseElementEvent():
          emit(state.copyWith(status: LoadingState.LOADING));
          final result = await getCourseElementUseCase(
              get_course_element_use_case.Params(
                  request: event.getCourseElementRequestModel));
          _getCourseElement(state, emit, result);
          break;
        case GetCourseModulesEvent():
          emit(state.copyWith(status: LoadingState.LOADING));
          final result = await getCourseModulesUseCase(
              get_course_modules_usecase.Params(
                  request: event.getCourseModulesRequestEntity));
          _getCourseModules(state, emit, result);
          break;
      }
    });
  }

  void _getStudent(
    LearningState state,
    Emitter<LearningState> emit,
    Either<Failure, GetStudentResponseEntity> result,
    int studentId,
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
          studentId: studentId,
          getStudentResult: Right(success),
          status: LoadingState.LOADED,
        ));
      },
    );
  }

  void _getExamResult(
    LearningState state,
    Emitter<LearningState> emit,
    Either<Failure, GetExamResultResponseEntity> result,
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
          getExamResult: Right(success),
          status: LoadingState.LOADED,
        ));
      },
    );
  }

  void _getCourseModules(
    LearningState state,
    Emitter<LearningState> emit,
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

  void _getCourseElements(
    LearningState state,
    Emitter<LearningState> emit,
    Either<Failure, List<GetCourseElementsResponseEntity>> result,
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
          getCourseElementsResult: Right(success),
          status: LoadingState.LOADED,
        ));
      },
    );
  }

  void _getCourseElement(
    LearningState state,
    Emitter<LearningState> emit,
    Either<Failure, GetCourseElementResponseEntity> result,
  ) async {
    result.fold((failure) async {
      emit(state.copyWith(
        status: LoadingState.ERROR,
        errorMessage: failure.errorMessage,
      ));
    }, (success) async {
      emit(state.copyWith(
        getCourseElementResult: Right(success),
        status: LoadingState.LOADED,
      ));
    });
  }
}
