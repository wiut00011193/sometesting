import 'package:dio/dio.dart';
import 'package:mars_it_app/mars_space/core/local_db/shared_pref.dart';
import 'package:mars_it_app/mars_space/core/utils/constants.dart';
import 'package:mars_it_app/mars_space/core/utils/output_utils.dart';
import 'package:mars_it_app/mars_space/features/data/model/request/add_child_request_model.dart';
import 'package:mars_it_app/mars_space/features/data/model/request/delete_child_request_model.dart';
import 'package:mars_it_app/mars_space/features/data/model/request/get_profile_request_model.dart';
import 'package:mars_it_app/mars_space/features/data/model/request/login_request_model.dart';
import 'package:mars_it_app/mars_space/features/data/model/request/search_student_request_model.dart';
import 'package:mars_it_app/mars_space/features/data/model/request/send_verification_code_request_model.dart';
import 'package:mars_it_app/mars_space/features/data/model/request/signup_request_model.dart';
import 'package:mars_it_app/mars_space/features/data/model/request/verify_phone_number_request_model.dart';
import 'package:mars_it_app/mars_space/features/data/model/response/add_child_response_model.dart';
import 'package:mars_it_app/mars_space/features/data/model/response/get_children_response_model.dart';
import 'package:mars_it_app/mars_space/features/data/model/response/get_profile_response_model.dart';
import 'package:mars_it_app/mars_space/features/data/model/response/login_response_model.dart';
import 'package:mars_it_app/mars_space/features/data/model/response/search_student_response_model.dart';
import 'package:mars_it_app/mars_space/features/data/model/response/verify_phone_number_response_model.dart';

import '../model/response/signup_response_model.dart';
import '../model/response/update_token_model.dart';

abstract class AuthDataSource {
  Future<LoginResponseModel> login(LoginRequestModel requestModel);

  Future<SignUpResponseModel> signup(SignUpRequestModel requestModel);

  Future<bool> checkUserExists(LoginRequestModel requestModel);

  Future<void> sendVerificationCode(
      SendVerificationCodeRequestModel requestModel);

  Future<VerifyPhoneNumberResponseModel> verifyPhoneNumber(
      VerifyPhoneNumberRequestModel requestModel);

  Future<void> updateToken();

  Future<AddChildResponseModel> addChild(AddChildRequestModel requestModel);

  Future<List<GetChildrenResponseModel>> getChildren();
  
  Future<void> deleteChild(DeleteChildRequestModel requestModel);

  Future<GetProfileResponseModel> getProfile(
      GetProfileRequestModel requestModel);

  Future<List<SearchStudentResponseModel>> searchStudent(
      SearchStudentRequestModel requestModel);
}

class AuthDataSourceImpl implements AuthDataSource {
  final Dio dio;
  final MySharedPref pref;

  const AuthDataSourceImpl({required this.dio, required this.pref});

  @override
  Future<LoginResponseModel> login(LoginRequestModel requestModel) async {
    final response = await dio.post(
      EndPoints.path_signin,
      data: requestModel.toJson(),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      // set tokens
      final responseModel = LoginResponseModel.fromJson(response.data);
      await pref.setRefreshToken(responseModel.refreshToken!);
      await pref.setAccessToken(responseModel.accessToken!);

      // set child
      final getChildrenResponse = await getChildren();
      await pref.setStudentId(getChildrenResponse.isNotEmpty
          ? (getChildrenResponse[0].externalId ?? 0)
          : 0);
      await pref.setStudentModmeId(getChildrenResponse.isNotEmpty
          ? (getChildrenResponse[0].id ?? 0)
          : 0);
      await pref.setBranchId(getChildrenResponse.isNotEmpty
          ? (getChildrenResponse[0].companyId ?? 0)
          : 0);

      logger(responseModel.accessToken!);

      return responseModel;
    } else {
      throw Exception(response.statusMessage);
    }
  }

  @override
  Future<SignUpResponseModel> signup(SignUpRequestModel requestModel) async {
    final response = await dio.post(
      EndPoints.path_signup,
      data: requestModel.toJson(),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final responseModel = SignUpResponseModel.fromJson(response.data);
      await pref.setRefreshToken(responseModel.refreshToken!);
      await pref.setAccessToken(responseModel.accessToken!);

      return responseModel;
    } else {
      throw Exception(response.statusMessage);
    }
  }

  @override
  Future<bool> checkUserExists(LoginRequestModel requestModel) async {
    final response = await dio.post(
      EndPoints.path_signin,
      data: requestModel.toJson(),
    );

    if (response.statusCode == 404) {
      return false;
    } else {
      return true;
    }
  }

  @override
  Future<void> sendVerificationCode(
      SendVerificationCodeRequestModel requestModel) async {
    final response = await dio.post(
      EndPoints.path_send_verification_code,
      data: requestModel.toJson(),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return;
    } else {
      throw Exception(response.statusMessage);
    }
  }

  @override
  Future<VerifyPhoneNumberResponseModel> verifyPhoneNumber(
      VerifyPhoneNumberRequestModel requestModel) async {
    final response = await dio.post(
      EndPoints.path_verify_phone_number,
      data: requestModel.toJson(),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final responseModel =
          VerifyPhoneNumberResponseModel.fromJson(response.data);
      return responseModel;
    } else {
      throw Exception(response.statusMessage);
    }
  }

  @override
  Future<void> updateToken() async {
    final refreshToken = await pref.getRefreshToken();
    final response = await dio.get(
      EndPoints.path_update_token,
      options: Options(
        headers: {'Authorization': 'Bearer $refreshToken'},
      ),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final responseModel = UpdateTokenModel.fromJson(response.data);
      await pref.setRefreshToken(responseModel.refreshToken!);
      await pref.setAccessToken(responseModel.accessToken!);
    } else {
      throw Exception(response.statusMessage);
    }
  }

  @override
  Future<AddChildResponseModel> addChild(
      AddChildRequestModel requestModel) async {
    final accessToken = await pref.getAccessToken();
    final response = await dio.post(
      EndPoints.path_add_child,
      data: requestModel.toJson(),
      options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final responseModel = AddChildResponseModel.fromJson(response.data);

      final student = await getProfile(
          GetProfileRequestModel(studentId: responseModel.studentId));
      await pref.setStudentId(student.externalId ?? 0);
      await pref.setStudentModmeId(responseModel.studentId ?? 0);
      await pref.setBranchId(student.companyId ?? -1);

      return responseModel;
    } else {
      throw Exception(response.data);
    }
  }

  @override
  Future<List<GetChildrenResponseModel>> getChildren() async {
    final accessToken = await pref.getAccessToken();
    final response = await dio.get(EndPoints.path_get_children,
        options: Options(headers: {'Authorization': 'Bearer $accessToken'}));

    if (response.statusCode == 200 || response.statusCode == 201) {
      final List<dynamic> childrenList = response.data;
      List<GetChildrenResponseModel> result = childrenList
          .map((json) => GetChildrenResponseModel.fromJson(json))
          .toList();
      return result;
    } else {
      throw Exception(response.data);
    }
  }

  @override
  Future<void> deleteChild(DeleteChildRequestModel requestModel) async {
    final accessToken = await pref.getAccessToken();

    final response = await dio.delete(
      '${EndPoints.path_delete_child}/${requestModel.id}',
      options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return;
    } else {
      throw Exception(response.statusMessage);
    }
  }

  @override
  Future<GetProfileResponseModel> getProfile(
      GetProfileRequestModel requestModel) async {
    final accessToken = await pref.getAccessToken();
    final response = await dio.get(
      EndPoints.path_get_profile,
      queryParameters: requestModel.toJson(),
      options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return GetProfileResponseModel.fromJson(response.data['profile']);
    } else {
      throw Exception(response.data);
    }
  }

  @override
  Future<List<SearchStudentResponseModel>> searchStudent(
      SearchStudentRequestModel requestModel) async {
    final accessToken = await pref.getAccessToken();
    final response = await dio.get(
      EndPoints.path_search_student,
      queryParameters: requestModel.toJson(),
      options: Options(
        headers: {'Authorization': 'Bearer $accessToken'},
      ),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final List<dynamic> studentList = response.data['students'] ?? [];

      List<SearchStudentResponseModel> searchResults = studentList
          .map((json) => SearchStudentResponseModel.fromJson(json))
          .toList();
      return searchResults;
    } else {
      throw Exception(response.data);
    }
  }
}
