class GetRatingsResponseEntity {
  Clan? hackers;
  Clan? coders;
  Clan? gamers;

  GetRatingsResponseEntity({
    required this.hackers,
    required this.coders,
    required this.gamers,
  });
}

class Clan {
  int? total;
  List<Student>? students;

  Clan({
    required this.total,
    required this.students,
  });
}

class Student {
  int? id;
  int? externalId;
  String? firstName;
  String? lastName;
  String? avatar;
  Rank? rank;
  int? coins;
  bool? me;
  int? liga;
  int? order;
  List<Group>? groups;

  Student({
    required this.id,
    required this.externalId,
    required this.firstName,
    required this.lastName,
    required this.avatar,
    required this.rank,
    required this.coins,
    required this.me,
    required this.liga,
    required this.order,
    required this.groups,
  });
}

class Rank {
  String? title;
  String? image;
  int? liga;
  Task? task;

  Rank({
    required this.title,
    required this.image,
    required this.liga,
    required this.task,
  });
}

class Task {
  int? level;
  String? description;
  int? xpFrom;
  int? xpTill;

  Task({
    required this.level,
    required this.description,
    required this.xpFrom,
    required this.xpTill,
  });
}

class Group {
  int? id;
  String? name;
  int? status;
  Course? course;
  String? teacher;
  String? dateStarted;
  String? dateFinished;
  String? lessonStartTime;

  Group({
    required this.id,
    required this.name,
    required this.status,
    required this.course,
    required this.teacher,
    required this.dateStarted,
    required this.dateFinished,
    required this.lessonStartTime,
  });
}

class Course {
  int? id;
  int? externalId;
  String? name;

  Course({
    required this.id,
    required this.externalId,
    required this.name,
  });
}
