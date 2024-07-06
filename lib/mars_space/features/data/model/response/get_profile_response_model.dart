import 'package:mars_it_app/mars_space/features/domain/entity/response/get_profile_response_entity.dart';

class GetProfileResponseModel extends GetProfileResponseEntity {
  GetProfileResponseModel({
    required super.studentId,
    required super.externalId,
    required super.companyId,
    required super.firstName,
    required super.lastName,
    required super.coins,
    required super.xp,
    required super.avatar,
    required super.rank,
  });

  factory GetProfileResponseModel.fromJson(Map<String, dynamic> json) {
    return GetProfileResponseModel(
        studentId: json['id'] as int?,
        externalId: json['external_id'] as int?,
        companyId: json['company_id'] as int?,
        firstName: json['first_name'] as String?,
        lastName: json['last_name'] as String?,
        coins: json['coins'] as int?,
        xp: json['xp'] as int?,
        avatar: json['avatar'] as String?,
        rank: json['rank'] != null
            ? RankModel.fromJson(json['rank'])
            : RankModel(
                task: TaskModel(level: 0, xpFrom: 0, xpTill: 0, rank: true),
                title: 'null',
                image: 'null',
                liga: 0));
  }
}

class RankModel extends Rank {
  RankModel({
    required super.task,
    required super.title,
    required super.image,
    required super.liga,
  });

  factory RankModel.fromJson(Map<String, dynamic> json) {
    return RankModel(
      task: TaskModel.fromJson(json['task']),
      title: json['title'] as String?,
      image: json['image'] as String?,
      liga: json['liga'] as int?,
    );
  }
}

class TaskModel extends Task {
  TaskModel({
    required super.level,
    required super.xpFrom,
    required super.xpTill,
    required super.rank,
  });

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      level: json['level'] as int?,
      xpFrom: json['xp_from'] as int?,
      xpTill: json['xp_till'] as int?,
      rank: json['rank'] as bool?,
    );
  }
}
