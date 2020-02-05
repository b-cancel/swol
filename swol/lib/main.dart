//flutter
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

//plugins
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:feature_discovery/feature_discovery.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:bot_toast/bot_toast.dart';

//internal: shared
import 'package:swol/shared/methods/extensions/sharedPreferences.dart';
import 'package:swol/shared/methods/excerciseData.dart';
import 'package:swol/shared/methods/theme.dart';

//internal
import 'package:swol/pages/selection/excerciseListPage.dart';
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
    SystemChrome.setSystemUIOverlayStyle(ThemeChanger.darkStyle);

    //main app build
    return BotToastInit(
      child: FeatureDiscovery(
        child:  MaterialApp(
          title: 'SWOL',
          navigatorObservers: [BotToastNavigatorObserver()],//2.registered route observer
          theme: MyTheme.dark,
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
    SharedPrefsExt.init(preferences);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if(preferences == null) return SplashScreen();
    else return ExcerciseSelectStateless();
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

class PumpingHeart extends StatefulWidget {
  // ignore: prefer_const_constructors_in_immutables
  PumpingHeart({
    Key key,
    this.color,
    this.size = 50.0,
    this.itemBuilder,
    this.duration = const Duration(milliseconds: 2400),
    this.controller,
  })  : assert(
            !(itemBuilder is IndexedWidgetBuilder && color is Color) &&
                !(itemBuilder == null && color == null),
            'You should specify either a itemBuilder or a color'),
        assert(size != null),
        super(key: key);

  final Color color;
  final double size;
  final IndexedWidgetBuilder itemBuilder;
  final Duration duration;
  final AnimationController controller;

  @override
  _PumpingHeartState createState() => _PumpingHeartState();
}

class _PumpingHeartState extends State<PumpingHeart>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> _anim1;

  @override
  void initState() {
    super.initState();
    _controller = (widget.controller ??
        AnimationController(vsync: this, duration: widget.duration))
      ..repeat();
    _anim1 = Tween(begin: 1.0, end: 1.25).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 1.0, curve: MyCurve()),
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _anim1,
      child: _itemBuilder(0),
    );
  }

  Widget _itemBuilder(int index) {
    return widget.itemBuilder != null
      ? widget.itemBuilder(context, index)
      : Icon(
        FontAwesomeIcons.solidHeart,
        color: widget.color,
        size: widget.size,
      );
  }
}