import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:mars_it_app/mars_space/core/error/failures.dart';
import 'package:mars_it_app/mars_space/core/usecase/usecase.dart';
import 'package:mars_it_app/mars_space/features/data/model/request/signup_request_model.dart';

import '../entity/response/signup_response_entity.dart';
import '../repository/auth_repository.dart';

class SignUpUseCase implements UseCase<SignUpResponseEntity, Params> {
  final AuthRepository repository;

  SignUpUseCase({required this.repository});

  @override
  Future<Either<Failure, SignUpResponseEntity>> call(Params params) async {
    return await repository.signup(params.requestModel);
  }
}

class Params extends Equatable {
  final SignUpRequestModel requestModel;

  const Params({required this.requestModel});

  @override
  List<Object> get props => [requestModel];
}
