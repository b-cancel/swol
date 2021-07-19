//dart
import 'dart:ui';

//flutter
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

//plugins
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:feature_discovery/feature_discovery.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

//internal: shared
import 'package:swol/shared/methods/extensions/sharedPreferences.dart';
import 'package:swol/shared/methods/exerciseData.dart';
import 'package:swol/shared/methods/theme.dart';

//internal
import 'package:swol/pages/selection/exerciseListPage.dart';
import 'package:swol/pages/search/searchesData.dart';

//notification handler
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
final ValueNotifier<int> exerciseToTravelTo = new ValueNotifier<int>(-1);

/*
---for iOS---
open ios/Runner.xcworkspace   
change version
flutter build ipa --no-sound-null-safety
open build/ios/archive/Runner.xcarchive
validate
distribute

---for Android---
change version in pubspec.yaml
https://stackoverflow.com/questions/64677404/sign-your-flutter-app-with-upload-key-app-signing-by-google-play
create keystore
flutter build appbundle --no-sound-null-safety
*/

//start the program
main() {
  runApp(App());
}

//required for loading pages to come up
class App extends StatelessWidget {
  //the cost of having a cool little animation that is trigger from EVERYWHERE
  static ValueNotifier<bool> navSpread = ValueNotifier<bool>(false);

  //build
  @override
  Widget build(BuildContext context) {
    //its specifically designed for portrait mode
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    //app loading theme
    SystemChrome.setSystemUIOverlayStyle(ThemeChanger.darkStyle);

    //main app build
    return FeatureDiscovery(
      child: MaterialApp(
        title: 'SWOL',
        builder: BotToastInit(), //1. call BotToastInit
        navigatorObservers: [
          BotToastNavigatorObserver()
        ], //2.registered route observer
        theme: MyTheme.dark,
        home: GrabSystemData(),
      ),
    );
  }
}

//grabbing system data
class GrabSystemData extends StatefulWidget {
  static BuildContext? rootContext;

  @override
  _GrabSystemDataState createState() => _GrabSystemDataState();
}

class _GrabSystemDataState extends State<GrabSystemData> {
  SharedPreferences? preferences;

  @override
  void initState() {
    GrabSystemData.rootContext = context;
    asyncInit();
    super.initState();
  }

  Future<void> _configureLocalTimeZone() async {
    tz.initializeTimeZones();
    String timeZoneName = await FlutterNativeTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timeZoneName));
  }

  asyncInit() async {
    //grab all data from files
    await SearchesData.searchesInit();
    await ExerciseData.exercisesInit();
    preferences = await SharedPreferences.getInstance();
    SharedPrefsExt.init(preferences!);

    //start up the notification system
    //needed if you intend to initialize in the `main` function
    //or in my case just in case
    WidgetsFlutterBinding.ensureInitialized();

    await _configureLocalTimeZone();

    //app_icon needs to be a added as a drawable resource to the Android head project
    //just plug it in the folder, nothing else special needed
    var initializationSettingsAndroid = AndroidInitializationSettings(
      '@mipmap/launcher_icon',
    );

    //initialize IOS settings
    //and make sure that the notification is "triggered"
    //while the ap is in the foreground
    var initializationSettingsIOS = IOSInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
      onDidReceiveLocalNotification: (
        int id,
        String? title,
        String? body,
        String? payload,
      ) async {
        showDialog(
          context: context,
          builder: (BuildContext context) => CupertinoAlertDialog(
            title: title != null ? Text(title) : null,
            content: body != null ? Text(body) : null,
            actions: [
              CupertinoDialogAction(
                isDefaultAction: false,
                child: Text('Close'),
                onPressed: () async {
                  Navigator.of(context).pop();
                },
              ),
              CupertinoDialogAction(
                isDefaultAction: true,
                child: Text('Go To Exercise'),
                onPressed: () async {
                  Navigator.of(context).pop();

                  //updates what exercise to travel to
                  //which will then cause us to travel to it
                  if (payload != null) {
                    exerciseToTravelTo.value = int.parse(payload);
                  }
                },
              ),
            ],
          ),
        );
      },
    );

    var initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      /*
      If the app had been launched by tapping on a notification created by this plugin, 
      calling initialize is what will trigger the onSelectNotification to trigger 
      to handle the notification that the user tapped on. 
      An alternative to handling the "launch notification" 
      is to call the getNotificationAppLaunchDetails method 
      that is available in the plugin. 
      This could be used, for example, to change the home route of the app for deep-linking. 
      Calling initialize will still cause the onSelectNotification callback to fire 
      for the launch notification. 
      It will be up to developers to ensure that they don't process the same notification twice 
      (e.g. by storing and comparing the notification id).
      */
      //TODO REPAIRED NOT CHECKED
      //In the real world, this payload could represent the id of the item you want to display the details of.
      onSelectNotification: (String? payload) async {
        //updates what exercise to travel to
        //which will then cause us to travel to it
        if (payload != null) {
          exerciseToTravelTo.value = int.parse(payload);
        }
      },
    );

    //remove the loading indicator
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (preferences == null) {
      return SplashScreen();
    } else {
      return ExerciseSelectStateless();
    }
  }
}

//splash screen used as loading indicator below
class SplashScreen extends StatefulWidget {
  const SplashScreen({
    Key? key,
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
class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).primaryColorDark,
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            //NOTE: only 2 expands (the logo must always be centered)
            Expanded(
              child: Container(),
            ),
            Center(
              child: Container(
                width: MediaQuery.of(context).size.width * (2 / 3),
                child: Image.asset(
                  "assets/splash/splashCut.png",
                  //width: 1080/2, //1080,
                  //height: 1462/2 , //1462,
                ),
              ),
            ),
            Expanded(
              child: Container(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: EdgeInsets.all(8),
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
            Expanded(
              child: Container(),
            ),
          ],
        ),
      ),
    );
  }
}

class PumpingHeart extends StatefulWidget {
  // ignore: prefer_const_constructors_in_immutables
  PumpingHeart({
    Key? key,
    required this.color,
    this.size = 50.0,
    this.duration = const Duration(milliseconds: 2400),
    required this.controller,
  }) : super(key: key);

  final Color color;
  final double size;
  final Duration duration;
  final AnimationController controller;

  @override
  _PumpingHeartState createState() => _PumpingHeartState();
}

class _PumpingHeartState extends State<PumpingHeart>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _anim1;

  @override
  void initState() {
    super.initState();
    _controller = (AnimationController(vsync: this, duration: widget.duration))
      ..repeat();
    _anim1 = Tween(begin: 1.0, end: 1.25).animate(CurvedAnimation(
      parent: _controller,
      //TODO: REPAIRED NOT CHECKED
      curve: Curves.elasticInOut,
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
    return Icon(
      FontAwesomeIcons.solidHeart,
      color: widget.color,
      size: widget.size,
    );
  }
}
