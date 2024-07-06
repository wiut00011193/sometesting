import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:mars_it_app/mars_space/core/error/failures.dart';
import 'package:mars_it_app/mars_space/core/usecase/usecase.dart';
import 'package:mars_it_app/mars_space/features/domain/entity/response/login_response_entity.dart';

import '../../data/model/request/login_request_model.dart';
import '../repository/auth_repository.dart';

class LoginUseCase implements UseCase<LoginResponseEntity, Params> {
  final AuthRepository repository;

  LoginUseCase({required this.repository});

  @override
  Future<Either<Failure, LoginResponseEntity>> call(Params params) async {
    return await repository.login(params.requestModel);
  }
}

class Params extends Equatable {
  final LoginRequestModel requestModel;

  const Params({required this.requestModel});

  @override
  List<Object> get props => [requestModel];
}
