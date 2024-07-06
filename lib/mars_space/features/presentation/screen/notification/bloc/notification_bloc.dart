import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

part 'notification_event.dart';

part 'notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  NotificationBloc() : super(NotificationInitial()) {
    on<NotificationEvent>((event, emit) async {
      // some logic
    });
  }
}
