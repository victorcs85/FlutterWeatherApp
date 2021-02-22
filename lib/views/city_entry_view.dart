import 'package:flutter/material.dart';
import 'package:flutter_weather_app/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:flutter_weather_app/viewmodels/city_entry_viewmodel.dart';
import 'package:flutter_weather_app/utils/shared_prefs_manager.dart';

class CityEntryView extends StatefulWidget {
  @override
  _CityEntryState createState() => _CityEntryState();
}

class _CityEntryState extends State<CityEntryView> {
  TextEditingController cityEditController;

  @override
  void initState() {
    super.initState();

    cityEditController = new TextEditingController();

    restoreCityFromPrefs(cityEditController) ;

    // sync the current value in text field to
    // the view model
    cityEditController.addListener(() {
      Provider.of<CityEntryViewModel>(this.context, listen: false)
          .updateCity(cityEditController.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CityEntryViewModel>(
        builder: (context, model, child) => Container(
            margin: EdgeInsets.only(left: 20, top: 20, right: 20, bottom: 50),
            padding: EdgeInsets.only(left: 5, top: 5, right: 20, bottom: 00),
            height: 50,
            width: 200,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(3),
                  topRight: Radius.circular(3),
                  bottomLeft: Radius.circular(3),
                  bottomRight: Radius.circular(3)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  spreadRadius: 3,
                  blurRadius: 5,
                  offset: Offset(0, 3), 
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                IconButton(
                  icon: new Icon(Icons.search),
                  onPressed: () {
                    model.updateCity(cityEditController.text);
                    model.refreshWeather(cityEditController.text, context);
                  },
                ),
                SizedBox(width: 10),
                Expanded(
                    child: TextField(
                        controller: cityEditController,
                        decoration:
                            InputDecoration.collapsed(hintText: 
                            AppLocalizations.of(context).translate('city_entry_view_enter')
                            ),
                        onSubmitted: (String city) =>
                            {model.refreshWeather(city, context)})),
              ],
            )));
  }

  void restoreCityFromPrefs(TextEditingController cityEditController) async {
    cityEditController.text = getCityFromSharedPrefs();
  }
}
