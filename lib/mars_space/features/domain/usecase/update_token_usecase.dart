import 'package:dartz/dartz.dart';
import 'package:mars_it_app/mars_space/core/error/failures.dart';
import 'package:mars_it_app/mars_space/core/usecase/usecase.dart';

import '../repository/auth_repository.dart';

class UpdateTokenUseCase implements UseCase<void, NoParams> {
  final AuthRepository repository;

  UpdateTokenUseCase({required this.repository});

  @override
  Future<Either<Failure, void>> call(NoParams params) async {
    return await repository.updateToken();
  }
}
