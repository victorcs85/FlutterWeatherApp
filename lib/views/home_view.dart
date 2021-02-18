import 'package:flutter/material.dart';
import 'package:flutter_weather_app/app_localizations.dart';
import 'package:flutter_weather_app/models/weather.dart';
import 'package:flutter_weather_app/utils/gradient_container.dart';
import 'package:flutter_weather_app/views/last_updated_view.dart';
import 'package:provider/provider.dart';

import 'package:flutter_weather_app/viewmodels/city_entry_viewmodel.dart';
import 'package:flutter_weather_app/viewmodels/forecast_viewmodel.dart';

import 'package:flutter_weather_app/views/weather_description_view.dart';
import 'package:flutter_weather_app/views/weather_summary_view.dart';

import 'city_entry_view.dart';
import 'daily_summary_view.dart';
import 'location_view.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  void initState() {
    super.initState();

    onStart();
  }

  Future<void> onStart() async {
    // any init in here ?
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ForecastViewModel>(
      builder: (context, model, child) => Scaffold(
        body: _buildGradientContainer(
            model.condition, model.isDaytime, buildHomeView(context)),
      ),
    );
  }

  Widget buildHomeView(BuildContext context) {
    return Consumer<ForecastViewModel>(
        builder: (context, weatherViewModel, child) => Container(
            height: MediaQuery.of(context).size.height,
            child: RefreshIndicator(
                color: Colors.transparent,
                backgroundColor: Colors.transparent,
                onRefresh: () => refreshWeather(weatherViewModel, context),
                child: ListView(
                  children: <Widget>[
                    CityEntryView(),
                    weatherViewModel.isRequestPending
                        ? buildBusyIndicator(context)
                        : weatherViewModel.isRequestError
                        ? Center(
                        child: Text(AppLocalizations.of(context).translate('home_view_ops'),
                            style: TextStyle(
                                fontSize: 21, color: Colors.white)))
                        : Column(children: [
                      LocationView(
                        longitude: weatherViewModel.longitude,
                        latitude: weatherViewModel.latitude,
                        city: weatherViewModel.city,
                      ),
                      SizedBox(height: 50),
                      WeatherSummary(
                          condition: weatherViewModel.condition,
                          temp: weatherViewModel.temp,
                          feelsLike: weatherViewModel.feelsLike,
                          isDayTime: weatherViewModel.isDaytime),
                      SizedBox(height: 20),
                      WeatherDescriptionView(
                          weatherDescription:
                          weatherViewModel.description != null ? weatherViewModel.description : ""),
                      SizedBox(height: 140),
                      if(weatherViewModel.daily != null) 
                      buildDailySummary(weatherViewModel.daily),
                      if(weatherViewModel.lastUpdated != null)
                      LastUpdatedView(
                          lastUpdatedOn:
                          weatherViewModel.lastUpdated),
                    ]),
                  ],
                ))));
  }

  Widget buildBusyIndicator(BuildContext context) {
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      CircularProgressIndicator(
          valueColor: new AlwaysStoppedAnimation<Color>(Colors.white)),
      SizedBox(
        height: 20,
      ),
      Text(AppLocalizations.of(context).translate('home_view_wait'),
          style: TextStyle(
            fontSize: 18,
            color: Colors.white,
            fontWeight: FontWeight.w300,
          ))
    ]);
  }

  Widget buildDailySummary(List<Weather> dailyForecast) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: dailyForecast
            .map((item) => new DailySummaryView(
          weather: item,
        ))
            .toList());
  }

  Future<void> refreshWeather(
      ForecastViewModel weatherVM, BuildContext context) {
    // get the current city
    String city = Provider.of<CityEntryViewModel>(context, listen: false).city;
    return weatherVM.getLatestWeather(city);
  }

  GradientContainer _buildGradientContainer(
      WeatherCondition condition, bool isDayTime, Widget child) {
    GradientContainer container;

    // if night time then just default to a blue/grey
    if (isDayTime != null && !isDayTime)
      container = GradientContainer(color: Colors.blueGrey, child: child);
    else {
      switch (condition) {
        case WeatherCondition.clear:
        case WeatherCondition.lightCloud:
          container = GradientContainer(color: Colors.yellow, child: child);
          break;
        case WeatherCondition.fog:
        case WeatherCondition.atmosphere:
        case WeatherCondition.rain:
        case WeatherCondition.drizzle:
        case WeatherCondition.mist:
        case WeatherCondition.heavyCloud:
          container = GradientContainer(color: Colors.indigo, child: child);
          break;
        case WeatherCondition.snow:
          container = GradientContainer(color: Colors.lightBlue, child: child);
          break;
        case WeatherCondition.thunderstorm:
          container = GradientContainer(color: Colors.deepPurple, child: child);
          break;
        default:
          container = GradientContainer(color: Colors.lightBlue, child: child);
      }
    }

    return container;
  }
}