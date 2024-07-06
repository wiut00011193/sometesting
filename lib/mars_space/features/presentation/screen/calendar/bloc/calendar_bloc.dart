import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

part 'calendar_event.dart';

part 'calendar_state.dart';

class CalendarBloc extends Bloc<CalendarEvent, CalendarState> {
  CalendarBloc() : super(CalendarInitial()) {
    on<CalendarEvent>((event, emit) async {
      // some logic
    });
  }
}
