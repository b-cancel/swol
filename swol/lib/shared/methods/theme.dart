//flutter
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

//plugins
import 'package:swol/shared/methods/extensions/sharedPreferences.dart';

//my own definition of dark and light
class MyTheme{
  //set changes on theme
  //Color.fromRGBO(255, 255, 255, 1); //O always set to 1
  //Color.fromARGB(255, 255, 255, 255); //A always set to 255
  //Color(0xAARRGGBB) //with a hex code //AA is always FF
  //setup for light theme
  static ThemeData dark = ThemeData.dark().copyWith(
    accentColor: ThemeData.light().accentColor,
  );
  static ThemeData light = ThemeData.light();
}

//NOTE: not technically just a bunch of functions because we are creating an instance
//but we only have ONE instance so we treat it as such
class ThemeChanger with ChangeNotifier {
  //NOTE: theme only for when app is loading
  static SystemUiOverlayStyle allBlackStyle = SystemUiOverlayStyle(
    systemNavigationBarColor: Colors.black,
    statusBarColor: Colors.black,
    systemNavigationBarDividerColor: Colors.black,
    statusBarBrightness: Brightness.dark,
    statusBarIconBrightness: Brightness.dark,
    systemNavigationBarIconBrightness: Brightness.dark,
  );

  static SystemUiOverlayStyle _darkStyle = SystemUiOverlayStyle(
    systemNavigationBarColor: Colors.black,
    statusBarColor: Colors.black,
    systemNavigationBarDividerColor: Colors.black,
    statusBarBrightness: Brightness.light,
    statusBarIconBrightness: Brightness.light,
    systemNavigationBarIconBrightness: Brightness.light,
  );

  static SystemUiOverlayStyle _lightStyle = SystemUiOverlayStyle(
    systemNavigationBarColor: Colors.white,
    statusBarColor: Colors.white,
    systemNavigationBarDividerColor: Colors.white,
    statusBarBrightness: Brightness.dark,
    statusBarIconBrightness: Brightness.dark,
    systemNavigationBarIconBrightness: Brightness.dark,
  );

  //-------------------------Updaters-------------------------

  //app theme updater
  updateAppUI(ThemeData theme, {shouldNotify: false}){
    _themeData = theme;
    if(shouldNotify) notifyListeners();
  }

  //system theme updater
  updateSystemUI() async{
    //switch app theme UI
    bool isDark = (_themeData == MyTheme.dark);

    //switch system theme UI
    SystemChrome.setSystemUIOverlayStyle(
      isDark ? _darkStyle : _lightStyle,
    );
  }

  //-------------------------Other-------------------------

  //the current selected theme data
  ThemeData _themeData;

  //constructor(called after reading system prefs)
  ThemeChanger(ThemeData initialThemeData){
    setTheme(initialThemeData, updatePrefs: false);
  }

  //getter
  ThemeData getTheme() => _themeData;

  //setter
  setTheme(ThemeData newThemeData, {bool updatePrefs: true}){
    updateAppUI(newThemeData, shouldNotify: updatePrefs); //update app
    updateSystemUI(); //update status and nav bar
    if(updatePrefs){ //update shared preferences
      SharedPrefsExt.setIsDark((newThemeData.brightness == Brightness.dark));
    }
  }
}