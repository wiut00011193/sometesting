import 'package:mars_it_app/mars_space/features/domain/entity/response/get_children_response_entity.dart';

class GetChildrenResponseModel extends GetChildrenResponseEntity {
  GetChildrenResponseModel({
    required super.objectId,
    required super.id,
    required super.externalId,
    required super.companyId,
    required super.firstName,
    required super.lastName,
    required super.company,
  });

  factory GetChildrenResponseModel.fromJson(Map<String, dynamic> json) {
    return GetChildrenResponseModel(
      objectId: json['id'] as int?,
      id: json['student_id'] as int?,
      externalId: json['external_id'] as int?,
      companyId: json['company_id'] as int?,
      firstName: json['first_name'] as String?,
      lastName: json['last_name'] as String?,
      company: json['company'] == null ? null : CompanyModel.fromJson(json['company']),
    );
  }
}

class CompanyModel extends Company {
  CompanyModel({
    required super.id,
    required super.title,
    required super.paymentLink,
    required super.isActive,
  });

  factory CompanyModel.fromJson(Map<String, dynamic> json) {
    return CompanyModel(
      id: json['id'] as int?,
      title: json['title'] as String?,
      paymentLink: json['payment_link'] as String?,
      isActive: json['is_active'] as bool?,
    );
  }
}
