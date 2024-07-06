import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:mars_it_app/mars_space/core/error/failures.dart';
import 'package:mars_it_app/mars_space/core/usecase/usecase.dart';
import 'package:mars_it_app/mars_space/features/data/model/request/send_verification_code_request_model.dart';
import 'package:mars_it_app/mars_space/features/domain/repository/auth_repository.dart';

class SendVerificationCodeUseCase implements UseCase<void, Params> {
  final AuthRepository repository;

  SendVerificationCodeUseCase({required this.repository});

  @override
  Future<Either<Failure, void>> call(Params params) async {
    return await repository.sendVerificationCode(params.requestModel);
  }
}

class Params extends Equatable {
  final SendVerificationCodeRequestModel requestModel;

  const Params({required this.requestModel});

  @override
  List<Object> get props => [requestModel];
}