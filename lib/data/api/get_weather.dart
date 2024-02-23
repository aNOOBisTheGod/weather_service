import 'package:dio/dio.dart';
import './token.dart';

// класс получение погоды
class GetWeatherAPI {
  final _apiKey = token;

  final dio = Dio();

  Future<Map> getWeatherForecast(double lat, double lon) async {
    Response response;

    response = await dio.get('https://api.openweathermap.org/data/2.5/forecast',
        queryParameters: {
          'lat': lat,
          'lon': lon,
          'appid': _apiKey,
          'lang': 'ru',
          'units': 'metric'
        });
    return response.data;
  }
}
