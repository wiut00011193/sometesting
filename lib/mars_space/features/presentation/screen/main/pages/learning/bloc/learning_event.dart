part of 'learning_bloc.dart';

@immutable
abstract class LearningEvent {}

class GetStudentEvent extends LearningEvent {}

class GetCourseElementsEvent extends LearningEvent {
  final GetCourseElementsRequestModel getCourseElementsRequestModel;

  GetCourseElementsEvent({required this.getCourseElementsRequestModel});
}

class GetCourseElementEvent extends LearningEvent {
  final GetCourseElementRequestModel getCourseElementRequestModel;
  GetCourseElementEvent({required this.getCourseElementRequestModel});
}

class GetExamResultEvent extends LearningEvent {
  final GetExamResultRequestModel getExamResultRequestModel;
  GetExamResultEvent({required this.getExamResultRequestModel});
}

class GetCourseModulesEvent extends LearningEvent {
  final GetCourseModulesRequestEntity getCourseModulesRequestEntity;

  GetCourseModulesEvent({required this.getCourseModulesRequestEntity});
}
