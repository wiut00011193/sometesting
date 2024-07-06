import 'package:dartz/dartz.dart';
import 'package:mars_it_app/mars_space/core/error/failures.dart';
import 'package:mars_it_app/mars_space/features/domain/entity/response/get_ratings_response_entity.dart';

abstract class RatingRepository {
  Future<Either<Failure, GetRatingsResponseEntity>> getRatings();
}