import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:mars_it_app/mars_space/core/error/failures.dart';
import 'package:mars_it_app/mars_space/core/usecase/usecase.dart';
import 'package:mars_it_app/mars_space/features/domain/entity/response/add_child_response_entity.dart';

import '../../data/model/request/add_child_request_model.dart';
import '../repository/auth_repository.dart';

class AddChildUseCase implements UseCase<AddChildResponseEntity, Params> {
  final AuthRepository repository;

  AddChildUseCase({required this.repository});

  @override
  Future<Either<Failure, AddChildResponseEntity>> call(Params params) async {
    return await repository.addChild(params.request);
  }
}

class Params extends Equatable {
  final AddChildRequestModel request;

  const Params({required this.request});

  @override
  List<Object> get props => [request];
}
