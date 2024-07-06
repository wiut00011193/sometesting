import 'package:mars_it_app/mars_space/features/domain/entity/response/get_course_elements_response_entity.dart';

class GetCourseElementsResponseModel extends GetCourseElementsResponseEntity {
  GetCourseElementsResponseModel({
    required super.id,
    required super.title,
    required super.about,
    required super.module,
    required super.order,
    required super.mark,
    required super.status,
    required super.answerStatus,
  });

  factory GetCourseElementsResponseModel.fromJson(Map<String, dynamic> json) {
    return GetCourseElementsResponseModel(
      id: json['id'] as int?,
      title: TitleModel.fromJson(json['title']),
      about: AboutModel.fromJson(json['about']),
      module: json['module'] as int?,
      order: json['order'] as int?,
      mark: json['mark'] != null ? json['mark'] as int? : null,
      status: json['status'] as String?,
      answerStatus: json['answer_status'] as String?,
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
