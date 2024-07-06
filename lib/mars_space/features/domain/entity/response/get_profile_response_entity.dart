class GetProfileResponseEntity {
  int? studentId;
  int? externalId;
  int? companyId;
  String? firstName;
  String? lastName;
  int? coins;
  int? xp;
  String? avatar;
  Rank? rank;

  GetProfileResponseEntity({
    required this.studentId,
    required this.externalId,
    required this.companyId,
    required this.firstName,
    required this.lastName,
    required this.coins,
    required this.xp,
    required this.avatar,
    required this.rank,
  });
}

class Rank {
  Task? task;
  String? title;
  String? image;
  int? liga;

  Rank({
    required this.task,
    required this.title,
    required this.image,
    required this.liga,
  });
}

class Task {
  int? level;
  int? xpFrom;
  int? xpTill;
  bool? rank;

  Task({
    required this.level,
    required this.xpFrom,
    required this.xpTill,
    required this.rank,
  });
}