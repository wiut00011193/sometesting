import 'package:shared_preferences/shared_preferences.dart';

class MySharedPref {
  SharedPreferences? _prefs;

  static const THEME_STATUS = "THEMESTATUS";
  static const IS_FIRST = "isFirst";
  static const ACCESS_TOKEN = "access_token";
  static const REFRESH_TOKEN = "refresh_token";
  static const STUDENT_ID = "student_id";
  static const STUDENT_MODME_ID = "student_modme_id";
  static const BRANCH_ID = "branch_id";

  Future _initSharedPref() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  Future setDarkTheme(bool value) async {
    await _initSharedPref();
    await _prefs?.setBool(THEME_STATUS, value);
  }

  Future<bool> getDarkTheme() async {
    await _initSharedPref();
    return _prefs?.getBool(THEME_STATUS) ?? false;
  }

  Future setBranchId(int id) async {
    await _initSharedPref();
    await _prefs?.setInt(BRANCH_ID, id);
  }

  Future<int> getBranchId() async {
    await _initSharedPref();
    return _prefs?.getInt(BRANCH_ID) ?? 0;
  }

  Future setStudentId(int id) async {
    await _initSharedPref();
    await _prefs?.setInt(STUDENT_ID, id);
  }

  Future<int> getStudentId() async {
    await _initSharedPref();
    return _prefs?.getInt(STUDENT_ID) ?? 0;
  }

  Future setStudentModmeId(int id) async {
    await _initSharedPref();
    await _prefs?.setInt(STUDENT_MODME_ID, id);
  }

  Future<int> getStudentModmeId() async {
    await _initSharedPref();
    return _prefs?.getInt(STUDENT_MODME_ID) ?? 0;
  }

  Future<bool> getIsFirst() async {
    await _initSharedPref();
    return _prefs?.getBool(IS_FIRST) ?? true;
  }

  Future setIsFirst(bool value) async {
    await _initSharedPref();
    await _prefs?.setBool(IS_FIRST, value);
  }

  Future<String> getAccessToken() async {
    await _initSharedPref();
    return _prefs?.getString(ACCESS_TOKEN) ?? "";
  }

  Future setAccessToken(String value) async {
    await _initSharedPref();
    await _prefs?.setString(ACCESS_TOKEN, value);
  }

  Future<String> getRefreshToken() async {
    await _initSharedPref();
    return _prefs?.getString(REFRESH_TOKEN) ?? "";
  }

  Future setRefreshToken(String value) async {
    await _initSharedPref();
    await _prefs?.setString(REFRESH_TOKEN, value);
  }
}
