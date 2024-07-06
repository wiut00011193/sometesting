import 'package:dartz/dartz.dart';
import 'package:mars_it_app/mars_space/core/error/failures.dart';
import 'package:mars_it_app/mars_space/features/data/datasource/learning_data_source.dart';
import 'package:mars_it_app/mars_space/features/data/model/request/get_course_element_request_model.dart';
import 'package:mars_it_app/mars_space/features/data/model/request/get_course_elements_request_model.dart';
import 'package:mars_it_app/mars_space/features/data/model/request/get_exam_result_request_model.dart';
import 'package:mars_it_app/mars_space/features/domain/entity/request/get_course_modules_request_entity.dart';
import 'package:mars_it_app/mars_space/features/domain/entity/response/get_course_element_response_entity.dart';
import 'package:mars_it_app/mars_space/features/domain/entity/response/get_course_elements_response_entity.dart';
import 'package:mars_it_app/mars_space/features/domain/entity/response/get_course_modules_response_entity.dart';
import 'package:mars_it_app/mars_space/features/domain/entity/response/get_exam_result_response_entity.dart';
import 'package:mars_it_app/mars_space/features/domain/entity/response/get_student_response_entity.dart';
import 'package:mars_it_app/mars_space/features/domain/repository/learning_repository.dart';

class LearningRepositoryImpl extends LearningRepository {
  final LearningDataSourceImpl learningDataSource;

  LearningRepositoryImpl({required this.learningDataSource});

  @override
  Future<Either<Failure, GetStudentResponseEntity>> getStudent() async {
    try {
      final remote = await learningDataSource.getStudent();
      return Right(remote);
    } catch (e) {
      return Left(Failure(errorMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<GetCourseElementsResponseEntity>>>
      getCourseElements(GetCourseElementsRequestModel request) async {
    try {
      final remote = await learningDataSource.getCourseElements(request);
      return Right(remote);
    } catch (e) {
      return Left(Failure(errorMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, GetCourseElementResponseEntity>> getCourseElement(
      GetCourseElementRequestModel request) async {
    try {
      final remote = await learningDataSource.getCourseElement(request);
      return Right(remote);
    } catch (e) {
      return Left(Failure(errorMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, GetExamResultResponseEntity>> getExamResult(
      GetExamResultRequestModel request) async {
    try {
      final remote = await learningDataSource.getExamResult(request);
      return Right(remote);
    } catch (e) {
      return Left(Failure(errorMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, GetCourseModulesResponseEntity>> getCourseModules(
      GetCourseModulesRequestEntity request) async {
    try {
      final requestModel = await request.toModel();
      final remote = await learningDataSource.getCourseModules(requestModel);
      return Right(remote);
    } catch (e) {
      return Left(Failure(errorMessage: e.toString()));
    }
  }
}
