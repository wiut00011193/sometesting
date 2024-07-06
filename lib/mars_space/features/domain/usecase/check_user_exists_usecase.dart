import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:mars_it_app/mars_space/core/error/failures.dart';
import 'package:mars_it_app/mars_space/core/usecase/usecase.dart';
import 'package:mars_it_app/mars_space/features/data/model/request/login_request_model.dart';
import 'package:mars_it_app/mars_space/features/domain/repository/auth_repository.dart';

class CheckUserExistsUseCase implements UseCase<bool, Params> {
  final AuthRepository repository;

  CheckUserExistsUseCase({required this.repository});

  @override
  Future<Either<Failure, bool>> call(Params params) async {
    return await repository.checkUserExists(params.requestModel);
  }
}

class Params extends Equatable {
  final LoginRequestModel requestModel;

  const Params({required this.requestModel});

  @override
  List<Object> get props => [requestModel];
}
