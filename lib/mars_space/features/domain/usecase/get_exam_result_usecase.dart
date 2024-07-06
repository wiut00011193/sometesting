import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:mars_it_app/mars_space/core/error/failures.dart';
import 'package:mars_it_app/mars_space/core/usecase/usecase.dart';
import 'package:mars_it_app/mars_space/features/data/model/request/get_exam_result_request_model.dart';
import 'package:mars_it_app/mars_space/features/domain/entity/response/get_exam_result_response_entity.dart';
import 'package:mars_it_app/mars_space/features/domain/repository/learning_repository.dart';

class GetExamResultUseCase implements UseCase<GetExamResultResponseEntity, Params> {
  final LearningRepository repository;

  GetExamResultUseCase({required this.repository});

  @override
  Future<Either<Failure, GetExamResultResponseEntity>> call(params) async {
    return await repository.getExamResult(params.request);
  }
}

class Params extends Equatable {
  final GetExamResultRequestModel request;

  const Params({required this.request});

  @override
  List<Object> get props => [request];
}