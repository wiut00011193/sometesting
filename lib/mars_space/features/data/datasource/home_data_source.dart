import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'package:mars_it_app/mars_space/core/utils/constants.dart';
import 'package:mars_it_app/mars_space/features/data/model/request/get_group_attendance_request_model.dart';
import 'package:mars_it_app/mars_space/features/data/model/request/get_month_attendance_request_model.dart';
import 'package:mars_it_app/mars_space/features/data/model/request/get_stories_request_model.dart';
import 'package:mars_it_app/mars_space/features/data/model/response/attendance_response_model.dart';
import 'package:mars_it_app/mars_space/features/data/model/response/child_balance_response_model.dart';
import 'package:mars_it_app/mars_space/features/data/model/response/get_group_attendance_response_model.dart';
import 'package:mars_it_app/mars_space/features/data/model/response/get_stories_response_model.dart';

import '../../../core/local_db/shared_pref.dart';

abstract class HomeDataSource {
  Future<ChildBalanceResponseModel> getStudentBalance();

  Future<List<AttendanceResponseModel>> getStudentAttendance();

  Future<GetGroupAttendanceResponseModel> getGroupAttendance(
      GetGroupAttendanceRequestModel requestModel);

  Future<List<AttendanceResponseModel>> getMonthAttendance(
      GetMonthAttendanceRequestModel requestModel);

  Future<List<GetStoriesResponseModel>> getStories(
      GetStoriesRequestModel requestModel);
}

class HomeDataSourceImpl implements HomeDataSource {
  final Dio dio;
  final MySharedPref pref;

  HomeDataSourceImpl({required this.dio, required this.pref});

  @override
  Future<ChildBalanceResponseModel> getStudentBalance() async {
    final studentModmeId = await pref.getStudentModmeId();
    final accessToken = await pref.getAccessToken();
    final response = await dio.get(
      EndPoints.path_child_balance,
      queryParameters: {
        'student_id': studentModmeId,
      },
      options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final responseModel =
          ChildBalanceResponseModel.fromJson(response.data['profile']);

      // await pref.setBranchId(responseModel.branches?.first.id ?? 0);
      return responseModel;
    } else {
      throw Exception(response.statusMessage);
    }
  }

  @override
  Future<List<AttendanceResponseModel>> getStudentAttendance() async {
    final datetimeString = await dio.get(EndPoints.path_get_datetime);
    DateTime datetime = DateFormat("yyyy-MM-ddTHH:mm:ss.SSSSSSZ")
        .parse(datetimeString.toString());
    int year = datetime.year;
    int month = datetime.month;
    int lastDayOfMonth = DateTime(year, month + 1, 0).day;
    final fromDate =
        '$year-${month >= 10 ? month : '0$month'}-01'; // year-month-day
    final tillDate = '$year-${month >= 10 ? month : '0$month'}-$lastDayOfMonth';
    final studentModmeId = await pref.getStudentModmeId();
    final accessToken = await pref.getAccessToken();
    final response = await dio.get(
      EndPoints.path_child_attendance,
      queryParameters: {
        'from_date': fromDate,
        'till_date': tillDate,
        'student_id': studentModmeId,
      },
      options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      List<dynamic> attendanceList = response.data ?? [];
      List<AttendanceResponseModel> responseModel = attendanceList
          .map((json) => AttendanceResponseModel.fromJson(json))
          .toList();

      return responseModel;
    } else {
      throw Exception(response.statusMessage);
    }
  }

  @override
  Future<GetGroupAttendanceResponseModel> getGroupAttendance(
      GetGroupAttendanceRequestModel requestModel) async {
    final accessToken = await pref.getAccessToken();
    final response = await dio.get(
      '${EndPoints.path_group_attendance}/${requestModel.groupId}',
      queryParameters: requestModel.toJson(),
      options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final responseModel =
          GetGroupAttendanceResponseModel.fromJson(response.data);

      return responseModel;
    } else {
      throw Exception(response.statusMessage);
    }
  }

  @override
  Future<List<AttendanceResponseModel>> getMonthAttendance(
      GetMonthAttendanceRequestModel requestModel) async {
    final accessToken = await pref.getAccessToken();
    final response = await dio.get(
      EndPoints.path_child_attendance,
      queryParameters: await requestModel.toJson(),
      options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      List<dynamic> attendanceList = response.data ?? [];
      List<AttendanceResponseModel> responseModel = attendanceList
          .map((json) => AttendanceResponseModel.fromJson(json))
          .toList();

      return responseModel;
    } else {
      throw Exception(response.statusMessage);
    }
  }

  @override
  Future<List<GetStoriesResponseModel>> getStories(
      GetStoriesRequestModel requestModel) async {
    final response = await dio.get(
      EndPoints.path_stories,
      queryParameters: requestModel.toJson(),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      List<dynamic> storiesList = response.data ?? [];
      List<GetStoriesResponseModel> responseModel = storiesList
          .map((json) => GetStoriesResponseModel.fromJson(json))
          .toList();

      return responseModel;
    } else {
      throw Exception(response.statusMessage);
    }
  }
}
