//flutter
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

//plugins
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';

class MyTheme{
  //set changes on theme
  //Color.fromRGBO(255, 255, 255, 1); //O always set to 1
  //Color.fromARGB(255, 255, 255, 255); //A always set to 255
  //Color(0xAARRGGBB) //with a hex code //AA is always FF
  //setup for light theme
  static ThemeData dark = ThemeData.dark();
  static ThemeData light = ThemeData.light();
}

class ThemeChanger with ChangeNotifier {
  ThemeData _themeData;

  //constructor
  ThemeChanger(ThemeData initialThemeData){
    this._themeData = initialThemeData;
    updateSystemUI();
  }

  updateSystemUI() async{
    bool isDark = (_themeData == MyTheme.dark);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor: (isDark) ? Colors.black : Colors.white,
      statusBarColor: (isDark) ? Colors.black : Colors.white,
      systemNavigationBarDividerColor: (isDark) ? Colors.black : Colors.white,
      statusBarBrightness: (isDark) ? Brightness.light : Brightness.dark,
      statusBarIconBrightness: (isDark) ? Brightness.light : Brightness.dark,
      systemNavigationBarIconBrightness: (isDark) ? Brightness.light : Brightness.dark,
    ));
  }

  //getter
  ThemeData getTheme() => _themeData;

  //setter
  setTheme(ThemeData theme)async{
    //change it locally
    _themeData = theme;
    notifyListeners();

    //update status and navigation bar
    updateSystemUI();

    //update it permanently
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(
      "darkMode", 
      (theme.brightness == Brightness.dark),
    );
  }
}

//-----Theme Changer Widget
void showThemeSwitcher(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      ThemeChanger _themeChanger = Provider.of<ThemeChanger>(context);
      return SimpleDialog(
        title: const Text('Select Theme'),
        children: <Widget>[
          RadioListTile<Brightness>(
            value: Brightness.light,
            groupValue: Theme.of(context).brightness,
            onChanged: (Brightness value) {
              if(value == Brightness.light){
                _themeChanger.setTheme(MyTheme.light);
              }
            },
            title: const Text('Light'),
          ),
          RadioListTile<Brightness>(
            value: Brightness.dark,
            groupValue: Theme.of(context).brightness,
            onChanged: (Brightness value) {
              if(value == Brightness.dark){
                _themeChanger.setTheme(MyTheme.dark);
              }
            },
            title: const Text('Dark'),
          ),
        ],
      );
    },
  );
}