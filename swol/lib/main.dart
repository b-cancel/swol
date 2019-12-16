//flutter
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

//plugins
import 'package:feature_discovery/feature_discovery.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:async/async.dart';

//internal
import 'package:swol/excercise/excerciseStructure.dart';
import 'package:swol/excerciseSelection/excerciseListPage.dart';
import 'package:swol/excerciseSelection/secondary/decoration.dart';
import 'package:swol/other/theme.dart';
import 'package:swol/excercise/excerciseData.dart';
import 'package:swol/excerciseSearch/searchesData.dart';
import 'package:swol/utils/onboarding.dart';

//https://pub.dev/packages/animator
//https://pub.dev/packages/auto_animated
//https://pub.dev/packages/flutter_sidekick

//app start
void main() => runApp(App());

//required for loading pages to come up
class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //its specifically designed for portrait mode
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]); 

    //initially this is going to be flat black
    SystemChrome.setSystemUIOverlayStyle(ThemeChanger.allBlackStyle);

    //main app build
    return FeatureDiscovery(
      child: MaterialApp(
        title: 'SWOL',
        theme: ThemeData.dark(), //only until everything loads
        home: GrabSystemPrefs(),
      ),
    );
  }
}

//grabbing system preferences
class GrabSystemPrefs extends StatelessWidget {
  final AsyncMemoizer _memoizer = AsyncMemoizer();

  fetchData() {
    return this._memoizer.runOnce(() async {
      return await SharedPreferences.getInstance();
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: fetchData(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if(snapshot.connectionState == ConnectionState.done){
          //grab and process system prefs
          SharedPreferences prefs = snapshot.data;

          //handle theme stuff
          dynamic isDark = prefs.getBool("darkMode");
          if(isDark == null){ //dark mode is the DEFAULT
            prefs.setBool("darkMode", true);
            isDark = true;
          }

          //handle workout stuff
          dynamic nextID = prefs.getInt("nextID");
          if(nextID == null){
            prefs.setInt("nextID", 0);
            nextID = 0;
          }

          //get bool value
          bool permissionGiven = OnBoarding.setgetValue(prefs, StoredBools.TermsAgreed);
          bool shownInitialControls = OnBoarding.setgetValue(prefs, StoredBools.InitialControlsShown);
          bool shownSearchButton = OnBoarding.setgetValue(prefs, StoredBools.SearchButtonShown);
          bool shownCalculator = OnBoarding.setgetValue(prefs, StoredBools.CalculatorShown);
          bool shownSettings = OnBoarding.setgetValue(prefs, StoredBools.SettingsShown);

          //set nextID to its usable version
          AnExcercise.nextID = nextID;

          //return app
          return ChangeNotifierProvider<ThemeChanger>(
            //NOTE: this will also setup the status and notifiaction bar colors
            //we don't wait for this though, because constructors can't be async
            create: (_) => ThemeChanger(
              (isDark) ? MyTheme.dark : MyTheme.light,
            ), 
            child: GrabFileData(
              permissionGiven: permissionGiven,
              shownInitialControls: shownInitialControls,
              shownSearchBar: shownSearchButton,
              shownCalculator: shownCalculator,
              shownSettings: shownSettings,
            ),
          );
        }
        else{ //to load just show the logo a bit longer
          return new SplashScreen();
        }
      }
    );
  }
}

//grabbing file data
//1. previous searches for search section
//2. excercises for showing them in the list
class GrabFileData extends StatefulWidget {
  GrabFileData({
    @required this.permissionGiven,
    @required this.shownInitialControls,
    @required this.shownSearchBar,
    @required this.shownCalculator,
    @required this.shownSettings,
  });

  final bool permissionGiven;
  final bool shownInitialControls;
  final bool shownSearchBar;
  final bool shownCalculator;
  final bool shownSettings;

  @override
  _GrabFileDataState createState() => _GrabFileDataState();
}

class _GrabFileDataState extends State<GrabFileData> {
  final AsyncMemoizer _memoizer = AsyncMemoizer();

  fetchData() {
    return this._memoizer.runOnce(() async {
      await SearchesData.searchesInit();
      return await ExcerciseData.excercisesInit();
    });
  }

  @override
  Widget build(BuildContext context) {
    return new FutureBuilder(
      future: fetchData(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if(snapshot.connectionState == ConnectionState.done){
          return ExcerciseSelect(
            permissionGiven: widget.permissionGiven,
            shownInitialControls: widget.shownInitialControls,
            shownSearchBar: widget.shownSearchBar,
            shownCalculator: widget.shownCalculator,
            shownSettings: widget.shownSettings,
          );
        }
        else{
          return SplashScreen();
        }
      },
    );
  }
}

//splash screen used as loading indicator below
class SplashScreen extends StatefulWidget {
  const SplashScreen({
    Key key,
  }) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

//NOTE: the splash screen image wont appear unless you have a release build
//since things will finish loading before the splash sscreen image can load

//NOTE: only stateful for SingleTickerProvider
//using regular since FutureBuilder MAY cause the animation to trigger twice
//although I'm preventing that by using the memoizer
//flutter doesn't detect that and this silences the error
class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin{
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          //NOTE: only 2 expands (the logo must always be centered)
          Expand(),
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Image.asset(
              "assets/splash/splashCut.png",
              //width: 1080/2, //1080,
              //height: 1462/2 , //1462,
            ),
          ),
          Expanded(
            child: Center(
              child: Padding(
                padding: EdgeInsets.all(8),
                child: Center(
                  child: Container(
                    height: 50,
                    width: 50,
                    child: FittedBox(
                      fit: BoxFit.contain,
                      child: PumpingHeart( 
                        color: Colors.red,
                        size: 75.0,
                        controller: AnimationController(
                          vsync: this, 
                          //80 bpm / 60 seconds = 1.3 beat per second
                          duration: const Duration(milliseconds: 1333),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Expand extends StatelessWidget {
  const Expand({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(),
    );
  }
}