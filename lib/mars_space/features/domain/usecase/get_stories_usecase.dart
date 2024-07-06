import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:mars_it_app/mars_space/core/error/failures.dart';
import 'package:mars_it_app/mars_space/core/usecase/usecase.dart';
import 'package:mars_it_app/mars_space/features/data/model/request/get_stories_request_model.dart';
import 'package:mars_it_app/mars_space/features/domain/entity/response/get_stories_response_entity.dart';
import 'package:mars_it_app/mars_space/features/domain/repository/home_repository.dart';

class GetStoriesUseCase implements UseCase<List<GetStoriesResponseEntity>, Params> {
  final HomeRepository repository;

  GetStoriesUseCase({required this.repository});

  @override
  Future<Either<Failure, List<GetStoriesResponseEntity>>> call(params) async {
    return await repository.getStories(params.requestModel);
  }
}

class Params extends Equatable {
  final GetStoriesRequestModel requestModel;

  const Params({required this.requestModel});

  @override
  List<Object> get props => [requestModel];
}