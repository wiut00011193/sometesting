import 'package:flutter/material.dart';
import 'package:mars_it_app/mars_space/features/presentation/screen/main/pages/rating/rating_screen.dart';

import '../../features/presentation/screen/main/pages/home/home_screen.dart';
import '../../features/presentation/screen/main/pages/learning/learning_screen.dart';
import '../../features/presentation/screen/main/pages/profile/profile_screen.dart';

class EndPoints {
  static const base_url = "https://test.api.marsit.uz/api/v1/";
  static const media_base_url = "https://test.lab.marsit.uz/media/";

  static const path_get_datetime = "https://test.api.marsit.uz/now/datetime";

  static const path_signin = 'auth/signin';
  static const path_signup = 'auth/signup';
  static const path_send_verification_code = 'https://test.api.marsit.uz/api/v2/auth/send_code';
  static const path_verify_phone_number = 'https://test.api.marsit.uz/api/v2/auth/verify_phone_number';

  static const path_update_token = 'auth/token';

  static const path_get_student = 'student';
  static const path_get_profile = 'me/students/fellow/profile';
  static const path_search_student = 'student/search';

  static const path_stories = 'news';

  static const path_get_ratings = 'coins/student/ratings';
  
  static const path_add_child = 'users/parent/children';
  static const path_get_children = 'users/parent/children';
  static const path_delete_child = 'users/parent/children';

  static const path_child_balance = 'me/students/fellow/profile';
  static const path_child_attendance = 'attendance/student';
  static const path_group_attendance = 'attendance';
  static const path_child_tutor = 'course_elements/extra_lessons';

  static const path_child_exam_result = 'courses/student_exam_results';
  static const path_child_answers = 'student/answers';
  static const path_child_courses_all = 'courses/all';

  static const path_child_extra_lessons = 'course_elements/extra_lessons';
  static const path_get_tutors = 'users';
  static const path_get_user_slots = 'users/user_slots';
  static const path_book_extra_lesson = 'https://test.api.marsit.uz/api/v2/courses/extra_lessons';
}

class Roles {
  static const tutor_role_id = 9;
  static const parent_role_id = 10;
}

const pages = <Widget>[
  HomeScreen(),
  LearningScreen(),
  RatingScreen(),
  ProfileScreen(),
];
