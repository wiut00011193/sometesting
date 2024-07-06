import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:mars_it_app/mars_space/core/usecase/usecase.dart';
import 'package:mars_it_app/mars_space/features/data/enum/loading_state_enum.dart';

import '../../../../../core/local_db/shared_pref.dart';
import '../../../../domain/usecase/update_token_usecase.dart';

part 'splash_event.dart';

part 'splash_state.dart';

class SplashBloc extends Bloc<SplashEvent, SplashState> {
  final MySharedPref mySharedPref;
  final UpdateTokenUseCase updateTokenUseCase;

  SplashBloc({
    required this.mySharedPref,
    required this.updateTokenUseCase,
  }) : super(const SplashState()) {
    on<SplashEvent>((event, emit) async {
      switch (event) {
        case CheckAuthEvent():
          await _checkAuth(state, emit);
          break;
      }
    });
  }

  Future<void> _checkAuth(SplashState state, Emitter<SplashState> emit) async {
    final refreshToken = await mySharedPref.getRefreshToken();
    final studentId = await mySharedPref.getStudentId();
    if (refreshToken.isNotEmpty) {
      final result = await updateTokenUseCase(NoParams());

      result.fold(
        (failure) async {
          emit(state.copyWith(state: AuthState.SIGNIN));
        },
        (success) async {
          if (studentId == 0) {
            emit(state.copyWith(state: AuthState.SIGNIN));
          } else {
            emit(state.copyWith(state: AuthState.HOME));
          }
        },
      );
    } else {
      emit(state.copyWith(state: AuthState.SIGNIN));
    }
  }
}
