import 'package:dartz/dartz.dart';
import 'package:mars_it_app/mars_space/core/error/failures.dart';
import 'package:mars_it_app/mars_space/features/data/model/request/get_course_element_request_model.dart';
import 'package:mars_it_app/mars_space/features/data/model/request/get_course_elements_request_model.dart';
import 'package:mars_it_app/mars_space/features/data/model/request/get_exam_result_request_model.dart';
import 'package:mars_it_app/mars_space/features/domain/entity/request/get_course_modules_request_entity.dart';
import 'package:mars_it_app/mars_space/features/domain/entity/response/get_course_element_response_entity.dart';
import 'package:mars_it_app/mars_space/features/domain/entity/response/get_course_elements_response_entity.dart';
import 'package:mars_it_app/mars_space/features/domain/entity/response/get_course_modules_response_entity.dart';
import 'package:mars_it_app/mars_space/features/domain/entity/response/get_exam_result_response_entity.dart';
import 'package:mars_it_app/mars_space/features/domain/entity/response/get_student_response_entity.dart';

abstract class LearningRepository {
  Future<Either<Failure, GetStudentResponseEntity>> getStudent();
  Future<Either<Failure, List<GetCourseElementsResponseEntity>>> getCourseElements(GetCourseElementsRequestModel request);
  Future<Either<Failure, GetCourseElementResponseEntity>> getCourseElement(GetCourseElementRequestModel request);
  Future<Either<Failure, GetExamResultResponseEntity>> getExamResult(GetExamResultRequestModel request);
  Future<Either<Failure, GetCourseModulesResponseEntity>> getCourseModules(GetCourseModulesRequestEntity request);
}