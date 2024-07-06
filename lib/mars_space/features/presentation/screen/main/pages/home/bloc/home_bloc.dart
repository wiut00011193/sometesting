import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:mars_it_app/mars_space/core/local_db/shared_pref.dart';
import 'package:mars_it_app/mars_space/core/usecase/usecase.dart';
import 'package:mars_it_app/mars_space/features/data/model/request/get_stories_request_model.dart';
import 'package:mars_it_app/mars_space/features/domain/entity/request/get_group_attendance_request_entity.dart';
import 'package:mars_it_app/mars_space/features/domain/entity/request/get_month_attendance_request_entity.dart';
import 'package:mars_it_app/mars_space/features/domain/entity/response/attendance_response_entity.dart';
import 'package:mars_it_app/mars_space/features/domain/entity/response/child_balance_response_entity.dart';
import 'package:mars_it_app/mars_space/features/domain/entity/response/get_extra_lessons_response_entity.dart';
import 'package:mars_it_app/mars_space/features/domain/entity/response/get_group_attendance_response_entity.dart';
import 'package:mars_it_app/mars_space/features/domain/entity/response/get_stories_response_entity.dart';
import 'package:mars_it_app/mars_space/features/domain/usecase/get_extra_lessons_usecase.dart';
import 'package:mars_it_app/mars_space/features/domain/usecase/get_group_attendance_usecase.dart'
    as get_group_attendance_usecase;
import 'package:mars_it_app/mars_space/features/domain/usecase/get_month_attendance_usecase.dart'
    as get_month_attendance_usecase;
import 'package:mars_it_app/mars_space/features/domain/usecase/get_stories_usecase.dart';

import '../../../../../../../core/error/failures.dart';
import '../../../../../../data/enum/loading_state_enum.dart';
import '../../../../../../domain/usecase/child_attendance_usecase.dart';
import '../../../../../../domain/usecase/child_balance_usecase.dart';

part 'home_event.dart';

part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final GetStoriesUseCase getStoriesUseCase;
  final GetChildBalanceUseCase getChildBalanceUseCase;
  final GetExtraLessonsUseCase getExtraLessonsUseCase;
  final GetChildAttendanceUseCase getChildAttendanceUseCase;
  final get_month_attendance_usecase.GetMonthAttendanceUseCase
      getMonthAttendanceUseCase;
  final get_group_attendance_usecase.GetGroupAttendanceUseCase
      getGroupAttendanceUseCase;
  final MySharedPref mySharedPref;

  HomeBloc({
    required this.mySharedPref,
    required this.getStoriesUseCase,
    required this.getChildAttendanceUseCase,
    required this.getExtraLessonsUseCase,
    required this.getChildBalanceUseCase,
    required this.getMonthAttendanceUseCase,
    required this.getGroupAttendanceUseCase,
  }) : super(const HomeState()) {
    on<HomeEvent>((event, emit) async {
      switch (event) {
        case GetStories():
          final result =
              await getStoriesUseCase(Params(requestModel: event.requestModel));
          _getStories(state, emit, result);
          break;
        case GetBalanceEvent():
          emit(state.copyWith(status: LoadingState.LOADING));
          final result = await getChildBalanceUseCase(NoParams());
          _getChildBalance(state, emit, result);
          break;
        case GetExtraLessonsEvent():
          emit(state.copyWith(status: LoadingState.LOADING));
          final result = await getExtraLessonsUseCase(NoParams());
          _getExtraLessons(state, emit, result);
          break;
        case GetMonthAttendanceEvent():
          emit(state.copyWith(status: LoadingState.LOADING));
          final result = await getMonthAttendanceUseCase(
              get_month_attendance_usecase.Params(
                  request: event.getMonthAttendanceRequest));
          _getMonthAttendance(state, emit, result);
          break;
        case GetGroupAttendanceEvent():
          emit(state.copyWith(status: LoadingState.LOADING));
          final result = await getGroupAttendanceUseCase(
              get_group_attendance_usecase.Params(
                  request: event.getGroupAttendanceRequest));
          _getGroupAttendance(state, emit, result);
          break;

        case GetAttendanceEvent():
          emit(state.copyWith(status: LoadingState.LOADING));
          final result = await getChildAttendanceUseCase(NoParams());
          _getChildAttendance(state, emit, result);
          break;

        case LogOut():
          emit(state.copyWith(status: LoadingState.LOADING));
          await mySharedPref.setAccessToken("");
          await mySharedPref.setRefreshToken("");
          await mySharedPref.setStudentId(0);
          await mySharedPref.setStudentModmeId(0);
          await mySharedPref.setBranchId(0);
          emit(state.copyWith(authStatus: AuthState.SIGNIN));
          break;
      }
    });
  }

  void _getExtraLessons(
    HomeState state,
    Emitter<HomeState> emit,
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

  void _getGroupAttendance(
    HomeState state,
    Emitter<HomeState> emit,
    Either<Failure, GetGroupAttendanceResponseEntity> result,
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
          getGroupAttendanceResult: Right(success),
          status: LoadingState.LOADED,
        ));
      },
    );
  } 

  void _getStories(
    HomeState state,
    Emitter<HomeState> emit,
    Either<Failure, List<GetStoriesResponseEntity>> result,
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
          stories: Right(success),
          status: LoadingState.LOADED,
        ));
      },
    );
  }

  void _getChildBalance(
    HomeState state,
    Emitter<HomeState> emit,
    Either<Failure, ChildBalanceResponseEntity> result,
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
          childBalance: Right(success),
          status: LoadingState.LOADED,
        ));
      },
    );
  }

  void _getChildAttendance(
    HomeState state,
    Emitter<HomeState> emit,
    Either<Failure, List<AttendanceResponseEntity>> result,
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
          childAttendance: Right(success),
          status: LoadingState.LOADED,
        ));
      },
    );
  }

  void _getMonthAttendance(
    HomeState state,
    Emitter<HomeState> emit,
    Either<Failure, List<AttendanceResponseEntity>> result,
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
          monthAttendance: Right(success),
          status: LoadingState.LOADED,
        ));
      },
    );
  }
}
