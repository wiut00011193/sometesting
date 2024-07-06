import 'package:dartz/dartz.dart';

import 'package:mars_it_app/mars_space/core/error/failures.dart';
import 'package:mars_it_app/mars_space/features/data/model/request/get_profile_request_model.dart';
import 'package:mars_it_app/mars_space/features/data/model/request/search_student_request_model.dart';
import 'package:mars_it_app/mars_space/features/domain/entity/request/login_request_entity.dart';
import 'package:mars_it_app/mars_space/features/domain/entity/request/send_verification_code_request_entity.dart';
import 'package:mars_it_app/mars_space/features/domain/entity/request/signup_request_entity.dart';
import 'package:mars_it_app/mars_space/features/domain/entity/request/verify_phone_number_request_entity.dart';
import 'package:mars_it_app/mars_space/features/domain/entity/response/get_profile_response_entity.dart';

import 'package:mars_it_app/mars_space/features/domain/entity/response/login_response_entity.dart';
import 'package:mars_it_app/mars_space/features/domain/entity/response/search_student_response_entity.dart';
import 'package:mars_it_app/mars_space/features/domain/entity/response/verify_phone_number_response_entity.dart';

import '../../domain/entity/response/add_child_response_entity.dart';
import '../../domain/entity/response/get_children_response_entity.dart';
import '../../domain/entity/response/signup_response_entity.dart';
import '../../domain/repository/auth_repository.dart';
import '../datasource/auth_data_source.dart';
import '../model/request/add_child_request_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthDataSourceImpl authDataSource;

  AuthRepositoryImpl({required this.authDataSource});

  @override
  Future<Either<Failure, LoginResponseEntity>> login(
      LoginRequestEntity request) async {
    try {
      final requestModel = await request.toModel();
      final remote = await authDataSource.login(requestModel);
      return Right(remote);
    } catch (e) {
      return Left(Failure(errorMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, SignUpResponseEntity>> signup(
      SignUpRequestEntity request) async {
    try {
      final requestModel = await request.toModel();
      final remote = await authDataSource.signup(requestModel);
      return Right(remote);
    } catch (e) {
      return Left(Failure(errorMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> checkUserExists(LoginRequestEntity request) async {
    try {
      final requestModel = await request.toModel();
      final remote = await authDataSource.checkUserExists(requestModel);
      return Right(remote);
    } catch (e) {
      return Left(Failure(errorMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> sendVerificationCode(
      SendVerificationCodeRequestEntity request) async {
    try {
      final requestModel = await request.toModel();
      final remote = await authDataSource.sendVerificationCode(requestModel);
      return Right(remote);
    } catch (e) {
      return Left(Failure(errorMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, VerifyPhoneNumberResponseEntity>> verifyPhoneNumber(
      VerifyPhoneNumberRequestEntity request) async {
    try {
      final requestModel = await request.toModel();
      final remote = await authDataSource.verifyPhoneNumber(requestModel);
      return Right(remote);
    } catch (e) {
      return Left(Failure(errorMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateToken() async {
    try {
      final remote = await authDataSource.updateToken();
      return Right(remote);
    } catch (e) {
      return Left(Failure(errorMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, AddChildResponseEntity>> addChild(
      AddChildRequestModel request) async {
    try {
      final remote = await authDataSource.addChild(request);
      return Right(remote);
    } catch (e) {
      return Left(Failure(errorMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<GetChildrenResponseEntity>>> getChildren() async {
    try {
      final remote = await authDataSource.getChildren();
      return Right(remote);
    } catch (e) {
      return Left(Failure(errorMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, GetProfileResponseEntity>> getProfile(
      GetProfileRequestModel request) async {
    try {
      final remote = await authDataSource.getProfile(request);
      return Right(remote);
    } catch (e) {
      return Left(Failure(errorMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<SearchStudentResponseEntity>>> searchStudent(
      SearchStudentRequestModel request) async {
    try {
      final remote = await authDataSource.searchStudent(request);
      return Right(remote);
    } catch (e) {
      return Left(Failure(errorMessage: e.toString()));
    }
  }
}
