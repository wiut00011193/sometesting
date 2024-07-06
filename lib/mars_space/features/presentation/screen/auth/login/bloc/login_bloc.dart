import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

import '../../../../../../core/error/failures.dart';
import '../../../../../../core/local_db/shared_pref.dart';
import '../../../../../data/enum/loading_state_enum.dart';
import '../../../../../data/model/request/login_request_model.dart';
import '../../../../../domain/entity/response/login_response_entity.dart';
import '../../../../../domain/usecase/login_usecase.dart';

part 'login_event.dart';

part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LoginUseCase loginUseCase;
  final MySharedPref pref;

  LoginBloc({
    required this.loginUseCase,
    required this.pref,
  }) : super(const LoginState()) {
    on<LoginEvent>((event, emit) async {
      switch (event) {
        case LoginUserEvent():
          emit(state.copyWith(status: LoadingState.LOADING));
          final result =
              await loginUseCase(Params(requestModel: event.requestModel));
          final studentId = await pref.getStudentId();
          _loginUser(state, emit, result, studentId);
          break;
      }
    });
  }

  void _loginUser(
    LoginState state,
    Emitter<LoginState> emit,
    Either<Failure, LoginResponseEntity> result,
    int studentId,
  ) async {
    result.fold(
      (failure) async => emit(state.copyWith(
        status: LoadingState.ERROR,
        errorMessage: failure.errorMessage,
      )),
      (success) async {
        // checking child is exist or not
        if (studentId == 0) {
          emit(state.copyWith(
            status: LoadingState.LOADED,
            isChildExist: false,
          ));
        } else {
          emit(state.copyWith(
            status: LoadingState.LOADED,
            isChildExist: true,
          ));
        }
      },
    );
  }
}
