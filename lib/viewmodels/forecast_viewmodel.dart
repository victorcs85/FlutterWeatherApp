import 'dart:core';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

import 'package:flutter_weather_app/api/open_weather_map_weather_api.dart';

import 'package:flutter_weather_app/models/forecast.dart';
import 'package:flutter_weather_app/models/weather.dart';

import 'package:flutter_weather_app/services/forecast_service.dart';

import 'package:flutter_weather_app/utils/strings.dart';
import 'package:flutter_weather_app/utils/temperature_convert.dart';

class ForecastViewModel with ChangeNotifier {
  bool isRequestPending = false;
  bool isWeatherLoaded = false;
  bool isRequestError = false;

  bool _isDayTime;

  WeatherCondition _condition;

  String _description;
  String _city;

  double _minTemp;
  double _maxTemp;
  double _temp;
  double _feelsLike;
  double _latitude;
  double _longitude;

  int _locationId;

  DateTime _lastUpdated;

  List<Weather> _daily;

  WeatherCondition get condition => _condition;
  String get description => _description;
  String get city => _city;
  double get minTemp => _minTemp;
  double get maxTemp => _maxTemp;
  double get temp => _temp;
  double get feelsLike => _feelsLike;
  double get longitude => _longitude;
  double get latitude => _latitude;
  int get locationId => _locationId;
  DateTime get lastUpdated => _lastUpdated;
  bool get isDaytime => _isDayTime;
  List<Weather> get daily => _daily;

  ForecastService forecastService;

  ForecastViewModel() {
    forecastService = ForecastService(weatherApi: OpenWeatherMapWeatherApi());
  }

  Future<Forecast> getLatestWeather(String city) async {
    setRequestPendingState(true);
    this.isRequestError = false;

    Forecast latest;
    try {
      await Future.delayed(Duration(seconds: 1), () => {});

      latest = await forecastService.getWeather(city)
      .catchError((onError) => this.isRequestError = true);
    } catch (e) {
      this.isRequestError = true;
    }

    this.isWeatherLoaded = true;
    updateModel(latest, city);
    setRequestPendingState(false);
    notifyListeners();
    return latest;
  }

  void setRequestPendingState(bool isPending) {
    this.isRequestPending = isPending;
    notifyListeners();
  }

  void updateModel(Forecast forecast, String city) {
    if(isRequestError) return;

    _condition = forecast.current.condition;
    _city = toTitleCase(forecast.city);
    _description = toTitleCase(forecast.current.description);
    _lastUpdated = forecast.lastUpdated;
    _temp = TemperatureConvert.kelvinToCelsius(forecast.current.temp);
    _feelsLike = TemperatureConvert.kelvinToCelsius(forecast.current.feelLikeTemp);
    _longitude = forecast.longitude;
    _latitude = forecast.latitude;
    _daily = forecast.daily;
    _isDayTime = forecast.isDayTime;
  }

}