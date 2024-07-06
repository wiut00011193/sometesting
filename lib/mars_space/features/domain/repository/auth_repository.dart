import 'package:dartz/dartz.dart';
import 'package:mars_it_app/mars_space/features/data/model/request/add_child_request_model.dart';
import 'package:mars_it_app/mars_space/features/data/model/request/search_student_request_model.dart';
import 'package:mars_it_app/mars_space/features/domain/entity/request/login_request_entity.dart';
import 'package:mars_it_app/mars_space/features/domain/entity/request/send_verification_code_request_entity.dart';
import 'package:mars_it_app/mars_space/features/domain/entity/request/signup_request_entity.dart';
import 'package:mars_it_app/mars_space/features/domain/entity/request/verify_phone_number_request_entity.dart';
import 'package:mars_it_app/mars_space/features/domain/entity/response/add_child_response_entity.dart';
import 'package:mars_it_app/mars_space/features/domain/entity/response/get_children_response_entity.dart';
import 'package:mars_it_app/mars_space/features/domain/entity/response/login_response_entity.dart';
import 'package:mars_it_app/mars_space/features/domain/entity/response/search_student_response_entity.dart';
import 'package:mars_it_app/mars_space/features/domain/entity/response/verify_phone_number_response_entity.dart';

import '../../../core/error/failures.dart';
import '../../data/model/request/get_profile_request_model.dart';
import '../entity/response/get_profile_response_entity.dart';
import '../entity/response/signup_response_entity.dart';

abstract class AuthRepository {
  Future<Either<Failure, LoginResponseEntity>> login(
      LoginRequestEntity request);

  Future<Either<Failure, SignUpResponseEntity>> signup(
      SignUpRequestEntity request);

  Future<Either<Failure, bool>> checkUserExists(LoginRequestEntity request);

  Future<Either<Failure, void>> sendVerificationCode(
      SendVerificationCodeRequestEntity request);

  Future<Either<Failure, VerifyPhoneNumberResponseEntity>> verifyPhoneNumber(
      VerifyPhoneNumberRequestEntity request);

  Future<Either<Failure, void>> updateToken();

  Future<Either<Failure, AddChildResponseEntity>> addChild(
      AddChildRequestModel request);

  Future<Either<Failure, List<GetChildrenResponseEntity>>> getChildren();

  Future<Either<Failure, GetProfileResponseEntity>> getProfile(
      GetProfileRequestModel request);

  Future<Either<Failure, List<SearchStudentResponseEntity>>> searchStudent(
      SearchStudentRequestModel request);
}
