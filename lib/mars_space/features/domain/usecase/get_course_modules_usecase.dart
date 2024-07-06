import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:mars_it_app/mars_space/core/error/failures.dart';
import 'package:mars_it_app/mars_space/core/usecase/usecase.dart';
import 'package:mars_it_app/mars_space/features/domain/entity/request/get_course_modules_request_entity.dart';
import 'package:mars_it_app/mars_space/features/domain/entity/response/get_course_modules_response_entity.dart';
import 'package:mars_it_app/mars_space/features/domain/repository/learning_repository.dart';

class GetCourseModulesUseCase implements UseCase<GetCourseModulesResponseEntity, Params> {
  final LearningRepository repository;

  GetCourseModulesUseCase({required this.repository});

  @override
  Future<Either<Failure, GetCourseModulesResponseEntity>> call(Params params) async {
    return await repository.getCourseModules(params.request);
  }
}

class Params extends Equatable {
  final GetCourseModulesRequestEntity request;

  const Params({required this.request});

  @override
  List<Object> get props => [request];
}