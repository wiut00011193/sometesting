class GetCourseElementsRequestEntity {
  int? studentId;
  int? courseId;
  int? module;

  GetCourseElementsRequestEntity({
    required this.courseId,
    required this.module,
  });
}