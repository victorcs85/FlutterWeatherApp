import 'package:flutter/material.dart';
import 'package:flutter_weather_app/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:flutter_weather_app/models/weather.dart';
import 'package:flutter_weather_app/utils/temperature_convert.dart';
import 'package:flutter_svg/flutter_svg.dart';


class DailySummaryView extends StatelessWidget {
  final Weather weather;

  DailySummaryView({
    Key key, @required this.weather
}): assert(weather != null), super(key: key);

  @override
  Widget build(BuildContext context) {
    Locale currentLocale = Localizations.localeOf(context);
    final dayOfWeek = toBeginningOfSentenceCase(
      DateFormat('EEE', currentLocale.toString()).format(this.weather.date));

      return Padding(
        padding: EdgeInsets.all(15),
        child: Row(
        children: [
          Column(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
            Text(dayOfWeek ?? '',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              color: Colors.white,
              fontWeight: FontWeight.w300
            )),
            Text("${TemperatureConvert.kelvinToCelsius(this.weather.temp).round().toString()}",
            textAlign: TextAlign.center, style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.w500))
          ]),
          Padding(
              padding: EdgeInsets.only(left: 5),
              child: Container(
                  alignment: Alignment.center,
                  child: _mapWeatherConditionToImage(this.weather.condition, context)))
        ],
        ));
  }

  Widget _mapWeatherConditionToImage(WeatherCondition condition, BuildContext context) {
    // Image image;
    Widget image;
    double widthHeight = 40;
    switch (condition) {
      case WeatherCondition.thunderstorm:
        image = SvgPicture.asset(
          'assets/images/thunder.svg', width: widthHeight, height: widthHeight, semanticsLabel: 
          AppLocalizations.of(context).translate('daily_summary_view_thunder')
        );
        // image = Image.asset('assets/images/thunder_storm_small.png');
        break;
      case WeatherCondition.heavyCloud:
        // image = Image.asset('assets/images/cloudy_small.png');
        image = SvgPicture.asset(
            'assets/images/overcast.svg', width: widthHeight, height: widthHeight, semanticsLabel: 
            AppLocalizations.of(context).translate('daily_summary_view_cloudy')
        );
        break;
      case WeatherCondition.lightCloud:
        // image = Image.asset('assets/images/light_cloud_small.png');
        image = SvgPicture.asset(
            'assets/images/cloudy.svg', width: widthHeight, height: widthHeight, semanticsLabel: 
            AppLocalizations.of(context).translate('daily_summary_view_light_cloud')
        );
        break;
      case WeatherCondition.drizzle:
      case WeatherCondition.mist:
        // image = Image.asset('assets/images/drizzle_small.png');
      image = SvgPicture.asset(
          'assets/images/mist.svg', width: widthHeight, height: widthHeight, semanticsLabel:
          AppLocalizations.of(context).translate('daily_summary_view_mist')
      );
        break;
      case WeatherCondition.clear:
        // image = Image.asset('assets/images/clear_small.png');
        image = SvgPicture.asset(
            'assets/images/sunny_.svg', width: widthHeight, height: widthHeight, semanticsLabel: 
            AppLocalizations.of(context).translate('daily_summary_view_clear')
        );
        break;
      case WeatherCondition.fog:
        // image = Image.asset('assets/images/fog_small.png');
        image = SvgPicture.asset(
            'assets/images/fog.svg', width: widthHeight, height: widthHeight, semanticsLabel: 
            AppLocalizations.of(context).translate('daily_summary_view_fog')
        );
        break;
      case WeatherCondition.snow:
        // image = Image.asset('assets/images/snow_small.png');
        image = SvgPicture.asset(
            'assets/images/snow.svg', width: widthHeight, height: widthHeight, semanticsLabel: 
            AppLocalizations.of(context).translate('daily_summary_view_snow')
        );
        break;
      case WeatherCondition.rain:
        // image = Image.asset('assets/images/rain_small.png');
        image = SvgPicture.asset(
            'assets/images/heavy_rain.svg', width: widthHeight, height: widthHeight, semanticsLabel: 
            AppLocalizations.of(context).translate('daily_summary_view_rain')
        );
        break;
      case WeatherCondition.atmosphere:
        // image = Image.asset('assets/images/atmosphere_small.png');
        image = SvgPicture.asset(
            'assets/images/pressure.svg', width: widthHeight, height: widthHeight
        );
        break;

      default:
        // image = Image.asset('assets/images/light_cloud_small.png');
        image = SvgPicture.asset(
            'assets/images/cloudy.svg', width: widthHeight, height: widthHeight, semanticsLabel: 
            AppLocalizations.of(context).translate('daily_summary_view_light_cloud')
        );
    }

    return Padding(padding: const EdgeInsets.only(top: 5), child: image);
  }
}