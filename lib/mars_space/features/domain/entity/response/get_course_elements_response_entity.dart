class GetCourseElementsResponseEntity {
  int? id;
  Title? title;
  About? about;
  int? module;
  int? order;
  int? mark;
  String? status;
  String? answerStatus;

  GetCourseElementsResponseEntity({
    required this.id,
    required this.title,
    required this.about,
    required this.module,
    required this.order,
    required this.mark,
    required this.status,
    required this.answerStatus,
  });
}

class Title {
  String? uz;
  String? ru;

  Title({
    required this.uz,
    required this.ru,
  });
}

class About {
  String? uz;
  String? ru;

  About({
    required this.uz,
    required this.ru,
  });
}
