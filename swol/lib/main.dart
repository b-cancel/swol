//flutter
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

//plugins
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:async/async.dart';

//internal
import 'package:swol/excerciseSelection/excerciseList.dart';
import 'package:swol/excercise/excerciseStructure.dart';
import 'package:swol/other/theme.dart';

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
          AnExcercise.nextID = nextID;

          //return app
          return ChangeNotifierProvider<ThemeChanger>(
            builder: (_) => ThemeChanger(
              (isDark) ? MyTheme.dark : MyTheme.light,
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