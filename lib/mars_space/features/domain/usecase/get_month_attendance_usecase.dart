import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:mars_it_app/mars_space/core/error/failures.dart';
import 'package:mars_it_app/mars_space/core/usecase/usecase.dart';
import 'package:mars_it_app/mars_space/features/domain/entity/request/get_month_attendance_request_entity.dart';
import 'package:mars_it_app/mars_space/features/domain/entity/response/attendance_response_entity.dart';
import 'package:mars_it_app/mars_space/features/domain/repository/home_repository.dart';

class GetMonthAttendanceUseCase
    implements UseCase<List<AttendanceResponseEntity>, Params> {
  final HomeRepository repository;
  GetMonthAttendanceUseCase({required this.repository});

  @override
  Future<Either<Failure, List<AttendanceResponseEntity>>> call(
      Params params) async {
    return await repository.getMonthAttendance(params.request);
  }
}

class Params extends Equatable {
  final GetMonthAttendanceRequestEntity request;

  const Params({required this.request});

  @override
  List<Object> get props => [request];
}
