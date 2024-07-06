import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:mars_it_app/mars_space/core/error/failures.dart';
import 'package:mars_it_app/mars_space/core/usecase/usecase.dart';
import 'package:mars_it_app/mars_space/features/data/model/request/verify_phone_number_request_model.dart';
import 'package:mars_it_app/mars_space/features/domain/entity/response/verify_phone_number_response_entity.dart';
import 'package:mars_it_app/mars_space/features/domain/repository/auth_repository.dart';

class VerifyPhoneNumberUseCase implements UseCase<VerifyPhoneNumberResponseEntity, Params> {
  final AuthRepository repository;

  VerifyPhoneNumberUseCase({required this.repository});

  @override
  Future<Either<Failure, VerifyPhoneNumberResponseEntity>> call(Params params) async {
    return await repository.verifyPhoneNumber(params.requestModel);
  }
}

class Params extends Equatable {
  final VerifyPhoneNumberRequestModel requestModel;

  const Params({required this.requestModel});

  @override
  List<Object> get props => [requestModel];
}