class GetCourseElementRequestEntity {
  int? studentId;
  int? groupId;
  int? courseElementId;

  GetCourseElementRequestEntity({
    required this.groupId,
    required this.courseElementId,
  });
}