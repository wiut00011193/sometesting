import 'package:dartz/dartz.dart';
import 'package:mars_it_app/mars_space/core/error/failures.dart';
import 'package:mars_it_app/mars_space/features/domain/entity/request/get_group_attendance_request_entity.dart';
import 'package:mars_it_app/mars_space/features/domain/entity/request/get_month_attendance_request_entity.dart';
import 'package:mars_it_app/mars_space/features/domain/entity/request/get_stories_request_entity.dart';
import 'package:mars_it_app/mars_space/features/domain/entity/response/attendance_response_entity.dart';
import 'package:mars_it_app/mars_space/features/domain/entity/response/child_balance_response_entity.dart';
import 'package:mars_it_app/mars_space/features/domain/entity/response/get_group_attendance_response_entity.dart';
import 'package:mars_it_app/mars_space/features/domain/entity/response/get_stories_response_entity.dart';

abstract class HomeRepository {
  Future<Either<Failure, ChildBalanceResponseEntity>> getStudentBalance();

  Future<Either<Failure, List<AttendanceResponseEntity>>>
      getStudentAttendance();

  Future<Either<Failure, GetGroupAttendanceResponseEntity>> getGroupAttendance(
      GetGroupAttendanceRequestEntity request);

  Future<Either<Failure, List<GetStoriesResponseEntity>>> getStories(
      GetStoriesRequestEntity request);

  Future<Either<Failure, List<AttendanceResponseEntity>>> getMonthAttendance(
      GetMonthAttendanceRequestEntity request);
}
