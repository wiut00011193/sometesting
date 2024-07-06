import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:mars_it_app/mars_space/core/error/failures.dart';
import 'package:mars_it_app/mars_space/core/usecase/usecase.dart';
import 'package:mars_it_app/mars_space/features/data/model/request/get_course_elements_request_model.dart';
import 'package:mars_it_app/mars_space/features/domain/entity/response/get_course_elements_response_entity.dart';
import 'package:mars_it_app/mars_space/features/domain/repository/learning_repository.dart';

class GetCourseElementsUseCase implements UseCase<List<GetCourseElementsResponseEntity>, Params> {
  final LearningRepository repository;

  GetCourseElementsUseCase({required this.repository});

  @override
  Future<Either<Failure, List<GetCourseElementsResponseEntity>>> call(Params params) async {
    return await repository.getCourseElements(params.request);
  }
}

class Params extends Equatable {
  final GetCourseElementsRequestModel request;

  const Params({required this.request});

  @override
  List<Object> get props => [request];
}