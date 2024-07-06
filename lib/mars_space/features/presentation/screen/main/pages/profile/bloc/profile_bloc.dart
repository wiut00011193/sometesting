import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:mars_it_app/mars_space/features/data/model/request/get_profile_request_model.dart';
import 'package:mars_it_app/mars_space/features/domain/entity/request/delete_child_request_entity.dart';
import 'package:mars_it_app/mars_space/features/domain/entity/response/get_children_response_entity.dart';
import 'package:mars_it_app/mars_space/features/domain/entity/response/get_profile_response_entity.dart';
import 'package:mars_it_app/mars_space/features/domain/usecase/get_children_usecase.dart';
import 'package:mars_it_app/mars_space/features/domain/usecase/get_profile_usecase.dart'
    as get_profile_usecase;
import 'package:mars_it_app/mars_space/features/domain/usecase/delete_child_usecase.dart'
    as delete_child_usecase;

import '../../../../../../../core/error/failures.dart';
import '../../../../../../../core/local_db/shared_pref.dart';
import '../../../../../../../core/usecase/usecase.dart';
import '../../../../../../data/enum/loading_state_enum.dart';

part 'profile_event.dart';

part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final MySharedPref mySharedPref;
  final GetChildrenUseCase getChildrenUseCase;
  final get_profile_usecase.GetProfileUseCase getProfileUseCase;
  final delete_child_usecase.DeleteChildUseCase deleteChildUseCase;

  ProfileBloc({
    required this.mySharedPref,
    required this.getProfileUseCase,
    required this.getChildrenUseCase,
    required this.deleteChildUseCase,
  }) : super(const ProfileState()) {
    on<ProfileEvent>((event, emit) async {
      switch (event) {
        case GetProfileEvent():
          emit(state.copyWith(status: LoadingState.LOADING));
          final result = await getProfileUseCase(
              get_profile_usecase.Params(request: event.getProfileRequest));
          await _getProfile(state, emit, result);
          break;
        case GetChildrenEvent():
          emit(state.copyWith(status: LoadingState.LOADING));
          final result = await getChildrenUseCase(NoParams());
          _getChildren(state, emit, result);
          break;
        case DeleteChildEvent():
          emit(state.copyWith(status: LoadingState.LOADING));
          final result = await deleteChildUseCase(
              delete_child_usecase.Params(request: event.deleteChildRequest));
          _deleteChild(state, emit, result);
          break;
      }
    });
  }

  Future<void> _getProfile(
    ProfileState state,
    Emitter<ProfileState> emit,
    Either<Failure, GetProfileResponseEntity> result,
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
          getStudentResult: Right(success),
        ));
      },
    );
  }

  Future<void> _deleteChild(
    ProfileState state,
    Emitter<ProfileState> emit,
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

  void _getChildren(
    ProfileState state,
    Emitter<ProfileState> emit,
    Either<Failure, List<GetChildrenResponseEntity>> getChildrenResult,
  ) async {
    getChildrenResult.fold(
      (failure) async {
        emit(state.copyWith(
          status: LoadingState.ERROR,
          errorMessage: failure.errorMessage,
        ));
      },
      (success) async {
        emit(state.copyWith(
          getChildrenResult: Right(success),
          status: LoadingState.LOADED,
        ));
      },
    );
  }
}
