import 'package:mars_it_app/mars_space/features/domain/entity/response/get_extra_lessons_response_entity.dart';

class GetExtraLessonsResponseModel extends GetExtraLessonsResponseEntity {
  GetExtraLessonsResponseModel({
    required super.forDate,
    required super.data,
  });

  factory GetExtraLessonsResponseModel.fromJson(Map<String, dynamic> json) {
    return GetExtraLessonsResponseModel(
        forDate: json['for_date'] as String?,
        data: List<Data>.from(json['data'].map((x) => DataModel.fromJson(x))));
  }
}

class DataModel extends Data {
  DataModel({
    required super.id,
    required super.tutor,
    required super.slot,
    required super.comment,
    required super.status,
    required super.theme,
    required super.mark,
  });

  factory DataModel.fromJson(Map<String, dynamic> json) {
    return DataModel(
      id: json['id'] as int?,
      tutor: TutorModel.fromJson(json['tutor']),
      slot: SlotModel.fromJson(json['slot']),
      comment: json['comment'] as String?,
      status: json['status'] as String?,
      theme: json['theme'] as String?,
      mark: json['mark'] as int?,
    );
  }
}

class TutorModel extends Tutor {
  TutorModel({
    required super.id,
    required super.firstName,
    required super.lastName,
  });

  factory TutorModel.fromJson(Map<String, dynamic> json) {
    return TutorModel(
      id: json['id'] as int?,
      firstName: json['first_name'] as String?,
      lastName: json['last_name'] as String?,
    );
  }
}

class SlotModel extends Slot {
  SlotModel({
    required super.id,
    required super.fromHour,
    required super.tillHour,
    required super.isBooked,
  });

  factory SlotModel.fromJson(Map<String, dynamic> json) {
    return SlotModel(
      id: json['id'] as int?,
      fromHour: json['from_hour'] as String?,
      tillHour: json['till_hour'] as String?,
      isBooked: json['is_booked'] as bool?,
    );
  }
}
