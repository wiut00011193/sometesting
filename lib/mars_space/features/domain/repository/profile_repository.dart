import 'package:dartz/dartz.dart';
import 'package:mars_it_app/mars_space/core/error/failures.dart';
import 'package:mars_it_app/mars_space/features/domain/entity/request/delete_child_request_entity.dart';
import 'package:mars_it_app/mars_space/features/domain/entity/response/get_children_response_entity.dart';

abstract class ProfileRepository{
  Future<Either<Failure, List<GetChildrenResponseEntity>>> getChildren();
  Future<Either<Failure, void>> deleteChild(DeleteChildRequestEntity request);
}