class GetExamResultResponseEntity {
  int? overall;
  List<Data>? data;

  GetExamResultResponseEntity({
    required this.overall,
    required this.data,
  });
}

class Data {
  int? id;
  String? feedback;
  int? mark;
  String? title;
  int? themeId;
  String? file;
  String? link;

  Data({
    required this.id,
    required this.feedback,
    required this.mark,
    required this.title,
    required this.themeId,
    required this.file,
    required this.link,
  });
}
