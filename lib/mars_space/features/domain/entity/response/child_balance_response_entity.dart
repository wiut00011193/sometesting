class ChildBalanceResponseEntity {
  int? id;
  int? externalId;
  String? firstName;
  String? lastName;
  int? liga;
  int? coins;
  int? xp;
  int? balance;
  String? avatar;
  Rank? rank;
  String? paymentLink;
  int? companyId;
  List<Group>? groups;
  List<Branches>? branches;

  ChildBalanceResponseEntity({
    this.id,
    this.externalId,
    this.firstName,
    this.lastName,
    this.liga,
    this.coins,
    this.xp,
    this.balance,
    this.avatar,
    this.rank,
    this.paymentLink,
    this.companyId,
    this.groups,
    this.branches,
  });
}

class Group {
  int? id;
  String? name;
  int? status;
  String? teacher;
  String? dateStarted;
  String? dateFinished;

  Group({
    this.id,
    this.name,
    this.status,
    this.teacher,
    this.dateStarted,
    this.dateFinished,
  });
}

class Rank {
  Task? task;
  String? title;
  String? image;
  int? liga;

  Rank({
    this.task,
    this.title,
    this.image,
    this.liga,
  });
}

class Task {
  int? level;
  int? xpFrom;
  int? xpTill;
  bool? rank;

  Task({
    this.level,
    this.xpFrom,
    this.xpTill,
    this.rank,
  });
}

class Branches {
  int? id;
  int? externalId;
  String? title;
  String? uzTitle;
  String? description;

  Branches({
    this.id,
    this.externalId,
    this.title,
    this.uzTitle,
    this.description,
  });
}
