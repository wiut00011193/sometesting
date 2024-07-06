class GetCourseElementResponseEntity {
  int? id;
  Title? title;
  About? about;
  int? module;
  int? order;

  Theory? theory;
  Project? project;

  Answer? answer;

  GetCourseElementResponseEntity.create();

  GetCourseElementResponseEntity({
    required this.id,
    required this.title,
    required this.about,
    required this.module,
    required this.order,
    required this.theory,
    required this.project,
    required this.answer,
  });
}

class Answer {
  int? id;
  String? status;
  String? comment;
  int? mark;
  AnswerProject? project;

  Answer({
    required this.id,
    required this.status,
    required this.comment,
    required this.mark,
    required this.project,
  });
}

class AnswerProject {
  int? id;
  String? file;
  String? link;
  String? comments;

  AnswerProject({
    required this.id,
    required this.file,
    required this.link,
    required this.comments,
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

class Theory {
  int? id;
  List<String>? images;
  List<String>? files;
  TheoryText? text;

  Theory({
    required this.id,
    required this.images,
    required this.files,
    required this.text,
  });
}

class TheoryText {
  String? uz;
  String? ru;

  TheoryText({
    required this.uz,
    required this.ru,
  });
}

class Project {
  int? id;
  List<ProjectRequirement>? requirements;
  ProjectDescription? description;

  Project({
    required this.id,
    required this.requirements,
    required this.description,
  });
}

class ProjectRequirement {
  String? uz;
  String? ru;
  int? coins;

  ProjectRequirement({
    required this.uz,
    required this.ru,
    required this.coins,
  });
}

class ProjectDescription {
  String? uz;
  String? ru;

  ProjectDescription({
    required this.uz,
    required this.ru,
  });
}
