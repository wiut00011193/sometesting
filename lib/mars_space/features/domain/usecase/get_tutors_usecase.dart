import 'package:dartz/dartz.dart';
import 'package:mars_it_app/mars_space/core/error/failures.dart';
import 'package:mars_it_app/mars_space/core/usecase/usecase.dart';
import 'package:mars_it_app/mars_space/features/domain/entity/response/get_tutors_response_entity.dart';
import 'package:mars_it_app/mars_space/features/domain/repository/booking_repository.dart';

class GetTutorsUseCase implements UseCase<List<GetTutorsResponseEntity>, NoParams> {
  final BookingRepository repository;

  GetTutorsUseCase({required this.repository});

  @override
  Future<Either<Failure, List<GetTutorsResponseEntity>>> call(NoParams params) async {
    return await repository.getTutors();
  }
}