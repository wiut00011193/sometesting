class GetTutorsResponseEntity {
  int? id;
  String? firstName;
  String? lastName;
  List<String>? position;
  Profile? profile;

  GetTutorsResponseEntity({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.position,
    required this.profile,
  });
}

class Profile {
  int? id;
  String? avatar;

  Profile({
    required this.id,
    required this.avatar,
  });
}
