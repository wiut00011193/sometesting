import 'package:mars_it_app/mars_space/features/domain/entity/response/get_exam_result_response_entity.dart';

class GetExamResultResponseModel extends GetExamResultResponseEntity {
  GetExamResultResponseModel({
    required super.overall,
    required super.data,
  });

  factory GetExamResultResponseModel.fromJson(Map<String, dynamic> json) {
    return GetExamResultResponseModel(
      overall: json['overall'] as int?,
      data: json['data'] != null
          ? List<Data>.from(json['data'].map((x) => DataModel.fromJson(x)))
          : null,
    );
  }
}

class DataModel extends Data {
  DataModel({
    required super.id,
    required super.feedback,
    required super.mark,
    required super.title,
    required super.themeId,
    required super.file,
    required super.link,
  });

  factory DataModel.fromJson(Map<String, dynamic> json) {
    return DataModel(
      id: json['id'] as int?,
      feedback: json['feedback'] as String?,
      mark: json['mark'] as int?,
      title: json['title'] as String?,
      themeId: json['theme_id'] as int?,
      file: json['file'] as String?,
      link: json['link'] as String?,
    );
  }
}
