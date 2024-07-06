import '../../../domain/entity/response/child_balance_response_entity.dart';

class ChildBalanceResponseModel extends ChildBalanceResponseEntity {
  ChildBalanceResponseModel({
    required super.id,
    required super.externalId,
    required super.firstName,
    required super.lastName,
    required super.liga,
    required super.coins,
    required super.xp,
    required super.balance,
    // required super.avatar,
    // required super.rank,
    required super.paymentLink,
    // required super.companyId,
    required super.groups,
    // required super.branches,
  });

  factory ChildBalanceResponseModel.fromJson(Map<String, dynamic> json) {
    return ChildBalanceResponseModel(
      id: json['id'] as int?,
      externalId: json['external_id'] as int?,
      firstName: json['first_name'] as String?,
      lastName: json['last_name'] as String?,
      liga: json['liga'] as int?,
      coins: json['coins'] as int?,
      xp: json['xp'] as int?,
      balance: json['balance'] as int?,
      // avatar: json['avatar'] as String?,
      // rank: json['rank'] == null
      //     ? null
      //     : RankModel.fromJson(json['rank'] as Map<String, dynamic>),
      paymentLink: json['payment_link'] as String?,
      // companyId: json['company_id'] as int?,
      groups: json['groups'] != null
          ? List<Group>.from(json['groups'].map((x) => GroupModel.fromJson(x)))
          : null,
      // branches: (json['branches'] as List<dynamic>?)
      //     ?.map((e) => BranchesModel.fromJson(e as Map<String, dynamic>))
      //     .toList(),
    );
  }
}

class GroupModel extends Group {
  GroupModel({
    required super.id,
    required super.name,
    required super.status,
    required super.teacher,
    required super.dateStarted,
    required super.dateFinished,
  });

  factory GroupModel.fromJson(Map<String, dynamic> json) {
    return GroupModel(
      id: json['id'] as int?,
      name: json['name'] as String?,
      status: json['status'] as int?,
      teacher: json['teacher'] as String?,
      dateStarted: json['date_started'] as String?,
      dateFinished: json['date_finished'] as String?,
    );
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
      task: json['task'] == null
          ? null
          : TaskModel.fromJson(json['task'] as Map<String, dynamic>),
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

class BranchesModel extends Branches {
  BranchesModel({
    required super.id,
    required super.externalId,
    required super.title,
    required super.uzTitle,
    required super.description,
  });

  factory BranchesModel.fromJson(Map<String, dynamic> json) {
    return BranchesModel(
      id: json['id'] as int?,
      externalId: json['external_id'] as int?,
      title: json['title'] as String?,
      uzTitle: json['uz_title'] as String?,
      description: json['description'] as String?,
    );
  }
}
