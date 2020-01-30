//flutter
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

//plugins
import 'package:shared_preferences/shared_preferences.dart';
import 'package:feature_discovery/feature_discovery.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:provider/provider.dart';

//internal: shared
import 'package:swol/shared/methods/extensions/sharedPreferences.dart';
import 'package:swol/shared/methods/excerciseData.dart';
import 'package:swol/shared/methods/theme.dart';

//internal: selection
import 'package:swol/excerciseSelection/secondary/decoration.dart';
import 'package:swol/excerciseSelection/excerciseListPage.dart';

//internal: other
import 'package:swol/pages/search/searchesData.dart';

//app start
void main() => runApp(App());

//required for loading pages to come up
class App extends StatelessWidget {
  //the cost of having a cool little animation that is trigger from EVERYWHERE
  static ValueNotifier<bool> navSpread;

  //build
  @override
  Widget build(BuildContext context) {
    navSpread = new ValueNotifier<bool>(false);

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
          home: GrabSystemData(),
        ),
      ),
    );
  }
}

//grabbing system data
class GrabSystemData extends StatefulWidget {
  static BuildContext rootContext;

  @override
  _GrabSystemDataState createState() => _GrabSystemDataState();
}

class _GrabSystemDataState extends State<GrabSystemData> {
  SharedPreferences preferences;

  @override
  void initState(){
    GrabSystemData.rootContext = context;
    asyncInit();
    super.initState();
  }

  asyncInit()async{
    await SearchesData.searchesInit();
    await ExcerciseData.excercisesInit();
    preferences = await SharedPreferences.getInstance();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if(preferences == null) return SplashScreen();
    else{
        SharedPrefsExt.init(preferences);
        ThemeData initialTheme = (SharedPrefsExt.getIsDark().value) ? MyTheme.dark : MyTheme.light;

        //return app
        return ChangeNotifierProvider<ThemeChanger>(
          //NOTE: this will also setup the status and notifiaction bar colors
          //we don't wait for this though, because constructors can't be async
          create: (_) => ThemeChanger(initialTheme), 
          child: ExcerciseSelect(),
        );
    }
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