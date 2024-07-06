import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:mars_it_app/mars_space/core/error/failures.dart';
import 'package:mars_it_app/mars_space/features/data/model/request/search_student_request_model.dart';
import 'package:mars_it_app/mars_space/features/domain/entity/response/add_child_response_entity.dart';
import 'package:mars_it_app/mars_space/features/domain/entity/response/search_student_response_entity.dart';

import '../../../../../data/enum/loading_state_enum.dart';
import '../../../../../data/model/request/add_child_request_model.dart';
import '../../../../../data/model/request/get_profile_request_model.dart';
import '../../../../../domain/entity/response/get_profile_response_entity.dart';
import '../../../../../domain/usecase/add_child_usecase.dart' as add_child_usecase;
import '../../../../../domain/usecase/get_profile_usecase.dart' as get_student_usecase;
import '../../../../../domain/usecase/search_student_usecase.dart' as search_student_usecase;

part 'add_child_second_event.dart';

part 'add_child_second_state.dart';

class AddChildSecondBloc
    extends Bloc<AddChildSecondEvent, AddChildSecondState> {
  final add_child_usecase.AddChildUseCase addChildUseCase;
  final get_student_usecase.GetProfileUseCase getStudentUseCase; 
  final search_student_usecase.SearchStudentUseCase searchStudentUseCase;

  AddChildSecondBloc({
    required this.addChildUseCase,
    required this.getStudentUseCase,
    required this.searchStudentUseCase,
  }) : super(const AddChildSecondState()) {
    on<AddChildSecondEvent>((event, emit) async {
      switch (event) {
        case AddChildEvent():
          emit(state.copyWith(status: LoadingState.LOADING));
          final result =
              await addChildUseCase(add_child_usecase.Params(request: event.request));
          await _addChild(state, emit, result);
          break;
        case GetProfileEvent():
          emit(state.copyWith(status: LoadingState.LOADING));
          final result = await getStudentUseCase(get_student_usecase.Params(request: event.request));
          await _getStudent(state, emit, result);
          break;
        case SearchStudentEvent():
          emit(state.copyWith(status:LoadingState.LOADING));
          final result = await searchStudentUseCase(search_student_usecase.Params(request: event.request));
          await _searchStudent(state, emit, result);
          break;
      }
    });
  }

  Future<void> _addChild(
    AddChildSecondState state,
    Emitter<AddChildSecondState> emit,
    Either<Failure, AddChildResponseEntity> result,
  ) async {
    result.fold(
      (failure) async {
        emit(state.copyWith(
          status: LoadingState.ERROR,
          errorMessage: failure.errorMessage,
        ));
      },
      (success) async {
        emit(state.copyWith(status: LoadingState.LOADED));
      },
    );
  }

  Future<void> _getStudent(
    AddChildSecondState state,
    Emitter<AddChildSecondState> emit,
    Either<Failure, GetProfileResponseEntity>  result,
  ) async {
    result.fold(
      (failure) async {
        emit(state.copyWith(
          status: LoadingState.ERROR,
          errorMessage: failure.errorMessage,
        ));
      },
      (success) async {
        emit(state.copyWith(status: LoadingState.LOADED, getResult: Right(success),));
      },
    );
  }

  Future<void> _searchStudent(
    AddChildSecondState state,
    Emitter<AddChildSecondState> emit,
    Either<Failure, List<SearchStudentResponseEntity>> result,
  ) async {
    result.fold(
      (failure) async {
        emit(state.copyWith(
          status: LoadingState.ERROR,
          errorMessage: failure.errorMessage,
        ));
      },
      (success) async {
        emit(state.copyWith(status: LoadingState.LOADED, searchResult: Right(success),));
      },
    );
  }
}
