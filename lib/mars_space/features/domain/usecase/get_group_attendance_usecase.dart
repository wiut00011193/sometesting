import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:mars_it_app/mars_space/core/error/failures.dart';
import 'package:mars_it_app/mars_space/core/usecase/usecase.dart';
import 'package:mars_it_app/mars_space/features/domain/entity/request/get_group_attendance_request_entity.dart';
import 'package:mars_it_app/mars_space/features/domain/entity/response/get_group_attendance_response_entity.dart';
import 'package:mars_it_app/mars_space/features/domain/repository/home_repository.dart';

class GetGroupAttendanceUseCase implements UseCase<GetGroupAttendanceResponseEntity, Params> {
  final HomeRepository repository;
  GetGroupAttendanceUseCase({required this.repository});

  @override
  Future<Either<Failure, GetGroupAttendanceResponseEntity>> call(Params params) async {
    return await repository.getGroupAttendance(params.request);
  }
}

class Params extends Equatable {
  final GetGroupAttendanceRequestEntity request;

  const Params({required this.request});

  @override
  List<Object> get props => [request];
}