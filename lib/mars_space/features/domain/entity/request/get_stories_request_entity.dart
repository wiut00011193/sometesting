import 'package:mars_it_app/mars_space/features/data/model/request/get_stories_request_model.dart';

class GetStoriesRequestEntity {
  String? type;

  GetStoriesRequestEntity({required this.type});

  Future<GetStoriesRequestModel> toModel() async {
    return GetStoriesRequestModel(
      type: type,
    );
  }
}
