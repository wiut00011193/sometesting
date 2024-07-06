import 'package:mars_it_app/injection_handler.dart';
import 'package:mars_it_app/mars_space/core/local_db/shared_pref.dart';
import 'package:mars_it_app/mars_space/features/domain/entity/request/add_extra_lesson_request_entity.dart';

class AddExtraLessonRequestModel extends AddExtraLessonRequestEntity {
  AddExtraLessonRequestModel({
    required super.tutorId,
    required super.slotId,
    required super.forDate,
    required super.theme,
  });

  Future<Map<String, dynamic>> toJson() async {
    studentId = await di.get<MySharedPref>().getStudentModmeId();
    return {
      'student_id': studentId,
      'tutor_id': tutorId,
      'slot_id': slotId,
      'for_date': forDate,
      'theme': theme,
    };
  }
}
