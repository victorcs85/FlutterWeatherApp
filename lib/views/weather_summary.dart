import 'package:flutter/material.dart';
import 'package:flutter_weather_app/models/weather.dart';
import 'package:flutter_svg/flutter_svg.dart';

class WeatherSummary extends StatelessWidget {
  final WeatherCondition condition;

  final double temp;
  final double feelsLike;
  final bool isDayTime;

  WeatherSummary({
    Key key,
    @required this.condition,
    @required this.temp,
    @required this.feelsLike,
    @required this.isDayTime
   }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
        Column(
          children: [
            Text(
              '${_formatTemperature(this.temp)}°ᶜ',
              style: TextStyle(
                fontSize: 50,
                color: Colors.white,
                fontWeight: FontWeight.w300,
              ),
            ),
            Text(
              'Feels like ${_formatTemperature(this.feelsLike)}°ᶜ',
              style: TextStyle(
                fontSize: 18,
                color: Colors.white,
                fontWeight: FontWeight.w300,
              ),
            ),
          ],
        ),
        _mapWeatherConditionToImage(this.condition, this.isDayTime),
      ]),
    );
  }

  String _formatTemperature(double t) {
    var temp = (t == null ? '' : t.round().toString());
    return temp;
  }

  Widget _mapWeatherConditionToImage(
      WeatherCondition condition, bool isDayTime) {
    // Image image;
    Widget image;
    double widthHeight = 160;
    switch (condition) {
      case WeatherCondition.thunderstorm:
        // image = Image.asset('assets/images/thunder_storm.png');
        image = SvgPicture.asset(
          'assets/images/thunder.svg', width: widthHeight, height: widthHeight, semanticsLabel: 'It`s thunderstorm!'
        );
        break;
      case WeatherCondition.heavyCloud:
        // image = Image.asset('assets/images/cloudy.png');
        image = SvgPicture.asset(
            'assets/images/overcast.svg', width: widthHeight, height: widthHeight, semanticsLabel: 'It`s cloudy!'
        );
        break;
      case WeatherCondition.lightCloud:
        // isDayTime
        //     ? image = Image.asset('assets/images/light_cloud.png')
        //     : image = Image.asset('assets/images/light_cloud-night.png');
        String path = 'assets/images/cloudy.svg';
        isDayTime ? path = path : path = 'assets/images/cloudy_night.svg';
        image = SvgPicture.asset(
            path, width: widthHeight, height: widthHeight, semanticsLabel: 'It`s light cloud!'
        );
        break;
      case WeatherCondition.drizzle:
      case WeatherCondition.mist:
        // image = Image.asset('assets/images/drizzle.png');
        image = SvgPicture.asset(
          'assets/images/mist.svg', width: widthHeight, height: widthHeight, semanticsLabel: 'It`s mist!'
      );
        break;
      case WeatherCondition.clear:
        // isDayTime
        //     ? image = Image.asset('assets/images/clear.png')
        //     : image = Image.asset('assets/images/clear-night.png');
        String path = 'assets/images/sunny.svg';
        isDayTime ? path = path : path = 'assets/images/clear_night.svg';
        image = SvgPicture.asset(
            path, width: widthHeight, height: widthHeight, semanticsLabel: 'It`s clear!'
        );
        break;
      case WeatherCondition.fog:
        // image = Image.asset('assets/images/fog.png');
        image = SvgPicture.asset(
            'assets/images/fog.svg', width: widthHeight, height: widthHeight, semanticsLabel: 'It`s fog!'
        );
        break;
      case WeatherCondition.snow:
        // image = Image.asset('assets/images/snow.png');
        image = SvgPicture.asset(
            'assets/images/snow.svg', width: widthHeight, height: widthHeight, semanticsLabel: 'It`s snow!'
        );
        break;
      case WeatherCondition.rain:
        // image = Image.asset('assets/images/rain.png');
        image = SvgPicture.asset(
            'assets/images/heavy_rain.svg', width: widthHeight, height: widthHeight, semanticsLabel: 'It`s rain!'
        );
        break;
      case WeatherCondition.atmosphere:
        // image = Image.asset('assets/images/fog.png');
        image = SvgPicture.asset(
            'assets/images/pressure.svg', width: widthHeight, height: widthHeight
        );
        break;

      default:
        // image = Image.asset('assets/images/unknown.png');
        image = SvgPicture.asset(
            'assets/images/unknown.svg', width: widthHeight, height: widthHeight
        );
    }

    return Padding(padding: const EdgeInsets.only(top: 5), child: image);
  }
}