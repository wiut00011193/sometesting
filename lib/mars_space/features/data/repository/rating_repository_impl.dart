import 'package:dartz/dartz.dart';
import 'package:mars_it_app/mars_space/core/error/failures.dart';
import 'package:mars_it_app/mars_space/features/data/datasource/rating_data_source.dart';
import 'package:mars_it_app/mars_space/features/domain/entity/response/get_ratings_response_entity.dart';
import 'package:mars_it_app/mars_space/features/domain/repository/rating_repository.dart';

class RatingRepositoryImpl extends RatingRepository {
  final RatingDataSourceImpl ratingDataSource;

  RatingRepositoryImpl({required this.ratingDataSource});

  @override
  Future<Either<Failure, GetRatingsResponseEntity>> getRatings() async {
    try {
      final remote = await ratingDataSource.getRatings();
      return Right(remote);
    } catch (e) {
      return Left(Failure(errorMessage: e.toString()));
    }
  }
}