import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mars_it_app/mars_space/features/data/enum/loading_state_enum.dart';
import 'package:mars_it_app/mars_space/features/data/model/request/login_request_model.dart';
import 'package:mars_it_app/mars_space/features/data/model/request/send_verification_code_request_model.dart';
import 'package:mars_it_app/mars_space/features/data/model/request/signup_request_model.dart';
import 'package:mars_it_app/mars_space/features/data/model/request/verify_phone_number_request_model.dart';
import 'package:mars_it_app/mars_space/features/domain/entity/response/verify_phone_number_response_entity.dart';

import '../../../../../../core/error/failures.dart';
import '../../../../../domain/entity/response/signup_response_entity.dart';
import '../../../../../domain/usecase/signup_usecase.dart' as sign_up_usecase;
import '../../../../../domain/usecase/check_user_exists_usecase.dart'
    as check_user_exists_usecase;
import '../../../../../domain/usecase/send_verification_code_usecase.dart'
    as send_verification_code_usecase;
import '../../../../../domain/usecase/verify_phone_number_usecase.dart'
    as verify_phone_number_usecase;

part 'sign_up_event.dart';

part 'sign_up_state.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  final sign_up_usecase.SignUpUseCase signUpUseCase;
  final check_user_exists_usecase.CheckUserExistsUseCase checkUserExistsUseCase;
  final send_verification_code_usecase.SendVerificationCodeUseCase
      sendVerificationUseCase;
  final verify_phone_number_usecase.VerifyPhoneNumberUseCase
      verifyPhoneNumberUseCase;

  SignUpBloc({
    required this.signUpUseCase,
    required this.checkUserExistsUseCase,
    required this.sendVerificationUseCase,
    required this.verifyPhoneNumberUseCase,
  }) : super(const SignUpState()) {
    on<SignUpEvent>((event, emit) async {
      switch (event) {
        case SignUpUserEvent():
          emit(state.copyWith(status: LoadingState.LOADING));
          final result = await signUpUseCase(
              sign_up_usecase.Params(requestModel: event.signUpRequestModel));
          _signUpUser(state, emit, result);
          break;
        case SendVerificationCodeEvent():
          await sendVerificationUseCase(send_verification_code_usecase.Params(
              requestModel: event.sendVerificationCodeRequestModel));
          break;
        case VerifyPhoneNumberEvent():
          emit(state.copyWith(status: LoadingState.LOADING));
          final result = await verifyPhoneNumberUseCase(
              verify_phone_number_usecase.Params(
                  requestModel: event.verifyPhoneNumberRequestModel));
          _verifyPhoneNumber(state, emit, result);
          break;
        case CheckUserExistsEvent():
          emit(state.copyWith(status: LoadingState.LOADING));
          final result = await checkUserExistsUseCase(
              check_user_exists_usecase.Params(
                  requestModel: event.logInRequestModel));
          _checkUserExists(state, emit, result);
          break;
      }
    });
  }

  void _signUpUser(
    SignUpState state,
    Emitter<SignUpState> emit,
    Either<Failure, SignUpResponseEntity> result,
  ) async {
    result.fold(
      (failure) async => {
        emit(state.copyWith(
          status: LoadingState.ERROR,
          errorMessage: failure.errorMessage,
        )),
      },
      (success) async {
        emit(state.copyWith(status: LoadingState.LOADED));
      },
    );
  }

  void _checkUserExists(
    SignUpState state,
    Emitter<SignUpState> emit,
    Either<Failure, bool> result,
  ) async {
    result.fold(
      (failure) async => {
        emit(state.copyWith(
          status: LoadingState.ERROR,
          errorMessage: failure.errorMessage,
        )),
      },
      (success) async {
        emit(state.copyWith(
          status: LoadingState.LOADED,
          checkUserExistsResult: Right(success),
        ));
      },
    );
  }

  void _verifyPhoneNumber(
    SignUpState state,
    Emitter<SignUpState> emit,
    Either<Failure, VerifyPhoneNumberResponseEntity> result,
  ) async {
    result.fold(
      (failure) async => {
        emit(state.copyWith(
          status: LoadingState.ERROR,
          errorMessage: failure.errorMessage,
        )),
      },
      (success) async {
        emit(state.copyWith(
          status: LoadingState.LOADED,
          verificationResult: Right(success),
        ));
      },
    );
  }
}
