//flutter
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

//plugins
import 'package:shared_preferences/shared_preferences.dart';
import 'package:feature_discovery/feature_discovery.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:provider/provider.dart';
import 'package:async/async.dart';

//internal: shared
import 'package:swol/shared/methods/extensions/sharedPreferences.dart';
import 'package:swol/shared/functions/theme.dart';

//internal: selection
import 'package:swol/excerciseSelection/secondary/decoration.dart';
import 'package:swol/excerciseSelection/excerciseListPage.dart';

//internal: other
import 'package:swol/excercise/excerciseData.dart';
import 'package:swol/excerciseSearch/searchesData.dart';

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

    //app loading theme
    SystemChrome.setSystemUIOverlayStyle(ThemeChanger.allBlackStyle);

    //main app build
    return BotToastInit(
      child: FeatureDiscovery(
        child:  MaterialApp(
          title: 'SWOL',
          navigatorObservers: [BotToastNavigatorObserver()],//2.registered route observer
          theme: ThemeData.dark(),
          home: GrabSystemPrefs(),
        ),
      ),
    );
  }
}

//grabbing system preferences
class GrabSystemPrefs extends StatelessWidget {
  static BuildContext rootContext;

  final AsyncMemoizer _memoizer = AsyncMemoizer();

  fetchData() {
    return this._memoizer.runOnce(() async {
      return await SharedPreferences.getInstance();
    });
  }

  @override
  Widget build(BuildContext context) {
    //save root context for use later
    rootContext = context;

    //return
    return FutureBuilder(
      future: fetchData(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if(snapshot.connectionState == ConnectionState.done){
          //grab and process system prefs
          SharedPreferences preferences = snapshot.data;
          SharedPrefsExt.init(preferences);
          ThemeData initialTheme = (SharedPrefsExt.getIsDark().value) ? MyTheme.dark : MyTheme.light;

          //return app
          return ChangeNotifierProvider<ThemeChanger>(
            //NOTE: this will also setup the status and notifiaction bar colors
            //we don't wait for this though, because constructors can't be async
            create: (_) => ThemeChanger(initialTheme), 
            child: GrabFileData(),
          );
        }
        else{ //to load just show the logo a bit longer
          return SplashScreen();
        }
      }
    );
  }
}

//grabbing file data
//1. previous searches for search section
//2. excercises for showing them in the list
class GrabFileData extends StatelessWidget {
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
          return ExcerciseSelect();
        }
        else return SplashScreen();
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
          Expanded(
            child: Container(),
          ),
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