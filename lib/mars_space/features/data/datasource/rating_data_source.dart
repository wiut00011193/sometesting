import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'package:mars_it_app/mars_space/core/local_db/shared_pref.dart';
import 'package:mars_it_app/mars_space/core/utils/constants.dart';
import 'package:mars_it_app/mars_space/features/data/model/response/get_ratings_response_model.dart';

abstract class RatingDataSource {
  Future<GetRatingsResponseModel> getRatings();
}

class RatingDataSourceImpl extends RatingDataSource {
  final Dio dio;
  final MySharedPref pref;

  RatingDataSourceImpl({
    required this.dio,
    required this.pref,
  });

  @override
  Future<GetRatingsResponseModel> getRatings() async {
    final datetimeString = await dio.get(EndPoints.path_get_datetime);
    DateTime datetime = DateFormat("yyyy-MM-ddTHH:mm:ss.SSSSSSZ")
        .parse(datetimeString.toString());
    int difference = datetime.weekday - DateTime.monday;
    DateTime fromDateTime = datetime.subtract(Duration(days: difference));
    DateTime tillDateTime = fromDateTime.add(const Duration(days: 6));
    final fromDateYear = fromDateTime.year.toString();
    final fromDateMonth =
        '${fromDateTime.month >= 10 ? fromDateTime.month : '0${fromDateTime.month}'}';
    final fromDateDay =
        '${fromDateTime.day >= 10 ? fromDateTime.day : '0${fromDateTime.day}'}';
    final tillDateYear = tillDateTime.year.toString();
    final tillDateMonth =
        '${tillDateTime.month >= 10 ? tillDateTime.month : '0${tillDateTime.month}'}';
    final tillDateDay =
        '${tillDateTime.day >= 10 ? tillDateTime.day : '0${tillDateTime.day}'}';
    final fromDate = '$fromDateYear-$fromDateMonth-$fromDateDay';
    final tillDate = '$tillDateYear-$tillDateMonth-$tillDateDay';

    final accessToken = await pref.getAccessToken();

    final response = await dio.get(
      EndPoints.path_get_ratings,
      queryParameters: {
        'filter': 2,
        'from_date': fromDate,
        'till_date': tillDate,
      },
      options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final responseModel = GetRatingsResponseModel.fromJson(response.data);
      
      return responseModel;
    } else {
      throw Exception(response.statusMessage);
    }
  }
}
