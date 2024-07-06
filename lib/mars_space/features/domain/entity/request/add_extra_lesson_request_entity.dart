import 'package:mars_it_app/mars_space/features/data/model/request/add_extra_lesson_request_model.dart';

class AddExtraLessonRequestEntity {
  int? studentId;
  int? tutorId;
  int? slotId;
  String? forDate;
  String? theme;

  AddExtraLessonRequestEntity({
    required this.tutorId,
    required this.slotId,
    required this.forDate,
    required this.theme,
  });

  Future<AddExtraLessonRequestModel> toModel() async {
    return AddExtraLessonRequestModel(
      tutorId: tutorId,
      slotId: slotId,
      forDate: forDate,
      theme: theme,
    );
  }
}
