import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:mars_it_app/mars_space/core/error/failures.dart';
import 'package:mars_it_app/mars_space/core/usecase/usecase.dart';
import 'package:mars_it_app/mars_space/features/domain/entity/request/get_user_slots_request_entity.dart';
import 'package:mars_it_app/mars_space/features/domain/entity/response/get_user_slots_response_entity.dart';
import 'package:mars_it_app/mars_space/features/domain/repository/booking_repository.dart';

class GetUserSlotsUseCase implements UseCase<List<GetUserSlotsResponseEntity>, Params> {
  final BookingRepository repository;

  GetUserSlotsUseCase({required this.repository});
  
  @override
  Future<Either<Failure, List<GetUserSlotsResponseEntity>>> call(Params params) async {
    return await repository.getUserSlots(params.request);
  }
}

class Params extends Equatable {
  final GetUserSlotsRequestEntity request;

  const Params({required this.request});

  @override
  List<Object> get props => [request];
}