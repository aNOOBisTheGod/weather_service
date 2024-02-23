import 'package:dio/dio.dart';
import './token.dart';

class Geocoder {
  final _apiKey = token;

  final dio = Dio();

  Future<String?> decodeLocationRussian(String locationName) async {
    Response response;

    response = await dio
        .get('https://api.openweathermap.org/geo/1.0/direct', queryParameters: {
      'q': locationName,
      'limit': '5',
      'appid': _apiKey,
    });
    return response.data[0]['local_names']['ru'];
  }
}
