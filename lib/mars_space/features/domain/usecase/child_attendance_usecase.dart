import 'package:dartz/dartz.dart';
import 'package:mars_it_app/mars_space/core/error/failures.dart';
import 'package:mars_it_app/mars_space/core/usecase/usecase.dart';
import 'package:mars_it_app/mars_space/features/domain/entity/response/attendance_response_entity.dart';
import 'package:mars_it_app/mars_space/features/domain/repository/home_repository.dart';

class GetChildAttendanceUseCase
    implements UseCase<List<AttendanceResponseEntity>, NoParams> {
  final HomeRepository repository;

  GetChildAttendanceUseCase({required this.repository});

  @override
  Future<Either<Failure, List<AttendanceResponseEntity>>> call(
      NoParams params) async {
    return await repository.getStudentAttendance();
  }
}
