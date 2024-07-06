class SearchStudentResponseEntity {
  int? id;
  int? externalId;
  String? name;
  Profile? profile;

  SearchStudentResponseEntity({
    required this.id,
    required this.externalId,
    required this.name,
    required this.profile,
  });
}

class Profile {
  String? avatar;
  
  Profile({required this.avatar});
}