import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:mars_it_app/mars_space/core/error/failures.dart';
import 'package:mars_it_app/mars_space/core/usecase/usecase.dart';
import 'package:mars_it_app/mars_space/features/data/model/request/search_student_request_model.dart';
import 'package:mars_it_app/mars_space/features/domain/entity/response/search_student_response_entity.dart';

import '../repository/auth_repository.dart';

class SearchStudentUseCase implements UseCase<List<SearchStudentResponseEntity>, Params> {
  final AuthRepository repository;

  SearchStudentUseCase({required this.repository});

  @override
  Future<Either<Failure, List<SearchStudentResponseEntity>>> call(Params params) async {
    return await repository.searchStudent(params.request);
  }
}

class Params extends Equatable {
  final SearchStudentRequestModel request;

  const Params({required this.request});

  @override
  List<Object> get props => [request];
}
