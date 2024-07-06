part of 'home_bloc.dart';

@immutable
abstract class HomeEvent {}

class GetBalanceEvent extends HomeEvent {}

class GetAttendanceEvent extends HomeEvent {}

class GetStories extends HomeEvent {
  final GetStoriesRequestModel requestModel;
  GetStories({required this.requestModel});
}

class GetMonthAttendanceEvent extends HomeEvent {
  final GetMonthAttendanceRequestEntity getMonthAttendanceRequest;
  GetMonthAttendanceEvent({required this.getMonthAttendanceRequest});
}

class GetGroupAttendanceEvent extends HomeEvent {
  final GetGroupAttendanceRequestEntity getGroupAttendanceRequest;
  GetGroupAttendanceEvent({required this.getGroupAttendanceRequest});
}

class GetExtraLessonsEvent extends HomeEvent {}

class LogOut extends HomeEvent {}
