import 'package:mars_it_app/mars_space/features/domain/entity/response/get_ratings_response_entity.dart';

class GetRatingsResponseModel extends GetRatingsResponseEntity {
  GetRatingsResponseModel({
    required super.hackers,
    required super.coders,
    required super.gamers,
  });

  factory GetRatingsResponseModel.fromJson(Map<String, dynamic> json) {
    return GetRatingsResponseModel(
      hackers: ClanModel.fromJson(json['hackers']),
      coders: ClanModel.fromJson(json['coders']),
      gamers: ClanModel.fromJson(json['gamers']),
    );
  }
}

class ClanModel extends Clan {
  ClanModel({
    required super.total,
    required super.students,
  });

  factory ClanModel.fromJson(Map<String, dynamic> json) {
    return ClanModel(
      total: json['total'] as int?,
      students: List<StudentModel>.from(
          json['students'].map((x) => StudentModel.fromJson(x))),
    );
  }
}

class StudentModel extends Student {
  StudentModel({
    required super.id,
    required super.externalId,
    required super.firstName,
    required super.lastName,
    required super.avatar,
    required super.rank,
    required super.coins,
    required super.me,
    required super.liga,
    required super.order,
    required super.groups,
  });

  factory StudentModel.fromJson(Map<String, dynamic> json) {
    return StudentModel(
      id: json['id'] as int?,
      externalId: json['external_id'] as int?,
      firstName: json['first_name'] as String?,
      lastName: json['last_name'] as String?,
      avatar: json['avatar'] as String?,
      rank: json['rank'] != null
          ? RankModel.fromJson(json['rank'])
          : RankModel(
              title: 'null',
              image: 'null',
              liga: 0,
              task: TaskModel(
                level: 0,
                description: 'null',
                xpFrom: 0,
                xpTill: 0,
              )),
      coins: json['coins'] as int?,
      me: json['me'] as bool?,
      liga: json['liga'] as int?,
      order: json['order'] as int?,
      groups:
          List<Group>.from(json['groups'].map((x) => GroupModel.fromJson(x))),
    );
  }
}

class RankModel extends Rank {
  RankModel({
    required super.title,
    required super.image,
    required super.liga,
    required super.task,
  });

  factory RankModel.fromJson(Map<String, dynamic> json) {
    return RankModel(
      title: json['title'] as String?,
      image: json['image'] as String?,
      liga: json['liga'] as int?,
      task: TaskModel.fromJson(json['task']),
    );
  }
}

class TaskModel extends Task {
  TaskModel({
    required super.level,
    required super.description,
    required super.xpFrom,
    required super.xpTill,
  });

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      level: json['level'] as int?,
      description: json['description'] as String?,
      xpFrom: json['xp_from'] as int?,
      xpTill: json['xp_till'] as int?,
    );
  }
}

class GroupModel extends Group {
  GroupModel({
    required super.id,
    required super.name,
    required super.status,
    required super.course,
    required super.teacher,
    required super.dateStarted,
    required super.dateFinished,
    required super.lessonStartTime,
  });

  factory GroupModel.fromJson(Map<String, dynamic> json) {
    return GroupModel(
      id: json['id'] as int?,
      name: json['name'] as String?,
      status: json['status'] as int?,
      course: CourseModel.fromJson(json['course']),
      teacher: json['teacher'] as String?,
      dateStarted: json['date_started'] as String?,
      dateFinished: json['date_finished'] as String?,
      lessonStartTime: json['lesson_start_time'] as String?,
    );
  }
}

class CourseModel extends Course {
  CourseModel({
    required super.id,
    required super.externalId,
    required super.name,
  });

  factory CourseModel.fromJson(Map<String, dynamic> json) {
    return CourseModel(
      id: json['id'] as int?,
      externalId: json['external_id'] as int?,
      name: json['name'] as String?,
    );
  }
}
