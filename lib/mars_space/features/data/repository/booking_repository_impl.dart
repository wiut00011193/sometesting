import 'package:dartz/dartz.dart';
import 'package:mars_it_app/mars_space/core/error/failures.dart';
import 'package:mars_it_app/mars_space/features/data/datasource/booking_data_source.dart';
import 'package:mars_it_app/mars_space/features/domain/entity/request/add_extra_lesson_request_entity.dart';
import 'package:mars_it_app/mars_space/features/domain/entity/request/get_user_slots_request_entity.dart';
import 'package:mars_it_app/mars_space/features/domain/entity/response/get_extra_lessons_response_entity.dart';
import 'package:mars_it_app/mars_space/features/domain/entity/response/get_tutors_response_entity.dart';
import 'package:mars_it_app/mars_space/features/domain/entity/response/get_user_slots_response_entity.dart';
import 'package:mars_it_app/mars_space/features/domain/repository/booking_repository.dart';

class BookingRepositoryImpl extends BookingRepository {
  final BookingDataSourceImpl bookingDataSource;

  BookingRepositoryImpl({required this.bookingDataSource});

  @override
  Future<Either<Failure, List<GetExtraLessonsResponseEntity>>>
      getExtraLessons() async {
    try {
      final remote = await bookingDataSource.getExtraLessons();
      return Right(remote);
    } catch (e) {
      return Left(Failure(errorMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<GetTutorsResponseEntity>>> getTutors() async {
    try {
      final remote = await bookingDataSource.getTutors();
      return Right(remote);
    } catch (e) {
      return Left(Failure(errorMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<GetUserSlotsResponseEntity>>> getUserSlots(
      GetUserSlotsRequestEntity request) async {
    try {
      final requestModel = await request.toModel();
      final remote = await bookingDataSource.getUserSlots(requestModel);
      return Right(remote);
    } catch (e) {
      return Left(Failure(errorMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> bookExtraLesson(AddExtraLessonRequestEntity request) async {
    try {
      final requestModel = await request.toModel();
      final remote = await bookingDataSource.bookExtraLesson(requestModel);
      return Right(remote);
    } catch (e) {
      return Left(Failure(errorMessage: e.toString()));
    }
  }
}
