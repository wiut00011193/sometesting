part of 'learning_journey_bloc.dart';

@immutable
abstract class LearningJourneyEvent {}

class GetStudentEvent extends LearningJourneyEvent {}

class GetCourseModulesEvent extends LearningJourneyEvent {
  final GetCourseModulesRequestEntity getCourseModulesRequestEntity;

  GetCourseModulesEvent({required this.getCourseModulesRequestEntity});
}