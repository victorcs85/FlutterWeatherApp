import 'package:flutter_weather_app/api/weather_api.dart';
import 'package:flutter_weather_app/models/forecast.dart';

class ForecastService {
  final WeatherApi weatherApi;

  ForecastService({this.weatherApi});

  Future<Forecast> getWeather(String city) async {
    final location = await weatherApi.getLocation(city);
    return await weatherApi.getWeather(location);
  }
}
