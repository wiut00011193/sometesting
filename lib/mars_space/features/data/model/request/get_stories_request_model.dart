import 'package:mars_it_app/mars_space/features/domain/entity/request/get_stories_request_entity.dart';

class GetStoriesRequestModel extends GetStoriesRequestEntity {
  GetStoriesRequestModel({required super.type});
  
  Map<String, dynamic> toJson() {
    return {
      'type': type,
    };
  }
}