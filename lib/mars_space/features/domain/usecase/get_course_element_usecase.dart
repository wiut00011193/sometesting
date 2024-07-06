import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:mars_it_app/mars_space/core/error/failures.dart';
import 'package:mars_it_app/mars_space/core/usecase/usecase.dart';
import 'package:mars_it_app/mars_space/features/data/model/request/get_course_element_request_model.dart';
import 'package:mars_it_app/mars_space/features/domain/entity/response/get_course_element_response_entity.dart';
import 'package:mars_it_app/mars_space/features/domain/repository/learning_repository.dart';

class GetCourseElementUseCase implements UseCase<GetCourseElementResponseEntity, Params>{
  final LearningRepository repository;

  GetCourseElementUseCase({required this.repository});
  
  @override
  Future<Either<Failure, GetCourseElementResponseEntity>> call(Params params) async {
    return await repository.getCourseElement(params.request);
  }
}

class Params extends Equatable {
  final GetCourseElementRequestModel request;

  const Params({required this.request});

  @override
  List<Object> get props => [request];
}