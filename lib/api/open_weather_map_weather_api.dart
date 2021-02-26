import 'dart:convert';
import 'dart:io';
import 'package:flutter_weather_app/utils/secret.dart';
import 'package:flutter_weather_app/utils/secret_loader.dart';
import 'package:flutter_weather_app/utils/shared_prefs_manager.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_weather_app/api/weather_api.dart';
import 'package:flutter_weather_app/models/forecast.dart';
import 'package:flutter_weather_app/models/location.dart';

class OpenWeatherMapWeatherApi extends WeatherApi {
  static const endPointUrl = 'https://api.openweathermap.org/data/2.5';
  Future<Secret> secretFuture = SecretLoader(secretPath: "assets/secrets.json").load();
  http.Client httpClient;

  OpenWeatherMapWeatherApi() {
    this.httpClient = new http.Client();
  }

  @override
  Future<Location> getLocation(String city) async {
    String defaultLocale = Platform.localeName;
    Secret secret = await secretFuture;

    final requestUrl = '$endPointUrl/weather?q=$city&lang=$defaultLocale&APPID=${secret.apikey}';
    final response = await this.httpClient.get(Uri.encodeFull(requestUrl));

    if (response.statusCode != 200) {
      final _sharedPreferences = SharedPrefsManager();
      _sharedPreferences.clearCityFromSharedPrefs();
      throw Exception(
          'An error retrieving location for city $city: ${response.statusCode}');
    }

    return Location.fromJson(jsonDecode(response.body));
  }

  @override
  Future<Forecast> getWeather(Location location) async {
    String defaultLocale = Platform.localeName;
    Secret secret = await secretFuture;

    final requestUrl =
        '$endPointUrl/onecall?lat=${location.latitude}&lon=${location.longitude}&exclude=hourly,minutely&lang=$defaultLocale&APPID=${secret.apikey}';
    final response = await this.httpClient.get(Uri.encodeFull(requestUrl));

    if (response.statusCode != 200) {
      throw Exception('error retrieving weather: ${response.statusCode}');
    }

    return Forecast.fromJson(jsonDecode(response.body));
  }
}


