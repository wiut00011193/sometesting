import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:mars_it_app/mars_space/core/error/failures.dart';
import 'package:mars_it_app/mars_space/core/usecase/usecase.dart';

import '../../data/model/request/get_profile_request_model.dart';
import '../entity/response/get_profile_response_entity.dart';
import '../repository/auth_repository.dart';

class GetProfileUseCase implements UseCase<GetProfileResponseEntity, Params> {
  final AuthRepository repository;

  GetProfileUseCase({required this.repository});

  @override
  Future<Either<Failure, GetProfileResponseEntity>> call(Params params) async {
    return await repository.getProfile(params.request);
  }
}

class Params extends Equatable {
  final GetProfileRequestModel request;

  const Params({required this.request});

  @override
  List<Object> get props => [request];
}
