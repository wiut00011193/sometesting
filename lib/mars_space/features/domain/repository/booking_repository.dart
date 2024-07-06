import 'package:dartz/dartz.dart';
import 'package:mars_it_app/mars_space/core/error/failures.dart';
import 'package:mars_it_app/mars_space/features/domain/entity/request/add_extra_lesson_request_entity.dart';
import 'package:mars_it_app/mars_space/features/domain/entity/request/get_user_slots_request_entity.dart';
import 'package:mars_it_app/mars_space/features/domain/entity/response/get_extra_lessons_response_entity.dart';
import 'package:mars_it_app/mars_space/features/domain/entity/response/get_tutors_response_entity.dart';
import 'package:mars_it_app/mars_space/features/domain/entity/response/get_user_slots_response_entity.dart';

abstract class BookingRepository {
  Future<Either<Failure, List<GetExtraLessonsResponseEntity>>> getExtraLessons();
  Future<Either<Failure, List<GetTutorsResponseEntity>>> getTutors();
  Future<Either<Failure, List<GetUserSlotsResponseEntity>>> getUserSlots(GetUserSlotsRequestEntity request);
  Future<Either<Failure, void>> bookExtraLesson(AddExtraLessonRequestEntity request);
}