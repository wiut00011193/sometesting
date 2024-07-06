part of 'profile_bloc.dart';

@immutable
abstract class ProfileEvent {}

class GetChildrenEvent extends ProfileEvent {}

class GetProfileEvent extends ProfileEvent {
  final GetProfileRequestModel getProfileRequest;
  GetProfileEvent({required this.getProfileRequest});
}

class DeleteChildEvent extends ProfileEvent {
  final DeleteChildRequestEntity deleteChildRequest;
  DeleteChildEvent({required this.deleteChildRequest});
}
