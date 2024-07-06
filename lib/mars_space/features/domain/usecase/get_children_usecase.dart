import 'package:dartz/dartz.dart';
import 'package:mars_it_app/mars_space/features/domain/entity/response/get_children_response_entity.dart';
import 'package:mars_it_app/mars_space/features/domain/repository/profile_repository.dart';

import '../../../core/error/failures.dart';
import '../../../core/usecase/usecase.dart';

class GetChildrenUseCase
    implements UseCase<List<GetChildrenResponseEntity>, NoParams> {
  final ProfileRepository repository;

  GetChildrenUseCase({required this.repository});

  @override
  Future<Either<Failure, List<GetChildrenResponseEntity>>> call(
      NoParams params) async {
    return await repository.getChildren();
  }
}