import 'package:flutter_weather_app/models/forecast.dart';
import 'package:flutter_weather_app/models/location.dart';

abstract class WeatherApi {
  Future<Forecast> getWeather(Location location);
  Future<Location> getLocation(String city);
}