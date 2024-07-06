class GetChildrenResponseEntity {
  int? objectId;
  int? id;
  int? externalId;
  int? companyId;
  String? firstName;
  String? lastName;
  Company? company;

  GetChildrenResponseEntity({
    required this.objectId,
    required this.id,
    required this.externalId,
    required this.companyId,
    required this.firstName,
    required this.lastName,
    required this.company,
  });
}

class Company {
  int? id;
  String? title;
  String? paymentLink;
  bool? isActive;

  Company({
    required this.id,
    required this.title,
    required this.paymentLink,
    required this.isActive,
  });
}
