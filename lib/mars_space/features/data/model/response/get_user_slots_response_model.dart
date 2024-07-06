import 'package:intl/intl.dart';
import 'package:mars_it_app/mars_space/features/domain/entity/response/get_user_slots_response_entity.dart';

class GetUserSlotsResponseModel extends GetUserSlotsResponseEntity {
  GetUserSlotsResponseModel({
    required super.date,
    required super.dayOfWeek,
    required super.slot,
  });

  factory GetUserSlotsResponseModel.fromJson(Map<String, dynamic> json) {
    DateTime dateTime = DateTime.parse(json['date'] as String);
    String dayOfWeek = DateFormat('EEEE').format(dateTime).toLowerCase();

    return GetUserSlotsResponseModel(
      date: json['date'] as String?,
      dayOfWeek: dayOfWeek,
      // slot: (json[dayOfWeek] as List<dynamic>).map((x) => SlotModel.fromJson(x)).toList(),
      slot: json[dayOfWeek] != null ? List<Slot>.from(json[dayOfWeek].map((x) => SlotModel.fromJson(x, dayOfWeek))) : [],
    );
  }
}

class SlotModel extends Slot {
  SlotModel({
    required super.id,
    required super.fromHour,
    required super.tillHour,
    required super.isActive,
  });

  factory SlotModel.fromJson(Map<String, dynamic> json, String dayOfWeek) {
    return SlotModel(
      id: json['id'] as int?,
      fromHour: json['from_hour'] as String?,
      tillHour: json['till_hour'] as String?,
      isActive: json['is_active'] as bool?,
    );
  }
}
