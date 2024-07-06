import 'package:dartz/dartz.dart';
import 'package:mars_it_app/mars_space/core/error/failures.dart';
import 'package:mars_it_app/mars_space/features/data/datasource/home_data_source.dart';
import 'package:mars_it_app/mars_space/features/domain/entity/request/get_group_attendance_request_entity.dart';
import 'package:mars_it_app/mars_space/features/domain/entity/request/get_month_attendance_request_entity.dart';
import 'package:mars_it_app/mars_space/features/domain/entity/request/get_stories_request_entity.dart';
import 'package:mars_it_app/mars_space/features/domain/entity/response/attendance_response_entity.dart';
import 'package:mars_it_app/mars_space/features/domain/entity/response/child_balance_response_entity.dart';
import 'package:mars_it_app/mars_space/features/domain/entity/response/get_group_attendance_response_entity.dart';
import 'package:mars_it_app/mars_space/features/domain/entity/response/get_stories_response_entity.dart';
import 'package:mars_it_app/mars_space/features/domain/repository/home_repository.dart';

class HomeRepositoryImpl implements HomeRepository {
  final HomeDataSourceImpl homeDataSource;

  HomeRepositoryImpl({required this.homeDataSource});

  @override
  Future<Either<Failure, List<AttendanceResponseEntity>>>
      getStudentAttendance() async {
    try {
      final remote = await homeDataSource.getStudentAttendance();
      return Right(remote);
    } catch (e) {
      return Left(Failure(errorMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<AttendanceResponseEntity>>> getMonthAttendance(
      GetMonthAttendanceRequestEntity request) async {
    try {
      final requestModel = await request.toModel();
      final remote = await homeDataSource.getMonthAttendance(requestModel);
      return Right(remote);
    } catch (e) {
      return Left(Failure(errorMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, GetGroupAttendanceResponseEntity>> getGroupAttendance(GetGroupAttendanceRequestEntity request) async {
    try {
      final requestModel = await request.toModel();
      final remote = await homeDataSource.getGroupAttendance(requestModel);
      return Right(remote);
    } catch (e) {
      return Left(Failure(errorMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, ChildBalanceResponseEntity>>
      getStudentBalance() async {
    try {
      final remote = await homeDataSource.getStudentBalance();
      return Right(remote);
    } catch (e) {
      return Left(Failure(errorMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<GetStoriesResponseEntity>>> getStories(
      GetStoriesRequestEntity request) async {
    try {
      final requestModel = await request.toModel();
      final remote = await homeDataSource.getStories(requestModel);
      return Right(remote);
    } catch (e) {
      return Left(Failure(errorMessage: e.toString()));
    }
  }
}
