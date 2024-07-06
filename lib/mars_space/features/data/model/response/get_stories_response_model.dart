import 'package:mars_it_app/mars_space/features/domain/entity/response/get_stories_response_entity.dart';

class GetStoriesResponseModel extends GetStoriesResponseEntity {
  GetStoriesResponseModel({
    required super.id,
    required super.imageUrl,
    required super.dateTime,
  });

  factory GetStoriesResponseModel.fromJson(Map<String, dynamic> json) {
    return GetStoriesResponseModel(
      id: json['id'] as int?,
      imageUrl: json['image'] as String?,
      dateTime: json['date_time'] as String?,
    );
  }
}
