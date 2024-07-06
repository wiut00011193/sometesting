part of 'add_child_second_bloc.dart';

@immutable
abstract class AddChildSecondEvent {}

class AddChildEvent extends AddChildSecondEvent {
  final AddChildRequestModel request;

  AddChildEvent({required this.request});
}

@immutable
abstract class GetProfileSecondEvent extends AddChildSecondEvent {}

class GetProfileEvent extends GetProfileSecondEvent {
  final GetProfileRequestModel request;

  GetProfileEvent({required this.request});
}

@immutable
abstract class SearchStudentSecondEvent extends AddChildSecondEvent {}

class SearchStudentEvent extends SearchStudentSecondEvent {
  final SearchStudentRequestModel request;

  SearchStudentEvent({required this.request});
}
