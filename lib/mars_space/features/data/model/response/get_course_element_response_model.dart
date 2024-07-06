import 'package:mars_it_app/mars_space/features/domain/entity/response/get_course_element_response_entity.dart';

class GetCourseElementResponseModel extends GetCourseElementResponseEntity {
  GetCourseElementResponseModel({
    required super.id,
    required super.title,
    required super.about,
    required super.module,
    required super.order,
    required super.theory,
    required super.project,
    required super.answer,
  });

  factory GetCourseElementResponseModel.fromJson(Map<String, dynamic> json) {
    return GetCourseElementResponseModel(
      id: json['id'] as int?,
      title: Title(
          uz: json['title_uz'] as String?, ru: json['title_ru'] as String?),
      about: About(
          uz: json['about_uz'] as String?, ru: json['about_ru'] as String?),
      module: json['module'] as int?,
      order: json['order'] as int?,
      theory: json['theory'] != null
          ? TheoryModel.fromJson(json['theory'])
          : Theory(
              id: null,
              images: null,
              files: null,
              text: TheoryText(
                uz: 'Nazariya mavjud emas',
                ru: 'Теория не найдена',
              )),
      project: ProjectModel.fromJson(json['project']),
      answer: json['answers'].isEmpty != true
          ? List<AnswerModel>.from(
              json['answers'].map((x) => AnswerModel.fromJson(x)))[0]
          : Answer(
              id: null,
              comment: null,
              mark: null,
              project: AnswerProject(
                  id: null, file: null, link: null, comments: null),
              status: 'opened'),
    );
  }
}

class AnswerModel extends Answer {
  AnswerModel({
    required super.id,
    required super.status,
    required super.comment,
    required super.mark,
    required super.project,
  });

  factory AnswerModel.fromJson(Map<String, dynamic> json) {
    return AnswerModel(
      id: json['id'] as int?,
      status: json['status'] as String?,
      comment: json['comment'] as String?,
      mark: json['mark'] as int?,
      project: AnswerProjectModel.fromJson(json['project']),
    );
  }
}

class AnswerProjectModel extends AnswerProject {
  AnswerProjectModel({
    required super.id,
    required super.file,
    required super.link,
    required super.comments,
  });

  factory AnswerProjectModel.fromJson(Map<String, dynamic> json) {
    return AnswerProjectModel(
      id: json['id'] as int?,
      file: json['file'] as String?,
      link: json['link'] as String?,
      comments: json['comments'] as String?,
    );
  }
}

class TitleModel extends Title {
  TitleModel({
    required super.uz,
    required super.ru,
  });

  factory TitleModel.fromJson(Map<String, dynamic> json) {
    return TitleModel(
      uz: json['uz'] as String?,
      ru: json['ru'] as String?,
    );
  }
}

class AboutModel extends About {
  AboutModel({
    required super.uz,
    required super.ru,
  });

  factory AboutModel.fromJson(Map<String, dynamic> json) {
    return AboutModel(
      uz: json['uz'] as String?,
      ru: json['ru'] as String?,
    );
  }
}

class TheoryModel extends Theory {
  TheoryModel({
    required super.id,
    required super.images,
    required super.files,
    required super.text,
  });

  factory TheoryModel.fromJson(Map<String, dynamic> json) {
    return TheoryModel(
      id: json['id'],
      images: null,
      files: null,
      text: TheoryText(
          uz: json['text_uz'] as String?, ru: json['text_ru'] as String?),
    );
  }
}

class TheoryTextModel extends TheoryText {
  TheoryTextModel({
    required super.uz,
    required super.ru,
  });

  factory TheoryTextModel.fromJson(Map<String, dynamic> json) {
    return TheoryTextModel(
      uz: json['uz'] as String?,
      ru: json['ru'] as String?,
    );
  }
}

class ProjectModel extends Project {
  ProjectModel({
    required super.id,
    required super.requirements,
    required super.description,
  });

  factory ProjectModel.fromJson(Map<String, dynamic> json) {
    return ProjectModel(
      id: json['id'] as int?,
      requirements: List<ProjectRequirementModel>.from(
          json['requirements'].map((x) => ProjectRequirementModel.fromJson(x))),
      description: ProjectDescription(
          uz: json['description_uz'] as String?,
          ru: json['description_ru'] as String?),
    );
  }
}

class ProjectRequirementModel extends ProjectRequirement {
  ProjectRequirementModel({
    required super.uz,
    required super.ru,
    required super.coins,
  });

  factory ProjectRequirementModel.fromJson(Map<String, dynamic> json) {
    return ProjectRequirementModel(
      uz: json['uz'] as String?,
      ru: json['ru'] as String?,
      coins: json['coins'] as int?,
    );
  }
}

class ProjectDescriptionModel extends ProjectDescription {
  ProjectDescriptionModel({
    required super.uz,
    required super.ru,
  });

  factory ProjectDescriptionModel.fromJson(Map<String, dynamic> json) {
    return ProjectDescriptionModel(
      uz: json['uz'] as String?,
      ru: json['ru'] as String?,
    );
  }
}
