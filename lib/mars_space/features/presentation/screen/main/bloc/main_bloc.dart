import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:mars_it_app/injection_handler.dart';

part 'main_event.dart';

part 'main_state.dart';

class MainBloc extends Bloc<MainEvent, MainState> {
  MainBloc() : super(const MainState()) {
    on<MainEvent>((event, emit) async {
      switch (event) {
        case ItemTappedEvent():
          emit(state.copyWith(selectedIndex: event.index));
          break;
        case CheckScreenEvent():
          if (event.currentIndex != 0) {
            di.get<MainBloc>().add(ItemTappedEvent(index: 0));
            emit(state.copyWith(checkScreen: false));
          } else {
            emit(state.copyWith(checkScreen: true));
          }
          break;
      }
    });
  }
}
