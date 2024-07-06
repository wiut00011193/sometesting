import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'package:mars_it_app/mars_space/core/local_db/shared_pref.dart';
import 'package:mars_it_app/mars_space/core/utils/constants.dart';
import 'package:mars_it_app/mars_space/features/data/model/request/add_extra_lesson_request_model.dart';
import 'package:mars_it_app/mars_space/features/data/model/request/get_user_slots_request_model.dart';
import 'package:mars_it_app/mars_space/features/data/model/response/get_extra_lessons_response_model.dart';
import 'package:mars_it_app/mars_space/features/data/model/response/get_tutors_response_model.dart';
import 'package:mars_it_app/mars_space/features/data/model/response/get_user_slots_response_model.dart';

abstract class BookingDataSource {
  Future<List<GetExtraLessonsResponseModel>> getExtraLessons();
  Future<List<GetTutorsResponseModel>> getTutors();
  Future<List<GetUserSlotsResponseModel>> getUserSlots(
      GetUserSlotsRequestModel requestModel);
  Future<void> bookExtraLesson(AddExtraLessonRequestModel requestModel);
}

class BookingDataSourceImpl implements BookingDataSource {
  final Dio dio;
  final MySharedPref pref;

  const BookingDataSourceImpl({required this.dio, required this.pref});

  @override
  Future<List<GetExtraLessonsResponseModel>> getExtraLessons() async {
    final accessToken = await pref.getAccessToken();
    final studentId = await pref.getStudentModmeId();
    final datetimeString = await dio.get(EndPoints.path_get_datetime);
    DateTime fromDate = DateFormat("yyyy-MM-ddTHH:mm:ss.SSSSSSZ")
        .parse(datetimeString.toString());
    DateTime tillDate = fromDate.add(const Duration(days: 7));

    String fromDateString = DateFormat('yyyy-MM-dd').format(fromDate);
    String tillDateString = DateFormat('yyyy-MM-dd').format(tillDate);

    final response = await dio.get(
      EndPoints.path_child_extra_lessons,
      queryParameters: {
        'from_date': fromDateString,
        'till_date': tillDateString,
        'student_id': studentId,
      },
      options: Options(
        headers: {'Authorization': 'Bearer $accessToken'},
      ),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      List<dynamic> extraLessonsList = response.data ?? [];
      final responseModel = List<GetExtraLessonsResponseModel>.from(
          extraLessonsList
              .map((x) => GetExtraLessonsResponseModel.fromJson(x)));

      return responseModel;
    } else {
      throw Exception(response.statusMessage);
    }
  }

  @override
  Future<List<GetTutorsResponseModel>> getTutors() async {
    final branchId = await pref.getBranchId();
    final accessToken = await pref.getAccessToken();

    final response = await dio.get(
      EndPoints.path_get_tutors,
      queryParameters: {
        'role': 'tutor',
        'branch_id': branchId,
      },
      options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      List<dynamic> attendanceList = response.data ?? [];
      List<GetTutorsResponseModel> responseModel = attendanceList
          .map((json) => GetTutorsResponseModel.fromJson(json))
          .toList();

      return responseModel;
    } else {
      throw Exception(response.statusMessage);
    }
  }

  @override
  Future<List<GetUserSlotsResponseModel>> getUserSlots(
      GetUserSlotsRequestModel requestModel) async {
    final accessToken = await pref.getAccessToken();

    final response = await dio.get(
      EndPoints.path_get_user_slots,
      queryParameters: requestModel.toJson(),
      options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      List<dynamic> attendanceList = response.data ?? [];
      List<GetUserSlotsResponseModel> responseModel = attendanceList
          .map((json) => GetUserSlotsResponseModel.fromJson(json))
          .toList();

      return responseModel;
    } else {
      throw Exception(response.statusMessage);
    }
  }

  @override
  Future<void> bookExtraLesson(AddExtraLessonRequestModel requestModel) async {
    final accessToken = await pref.getAccessToken();

    final response = await dio.post(
      EndPoints.path_book_extra_lesson,
      data: await requestModel.toJson(),
      options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return;
    } else {
      throw Exception(response.statusMessage);
    }
  }
}
