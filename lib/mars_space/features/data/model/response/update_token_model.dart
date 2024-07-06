import 'package:mars_it_app/mars_space/features/domain/entity/response/update_token_entity.dart';

class UpdateTokenModel extends UpdateTokenEntity {
  UpdateTokenModel({
    required super.accessToken,
    required super.refreshToken,
  });

  factory UpdateTokenModel.fromJson(Map<String, dynamic> json) {
    return UpdateTokenModel(
      accessToken: json['access_token'] as String?,
      refreshToken: json['refresh_token'] as String?,
    );
  }
}
