import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:mars_it_app/mars_space/core/error/failures.dart';
import 'package:mars_it_app/mars_space/core/usecase/usecase.dart';
import 'package:mars_it_app/mars_space/features/domain/entity/request/add_extra_lesson_request_entity.dart';
import 'package:mars_it_app/mars_space/features/domain/repository/booking_repository.dart';

class BookExtraLessonUseCase implements UseCase<void, Params> {
  final BookingRepository repository;
  BookExtraLessonUseCase({required this.repository});

  @override
  Future<Either<Failure, void>> call(Params params) async {
    return await repository.bookExtraLesson(params.request);
  }
}

class Params extends Equatable {
  final AddExtraLessonRequestEntity request;

  const Params({required this.request});

  @override
  List<Object> get props => [request];
}
