import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:mars_it_app/mars_space/core/network/auth_interceptor.dart';
import 'package:mars_it_app/mars_space/features/data/datasource/booking_data_source.dart';
import 'package:mars_it_app/mars_space/features/data/datasource/home_data_source.dart';
import 'package:mars_it_app/mars_space/features/data/datasource/learning_data_source.dart';
import 'package:mars_it_app/mars_space/features/data/datasource/rating_data_source.dart';
import 'package:mars_it_app/mars_space/features/data/repository/booking_repository_impl.dart';
import 'package:mars_it_app/mars_space/features/data/repository/home_repository_impl.dart';
import 'package:mars_it_app/mars_space/features/data/repository/learning_repository_impl.dart';
import 'package:mars_it_app/mars_space/features/data/repository/profile_repository_impl.dart';
import 'package:mars_it_app/mars_space/features/data/repository/rating_repository_impl.dart';
import 'package:mars_it_app/mars_space/features/domain/repository/booking_repository.dart';
import 'package:mars_it_app/mars_space/features/domain/repository/home_repository.dart';
import 'package:mars_it_app/mars_space/features/domain/repository/learning_repository.dart';
import 'package:mars_it_app/mars_space/features/domain/repository/profile_repository.dart';
import 'package:mars_it_app/mars_space/features/domain/repository/rating_repository.dart';
import 'package:mars_it_app/mars_space/features/domain/usecase/add_child_usecase.dart';
import 'package:mars_it_app/mars_space/features/domain/usecase/book_extra_lesson_usecase.dart';
import 'package:mars_it_app/mars_space/features/domain/usecase/check_user_exists_usecase.dart';
import 'package:mars_it_app/mars_space/features/domain/usecase/child_attendance_usecase.dart';
import 'package:mars_it_app/mars_space/features/domain/usecase/child_balance_usecase.dart';
import 'package:mars_it_app/mars_space/features/domain/usecase/delete_child_usecase.dart';
import 'package:mars_it_app/mars_space/features/domain/usecase/get_children_usecase.dart';
import 'package:mars_it_app/mars_space/features/domain/usecase/get_course_element_usecase.dart';
import 'package:mars_it_app/mars_space/features/domain/usecase/get_course_elements_usecase.dart';
import 'package:mars_it_app/mars_space/features/domain/usecase/get_course_modules_usecase.dart';
import 'package:mars_it_app/mars_space/features/domain/usecase/get_exam_result_usecase.dart';
import 'package:mars_it_app/mars_space/features/domain/usecase/get_extra_lessons_usecase.dart';
import 'package:mars_it_app/mars_space/features/domain/usecase/get_group_attendance_usecase.dart';
import 'package:mars_it_app/mars_space/features/domain/usecase/get_month_attendance_usecase.dart';
import 'package:mars_it_app/mars_space/features/domain/usecase/get_profile_usecase.dart';
import 'package:mars_it_app/mars_space/features/domain/usecase/get_ratings_usecase.dart';
import 'package:mars_it_app/mars_space/features/domain/usecase/get_stories_usecase.dart';
import 'package:mars_it_app/mars_space/features/domain/usecase/get_student_usecase.dart';
import 'package:mars_it_app/mars_space/features/domain/usecase/get_tutors_usecase.dart';
import 'package:mars_it_app/mars_space/features/domain/usecase/get_user_slots_usecase.dart';
import 'package:mars_it_app/mars_space/features/domain/usecase/login_usecase.dart';
import 'package:mars_it_app/mars_space/features/domain/usecase/search_student_usecase.dart';
import 'package:mars_it_app/mars_space/features/domain/usecase/send_verification_code_usecase.dart';
import 'package:mars_it_app/mars_space/features/domain/usecase/signup_usecase.dart';
import 'package:mars_it_app/mars_space/features/domain/usecase/update_token_usecase.dart';
import 'package:mars_it_app/mars_space/features/domain/usecase/verify_phone_number_usecase.dart';
import 'package:mars_it_app/mars_space/features/presentation/screen/auth/add_child_second/bloc/add_child_second_bloc.dart';
import 'package:mars_it_app/mars_space/features/presentation/screen/auth/signup/bloc/sign_up_bloc.dart';
import 'package:mars_it_app/mars_space/features/presentation/screen/booking/bloc/booking_bloc.dart';
import 'package:mars_it_app/mars_space/features/presentation/screen/calendar/bloc/calendar_bloc.dart';
import 'package:mars_it_app/mars_space/features/presentation/screen/learning_journey/bloc/learning_journey_bloc.dart';
import 'package:mars_it_app/mars_space/features/presentation/screen/main/bloc/main_bloc.dart';
import 'package:mars_it_app/mars_space/features/presentation/screen/main/pages/rating/bloc/rating_bloc.dart';
import 'package:mars_it_app/mars_space/features/presentation/screen/notification/bloc/notification_bloc.dart';
import 'package:mars_it_app/mars_space/features/presentation/screen/splash/bloc/splash_bloc.dart';

import 'mars_space/core/local_db/shared_pref.dart';
import 'mars_space/core/network/base_api.dart';
import 'mars_space/features/data/datasource/auth_data_source.dart';
import 'mars_space/features/data/repository/auth_repository_impl.dart';
import 'mars_space/features/domain/repository/auth_repository.dart';
import 'mars_space/features/presentation/screen/auth/login/bloc/login_bloc.dart';
import 'mars_space/features/presentation/screen/main/pages/home/bloc/home_bloc.dart';
import 'mars_space/features/presentation/screen/main/pages/learning/bloc/learning_bloc.dart';
import 'mars_space/features/presentation/screen/main/pages/profile/bloc/profile_bloc.dart';

final GetIt di = GetIt.instance;

Future<void> setupDI() async {
  // BaseApi
  di.registerLazySingleton<BaseApi>(() => BaseApi());

  //Dio
  di.registerLazySingleton<Dio>(() => di.get<BaseApi>().dio);

  // AuthInterceptor
  di.registerLazySingleton(() => AuthInterceptor(
        dio: di(),
        pref: di(),
        authDataSourceImpl: di(),
      ));

  // Data sources
  di.registerLazySingleton(() => AuthDataSourceImpl(dio: di(), pref: di()));
  di.registerLazySingleton(() => HomeDataSourceImpl(dio: di(), pref: di()));
  di.registerLazySingleton(() => LearningDataSourceImpl(dio: di(), pref: di()));
  di.registerLazySingleton(() => RatingDataSourceImpl(dio: di(), pref: di()));
  di.registerLazySingleton(() => BookingDataSourceImpl(dio: di(), pref: di()));

  // Repository
  di.registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(authDataSource: di()));
  di.registerLazySingleton<HomeRepository>(
      () => HomeRepositoryImpl(homeDataSource: di()));
  di.registerLazySingleton<ProfileRepository>(
      () => ProfileRepositoryImpl(authDataSource: di()));
  di.registerLazySingleton<LearningRepository>(
      () => LearningRepositoryImpl(learningDataSource: di()));
  di.registerLazySingleton<RatingRepository>(
      () => RatingRepositoryImpl(ratingDataSource: di()));
  di.registerLazySingleton<BookingRepository>(
      () => BookingRepositoryImpl(bookingDataSource: di()));

  // UseCase
  di.registerLazySingleton(() => LoginUseCase(repository: di()));
  di.registerLazySingleton(() => SignUpUseCase(repository: di()));
  di.registerLazySingleton(() => CheckUserExistsUseCase(repository: di()));
  di.registerLazySingleton(() => UpdateTokenUseCase(repository: di()));
  di.registerLazySingleton(() => GetCourseElementsUseCase(repository: di()));
  di.registerLazySingleton(() => GetCourseElementUseCase(repository: di()));
  di.registerLazySingleton(() => GetExamResultUseCase(repository: di()));
  di.registerLazySingleton(() => AddChildUseCase(repository: di()));
  di.registerLazySingleton(() => DeleteChildUseCase(repository: di()));
  di.registerLazySingleton(() => GetChildrenUseCase(repository: di()));
  di.registerLazySingleton(() => GetStudentUseCase(repository: di()));
  di.registerLazySingleton(() => GetProfileUseCase(repository: di()));
  di.registerLazySingleton(() => SearchStudentUseCase(repository: di()));
  di.registerLazySingleton(() => GetChildBalanceUseCase(repository: di()));
  di.registerLazySingleton(() => GetChildAttendanceUseCase(repository: di()));
  di.registerLazySingleton(() => GetRatingsUseCase(repository: di()));
  di.registerLazySingleton(() => GetStoriesUseCase(repository: di()));
  di.registerLazySingleton(() => GetExtraLessonsUseCase(repository: di()));
  di.registerLazySingleton(() => BookExtraLessonUseCase(repository: di()));
  di.registerLazySingleton(() => GetTutorsUseCase(repository: di()));
  di.registerLazySingleton(() => GetUserSlotsUseCase(repository: di()));
  di.registerLazySingleton(() => SendVerificationCodeUseCase(repository: di()));
  di.registerLazySingleton(() => VerifyPhoneNumberUseCase(repository: di()));
  di.registerLazySingleton(() => GetCourseModulesUseCase(repository: di()));
  di.registerLazySingleton(() => GetMonthAttendanceUseCase(repository: di()));
  di.registerLazySingleton(() => GetGroupAttendanceUseCase(repository: di()));

  // Bloc
  di.registerLazySingleton(() => SplashBloc(
        mySharedPref: di(),
        updateTokenUseCase: di(),
      ));
  di.registerFactory<LoginBloc>(
      () => LoginBloc(loginUseCase: di(), pref: di()));
  di.registerFactory<SignUpBloc>(() => SignUpBloc(
        signUpUseCase: di(),
        checkUserExistsUseCase: di(),
        sendVerificationUseCase: di(),
        verifyPhoneNumberUseCase: di(),
      ));
  di.registerFactory<AddChildSecondBloc>(() => AddChildSecondBloc(
        addChildUseCase: di(),
        getStudentUseCase: di(),
        searchStudentUseCase: di(),
      ));
  di.registerFactory<MainBloc>(() => MainBloc());
  di.registerFactory<HomeBloc>(() => HomeBloc(
        mySharedPref: di(),
        getStoriesUseCase: di(),
        getChildAttendanceUseCase: di(),
        getChildBalanceUseCase: di(),
        getMonthAttendanceUseCase: di(),
        getExtraLessonsUseCase: di(),
        getGroupAttendanceUseCase: di(),
      ));
  di.registerFactory<LearningBloc>(() => LearningBloc(
        getStudentUseCase: di(),
        getCourseElementsUseCase: di(),
        getCourseElementUseCase: di(),
        getExamResultUseCase: di(),
        getCourseModulesUseCase: di(),
      ));
  di.registerFactory<RatingBloc>(() => RatingBloc(
        getRatingsUseCase: di(),
      ));
  di.registerFactory<ProfileBloc>(() => ProfileBloc(
        mySharedPref: di(),
        getProfileUseCase: di(),
        getChildrenUseCase: di(),
        deleteChildUseCase: di(),
      ));
  di.registerFactory<LearningJourneyBloc>(() => LearningJourneyBloc(
        getStudentUseCase: di(),
        getCourseModulesUseCase: di(),
      ));
  di.registerFactory<BookingBloc>(() => BookingBloc(
        getExtraLessonsUseCase: di(),
        getTutorsUseCase: di(),
        getUserSlotsUseCase: di(),
        bookExtraLessonUseCase: di(),
      ));
  di.registerLazySingleton(() => NotificationBloc());
  di.registerLazySingleton(() => CalendarBloc());

  // SharedPref
  di.registerLazySingleton<MySharedPref>(() => MySharedPref());
}
