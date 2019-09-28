import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import '../addWorkout.dart';
import 'package:swol/excerciseTile.dart';
import 'package:swol/functions/1RM&R=W.dart';
import 'package:swol/functions/W&R=1RM.dart';
import 'package:swol/helpers/main.dart';
import 'package:swol/searchExcercise.dart';
import 'package:swol/tabs/break.dart';
import 'package:swol/updatePopUps.dart';
import 'package:swol/utils/data.dart';
import 'package:swol/utils/scrollToTap.dart';
import 'package:swol/utils/searches.dart';
import 'package:swol/utils/theme.dart';
import 'package:swol/workout.dart';
import 'package:async/async.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final AsyncMemoizer _memoizer = AsyncMemoizer();

  fetchData() {
    return this._memoizer.runOnce(() async {
      return await SharedPreferences.getInstance();
    });
  }

  @override
  Widget build(BuildContext context) {
    //its specifically designed for portrait mode
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);    

    //build main
    return  new FutureBuilder(
      future: fetchData(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if(snapshot.connectionState == ConnectionState.done){
          //grab and process system prefs
          SharedPreferences prefs = snapshot.data;

          //handle theme stuff
          dynamic isDark = prefs.getBool("darkMode");
          if(isDark == null){
            prefs.setBool("darkMode", false);
            isDark = false;
          }

          //handle workout stuff
          dynamic nextID = prefs.getInt("nextID");
          if(nextID == null){
            prefs.setInt("nextID", 0);
            nextID = 0;
          }

          //set nextID to its usable version
          Excercise.nextID = nextID;

          //return app
          return ChangeNotifierProvider<ThemeChanger>(
            builder: (_) => ThemeChanger(
              (isDark) ? ourDark : ourLight,
            ), 
            child: StatelessLink(),
          );
        }
        else{ //to load just show the logo a bit longer
          return Container(
            color: Colors.black,
            child: Image.asset(
              "assets/splash/splash.png",
            ),
          );
        }
      }
    );
  }
}

//-----Statless Link Required Between Entry Point And App
class StatelessLink extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeChanger>(context);
    return MaterialApp(
      title: 'SWOL',
      theme: theme.getTheme(),
      home: ExcerciseSelect(),
    );
  }
}