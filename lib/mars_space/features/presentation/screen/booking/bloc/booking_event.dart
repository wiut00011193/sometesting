part of 'booking_bloc.dart';

@immutable
abstract class BookingEvent {}

class GetExtraLessonsEvent extends BookingEvent {}

class GetTutorsEvent extends BookingEvent {}

class GetUserSlotsEvent extends BookingEvent {
  final GetUserSlotsRequestEntity getUserSlotsRequest;

  GetUserSlotsEvent({required this.getUserSlotsRequest});
}

class BookExtraLessonEvent extends BookingEvent {
  final AddExtraLessonRequestEntity addExtraLessonRequest;

  BookExtraLessonEvent({required this.addExtraLessonRequest});
}