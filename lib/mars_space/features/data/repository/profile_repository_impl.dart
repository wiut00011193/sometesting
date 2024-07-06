import 'package:dartz/dartz.dart';
import 'package:mars_it_app/mars_space/core/error/failures.dart';
import 'package:mars_it_app/mars_space/features/data/datasource/auth_data_source.dart';
import 'package:mars_it_app/mars_space/features/domain/entity/request/delete_child_request_entity.dart';
import 'package:mars_it_app/mars_space/features/domain/entity/response/get_children_response_entity.dart';
import 'package:mars_it_app/mars_space/features/domain/repository/profile_repository.dart';

class ProfileRepositoryImpl extends ProfileRepository {
  final AuthDataSourceImpl authDataSource;

  ProfileRepositoryImpl({required this.authDataSource});

  @override
  Future<Either<Failure, List<GetChildrenResponseEntity>>> getChildren() async {
    try {
      final remote = await authDataSource.getChildren();
      return Right(remote);
    } catch (e) {
      return Left(Failure(errorMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteChild(DeleteChildRequestEntity request) async {
    try {
      final requestModel = await request.toModel();
      final remote = await authDataSource.deleteChild(requestModel);
      return Right(remote);
    } catch (e) {
      return Left(Failure(errorMessage: e.toString()));
    }
  }
}