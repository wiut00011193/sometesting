import 'package:dartz/dartz.dart';
import 'package:mars_it_app/mars_space/core/error/failures.dart';
import 'package:mars_it_app/mars_space/core/usecase/usecase.dart';
import 'package:mars_it_app/mars_space/features/domain/entity/response/get_student_response_entity.dart';
import 'package:mars_it_app/mars_space/features/domain/repository/learning_repository.dart';

class GetStudentUseCase implements UseCase<GetStudentResponseEntity, NoParams> {
  final LearningRepository repository;

  GetStudentUseCase({required this.repository});

  @override
  Future<Either<Failure, GetStudentResponseEntity>> call(NoParams params) async {
    return await repository.getStudent();
  }
}