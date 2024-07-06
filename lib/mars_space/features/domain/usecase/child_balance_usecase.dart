import 'package:dartz/dartz.dart';
import 'package:mars_it_app/mars_space/core/error/failures.dart';
import 'package:mars_it_app/mars_space/core/usecase/usecase.dart';
import 'package:mars_it_app/mars_space/features/domain/entity/response/child_balance_response_entity.dart';
import 'package:mars_it_app/mars_space/features/domain/repository/home_repository.dart';

class GetChildBalanceUseCase
    implements UseCase<ChildBalanceResponseEntity, NoParams> {
  final HomeRepository repository;

  GetChildBalanceUseCase({required this.repository});

  @override
  Future<Either<Failure, ChildBalanceResponseEntity>> call(
      NoParams params) async {
    return await repository.getStudentBalance();
  }
}
