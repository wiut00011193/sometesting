import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:mars_it_app/mars_space/core/local_db/shared_pref.dart';

import '../../features/data/datasource/auth_data_source.dart';

class AuthInterceptor extends Interceptor {
  final Dio dio;
  final MySharedPref pref;
  final AuthDataSourceImpl authDataSourceImpl;

  AuthInterceptor({
    required this.dio,
    required this.pref,
    required this.authDataSourceImpl,
  });

  @override
  Future<void> onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) async {
    // List of full URLs where the interceptor should be bypassed
    const List<String> excludedFullUrls = [
      'https://test.api.marsit.uz/api/v1/auth/token',
      //'https://api.marsit.uz/api/v1/auth/token',
      // Add more full URLs as needed
    ];

    // Extract the full URL from the request
    String requestFullUrl = response.requestOptions.uri.toString();

    // Check if the request full URL matches any of the excluded full URLs
    bool shouldBypassInterceptor = excludedFullUrls.contains(requestFullUrl);

    if (shouldBypassInterceptor) {
      // If the request should bypass the interceptor, proceed as normal
      return handler.next(response);
    }

    if (response.statusCode == HttpStatus.unauthorized ||
        response.statusCode == HttpStatus.forbidden) {
      // updating token
      await authDataSourceImpl.updateToken();

      String newAccessToken = await pref.getAccessToken();

      // Update the request header with the new access token
      response.requestOptions.headers['Authorization'] =
          'Bearer $newAccessToken';

      // Repeat the request with the updated header
      return handler.resolve(await dio.fetch(response.requestOptions));
    } else {
      return super.onResponse(response, handler);
    }
  }
}
