import 'package:dartz/dartz.dart';
import 'package:mars_it_app/mars_space/core/error/failures.dart';
import 'package:mars_it_app/mars_space/core/usecase/usecase.dart';
import 'package:mars_it_app/mars_space/features/domain/entity/response/get_ratings_response_entity.dart';
import 'package:mars_it_app/mars_space/features/domain/repository/rating_repository.dart';

class GetRatingsUseCase implements UseCase<GetRatingsResponseEntity, NoParams> {
  final RatingRepository repository;

  GetRatingsUseCase({required this.repository});

  @override
  Future<Either<Failure, GetRatingsResponseEntity>> call(NoParams params) async {
    return await repository.getRatings();
  }

}