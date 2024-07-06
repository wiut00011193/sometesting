import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:mars_it_app/mars_space/core/error/failures.dart';
import 'package:mars_it_app/mars_space/core/usecase/usecase.dart';
import 'package:mars_it_app/mars_space/features/domain/entity/request/delete_child_request_entity.dart';
import 'package:mars_it_app/mars_space/features/domain/repository/profile_repository.dart';

class DeleteChildUseCase implements UseCase<void, Params> {
  final ProfileRepository repository;
  DeleteChildUseCase({required this.repository});

  @override
  Future<Either<Failure, void>> call(Params params) async {
    return await repository.deleteChild(params.request);
  }
}

class Params extends Equatable {
  final DeleteChildRequestEntity request;

  const Params({required this.request});

  @override
  List<Object> get props => [request];
}