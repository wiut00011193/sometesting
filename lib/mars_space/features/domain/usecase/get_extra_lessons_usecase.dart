import 'package:dartz/dartz.dart';
import 'package:mars_it_app/mars_space/core/error/failures.dart';
import 'package:mars_it_app/mars_space/core/usecase/usecase.dart';
import 'package:mars_it_app/mars_space/features/domain/entity/response/get_extra_lessons_response_entity.dart';
import 'package:mars_it_app/mars_space/features/domain/repository/booking_repository.dart';

class GetExtraLessonsUseCase
    implements UseCase<List<GetExtraLessonsResponseEntity>, NoParams> {
  final BookingRepository repository;
  GetExtraLessonsUseCase({required this.repository});

  @override
  Future<Either<Failure, List<GetExtraLessonsResponseEntity>>> call(
      NoParams params) async {
    return await repository.getExtraLessons();
  }
}
