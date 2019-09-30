//flutter
import 'package:flutter/material.dart';

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
    Color backgroundColor = (isDark) ? Colors.black : Colors.white;

    //change the status bar color
    await FlutterStatusbarcolor.setStatusBarColor(
      backgroundColor,
    );

    //change the status text color
    await FlutterStatusbarcolor.setStatusBarWhiteForeground(isDark);

    //change the navigation bar color
    await FlutterStatusbarcolor.setNavigationBarColor(
      backgroundColor,
    );

    //change the navigation text color
    FlutterStatusbarcolor.setNavigationBarWhiteForeground(isDark);
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

/*
class Test with with WidgetsBindingObserver{

@override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);
    //sometimes needed, sometimes not - depends on what you are showing
    onResumeMethods.onResumeMethods();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    onResumeMethods.onResumeMethods();
    super.dispose();
  }


  onResumeMethods() {
    _setFulscreen();
    changeStatusAndNavigationBarColor();
  }


changeStatusAndNavigationBarColor(AppTheme theme) {

    FlutterStatusbarcolor.setStatusBarColor(theme.data.scaffoldBackgroundColor);
    FlutterStatusbarcolor.setNavigationBarColor(
        theme.data.scaffoldBackgroundColor);

    if (theme == kLightGalleryTheme) {
      FlutterStatusbarcolor.setStatusBarWhiteForeground(false);
      FlutterStatusbarcolor.setNavigationBarWhiteForeground(false);
      return;
    }

    FlutterStatusbarcolor.setStatusBarWhiteForeground(true);
    FlutterStatusbarcolor.setNavigationBarWhiteForeground(true);
  }

  _setFulscreen() {
    var pref = Preferences.getBool(PreferencesNames.PREFERENCES_UI_FULLSCREEEN);

    if (pref ?? false)
      SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
    else
      SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
  }
*/

/*
SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
          statusBarColor: Colors.white,
          statusBarIconBrightness: Brightness.dark),
    );
*/

/*
sized: false to override the child annotated region created by the app bar.

Somewhere, perhaps as a child of the scaffold:

Scaffold(
  body: AnnotatedRegion<SystemUiOverlayStyle>(
    value: const SystemUiOverlayStyle(...),
    sized: false,
    child: ...
  )
);
*/

//https://stackoverflow.com/questions/51012360/flutter-system-navigation-bar-and-status-bar-color
//http://codenextgen.com/changing-the-color-of-status-bar-in-the-flutter/