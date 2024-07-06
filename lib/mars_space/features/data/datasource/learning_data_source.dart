import 'package:dio/dio.dart';
import 'package:mars_it_app/mars_space/core/utils/constants.dart';
import 'package:mars_it_app/mars_space/features/data/model/request/get_course_element_request_model.dart';
import 'package:mars_it_app/mars_space/features/data/model/request/get_course_elements_request_model.dart';
import 'package:mars_it_app/mars_space/features/data/model/request/get_course_modules_request_model.dart';
import 'package:mars_it_app/mars_space/features/data/model/request/get_exam_result_request_model.dart';
import 'package:mars_it_app/mars_space/features/data/model/response/get_course_element_response_model.dart';
import 'package:mars_it_app/mars_space/features/data/model/response/get_course_elements_response_model.dart';
import 'package:mars_it_app/mars_space/features/data/model/response/get_course_modules_response_model.dart';
import 'package:mars_it_app/mars_space/features/data/model/response/get_exam_result_response_model.dart';
import 'package:mars_it_app/mars_space/features/data/model/response/get_student_response_model.dart';

import '../../../core/local_db/shared_pref.dart';

abstract class LearningDataSource {
  Future<GetStudentResponseModel> getStudent();
  Future<List<GetCourseElementsResponseModel>> getCourseElements(
      GetCourseElementsRequestModel requestModel);
  Future<GetCourseElementResponseModel> getCourseElement(
      GetCourseElementRequestModel requestModel);
  Future<GetExamResultResponseModel> getExamResult(
      GetExamResultRequestModel requestModel);
  Future<GetCourseModulesResponseModel> getCourseModules(
      GetCourseModulesRequestModel requestModel);
}

class LearningDataSourceImpl implements LearningDataSource {
  final Dio dio;
  final MySharedPref pref;

  LearningDataSourceImpl({
    required this.dio,
    required this.pref,
  });

  @override
  Future<GetStudentResponseModel> getStudent() async {
    final studentModmeId = await pref.getStudentModmeId();
    final accessToken = await pref.getAccessToken();

    final response = await dio.get(
      '${EndPoints.path_get_student}/$studentModmeId',
      options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final responseModel = GetStudentResponseModel.fromJson(response.data);

      return responseModel;
    } else {
      throw Exception(response.statusMessage);
    }
  }

  @override
  Future<List<GetCourseElementsResponseModel>> getCourseElements(
      GetCourseElementsRequestModel requestModel) async {
    final studentModmeId = await pref.getStudentModmeId();
    final accessToken = await pref.getAccessToken();

    final response = await dio.get(
      "student/$studentModmeId/answers",
      queryParameters: await requestModel.toJson(),
      options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      List<dynamic> courseElementsList = response.data ?? [];
      List<GetCourseElementsResponseModel> responseModel = courseElementsList
          .map((json) => GetCourseElementsResponseModel.fromJson(json))
          .toList();

      return responseModel;
    } else {
      throw Exception(response.statusMessage);
    }
  }

  @override
  Future<GetCourseElementResponseModel> getCourseElement(
      GetCourseElementRequestModel requestModel) async {
    final studentModmeId = await pref.getStudentModmeId();
    final accessToken = await pref.getAccessToken();

    final response = await dio.get(
      'student/$studentModmeId/answer',
      queryParameters: await requestModel.toJson(),
      options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      final responseModel =
          GetCourseElementResponseModel.fromJson(response.data);

      return responseModel;
    } else {
      throw Exception(response.statusMessage);
    }
  }

  @override
  Future<GetExamResultResponseModel> getExamResult(
      GetExamResultRequestModel requestModel) async {
    final response = await dio.get(
      EndPoints.path_child_exam_result,
      queryParameters: await requestModel.toJson(),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final responseModel = GetExamResultResponseModel.fromJson(response.data);
      
      return responseModel;
    } else {
      throw Exception(response.statusMessage);
    }
  }

  @override
  Future<GetCourseModulesResponseModel> getCourseModules(
      GetCourseModulesRequestModel requestModel) async {
    final accessToken = await pref.getAccessToken();
    final response = await dio.get(
      'courses/${requestModel.courseId}/modules',
      options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final responseModel = GetCourseModulesResponseModel.fromJson(response.data);

      return responseModel;
    } else {
      throw Exception(response.statusMessage);
    }
  }
}
