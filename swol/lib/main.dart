import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:swol/addWorkout.dart';
import 'package:swol/functions/1RM&R=W.dart';
import 'package:swol/functions/W&R=1RM.dart';
import 'package:swol/helpers/main.dart';
import 'package:swol/tabs/break.dart';
import 'package:swol/updatePopUps.dart';
import 'package:swol/utils/data.dart';
import 'package:swol/utils/theme.dart';
import 'package:swol/workout.dart';
import 'package:async/async.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:shared_preferences/shared_preferences.dart';

/*
Pop up tested when tapping a form
//test all cases
bool timerComplete;
bool functionsMatch;
bool setsMatch;
if(index == 0){
  timerComplete = false;
  functionsMatch = false;
  setsMatch = false;
}
else if(index == 1){
  timerComplete = false;
  functionsMatch = false;
  setsMatch = true; //t
}
else if(index == 2){
  timerComplete = false;
  functionsMatch = true; //t
  setsMatch = false;
}
else if(index == 3){
  timerComplete = false; //f
  functionsMatch = true;
  setsMatch = true;
}
else if(index == 4){
  timerComplete = true; //t
  functionsMatch = false;
  setsMatch = false;
}
else if(index == 5){
  timerComplete = true;
  functionsMatch = false; //f
  setsMatch = true;
}
else if(index == 6){
  timerComplete = true;
  functionsMatch = true;
  setsMatch = false; //f
}
else{
  timerComplete = true;
  functionsMatch = true;
  setsMatch = true;
}

//create code given the condition
if(timerComplete){
  //guarantee the timer show up as complete

  //the timer started a minute ago
  newExcercise.tempStartTime = DateTime.now().subtract(Duration(minutes: 1));
  //it only needed to run for a second
  newExcercise.recoveryPeriod = Duration(seconds: 1);
}
else{
  //guarantee the timer show up as NOT complete
  //the timer started a minute ago
  newExcercise.tempStartTime = DateTime.now().subtract(Duration(minutes:2, seconds: 7));
  //it NEEDS to run for 1 hour
  newExcercise.recoveryPeriod = Duration(hours: 1);
}

//prep for functions match

//last data
newExcercise.lastWeight = 160;
newExcercise.lastReps = 8;

//assume they do the same quantity of reps as expected
newExcercise.tempReps = 8;

//expected 1 rep max
double expectedOneRepMax = To1RM.fromWeightAndReps(
  newExcercise.lastWeight.toDouble(), 
  newExcercise.lastReps.toDouble(), 
  newExcercise.predictionID,
);

//calculated expectedWeight
double expectedWeight = ToWeight.fromRepAnd1Rm(
  newExcercise.tempReps.toDouble(), 
  expectedOneRepMax, 
  newExcercise.predictionID,
);

//functions match
if(functionsMatch){
  newExcercise.tempWeight = expectedWeight.toInt();
}
else{
  //TODO: test both above and below (-+ 50)
  newExcercise.tempWeight = expectedWeight.toInt() + 50;
}

//sets match
if(setsMatch){
  newExcercise.tempSetCount = newExcercise.lastSetTarget;
}
else{
  //TODO: test both above and below (-+ 1)
  newExcercise.tempSetCount = newExcercise.lastSetTarget + 1;
}

//TODO: start with maybe are you sure
maybePopUpsBeforeNext(
  context,
  excercise: newExcercise,
  //TODO: test both
  nextAndDone: true,
);
*/

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

class ExcerciseSelect extends StatefulWidget {
  @override
  _ExcerciseSelectState createState() => _ExcerciseSelectState();
}

class _ExcerciseSelectState extends State<ExcerciseSelect> with SingleTickerProviderStateMixin{
  //NOTE: If you do one workout a day: 
  //there should be absolutely no reason that your excercises are this spread out
  //NOTE: If you do multiple workouts a day: 
  //there should be absolutely no reason that you only work 1.5 hours between your two workouts
  Duration maxDistanceBetweenExcercises = Duration(hours: 1, minutes: 30);
  final AutoScrollController autoScrollController = new AutoScrollController();
  final AsyncMemoizer _memoizer = AsyncMemoizer();

  fetchData() {
    return this._memoizer.runOnce(() async {
      return await excercisesInit();
    });
  }

  //allow us to animate the addition of new workouts
  buildExcerciseTile(
    BuildContext context, 
    Excercise newExcercise,
    int index,
  ){
    //calculations
    Duration timeSince = DateTime.now().difference(newExcercise.lastTimeStamp);
    bool never = (timeSince > Duration(days: 365 * 100));

    //subtitle gen
    Widget subtitle;
    if(never){
      subtitle = Container(
        alignment: Alignment.topLeft,
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: 4,
          ),
          decoration: new BoxDecoration(
            color: Theme.of(context).accentColor,
            borderRadius: new BorderRadius.all(
              Radius.circular(12.0),
            ),
          ),
          child: Text(
            "NEW",
            style: TextStyle(
              color: Theme.of(context).primaryColorDark,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
    }
    else{
      subtitle = Text(formatDuration(timeSince));
    }

    //build our widget given that search term
    return ListTile(
      onTap: (){
        print("timestamp: " + newExcercise.lastTimeStamp.toString());
        //-----
        print("name: " +  newExcercise.name.toString() + " => " + index.toString());
        print("url: " + newExcercise.url.toString());
        print("note: " + newExcercise.note.toString());
        //-----
        print("recovery: " + newExcercise.recoveryPeriod.toString());
        print("rep target: " + newExcercise.repTarget.toString());
        print("prediction ID: " + newExcercise.predictionID.toString());
        print("set target: " + newExcercise.lastSetTarget.toString());
      },
      title: Text(newExcercise.name),
      subtitle: subtitle,
      trailing: Icon(Icons.chevron_right),
    );
  }

  @override
  Widget build(BuildContext context) {
    //setup vars
    double expandHeight = MediaQuery.of(context).size.height / 3;
    expandHeight = (expandHeight < 40) ? 40 : expandHeight;

    //build
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColorDark,
        title: new SWOL(),
        actions: <Widget>[
          IconButton(
            onPressed: (){
              showThemeSwitcher(context);
            },
            icon: Icon(Icons.settings),
          )
        ],
      ),
      body: new FutureBuilder(
        future: fetchData(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if(snapshot.connectionState == ConnectionState.done){
            List<Widget> sliverList = new List<Widget>();
            List<List<Excercise>> listOfGroupOfExcercises = new List<List<Excercise>>();

            //try to see if we have workouts to add
            if(excercises.value.length > 0){
              //seperate excercise into their groups bassed on the max distance
              DateTime lastDateTime = DateTime(1500);
              for(int i = 0; i < excercises.value.length; i++){
                //easy to access vars
                Excercise excercise = excercises.value[i];
                DateTime thisDateTime = excercise.lastTimeStamp;

                //make sure that a group exists for this excercise
                if(thisDateTime.difference(lastDateTime) > maxDistanceBetweenExcercises){
                  //new group
                  listOfGroupOfExcercises.add(new List<Excercise>());
                }

                //add this excercise to our 1. newly created group 2. OR old group
                listOfGroupOfExcercises[listOfGroupOfExcercises.length - 1].add(
                  excercise,
                );

                //update lastDateTime
                lastDateTime = thisDateTime;
              }

              print("length 1: " + listOfGroupOfExcercises.length.toString());

              //fill sliver list
              for(int i = 0; i < listOfGroupOfExcercises.length; i++){
                //create header text
                List<Excercise> thisGroup = listOfGroupOfExcercises[i];
                DateTime oldestDT = thisGroup[0].lastTimeStamp;
                Duration timeSince = DateTime.now().difference(oldestDT);

                //highlight first workout section
                //NOTE: may be NEW, or IN PROGRESS, or simple NEXT
                bool isFirstSection = (i == 0);
                Color topColor;
                Color textColor;
                FontWeight fontWeight;
                if(isFirstSection){
                  topColor = Theme.of(context).accentColor;
                  textColor = Theme.of(context).primaryColor;
                  fontWeight = FontWeight.bold;
                }
                else{
                  topColor = Theme.of(context).primaryColor;
                  textColor = Colors.white;
                  fontWeight = FontWeight.normal;
                }

                //change title if new or in progress
                //TODO: handle in progress
                String title = formatDuration(
                  timeSince,
                  showMinutes: false,
                  showSeconds: false,
                  showMilliseconds: false,
                  showMicroseconds: false,
                  short: false,
                );
                String subtitle = "on a " + weekDayToString[oldestDT.weekday];
                if(timeSince > Duration(days: 365 * 100)){
                  title = "New Workout";
                }

                //add this section to the list of slivers
                sliverList.add(
                  SliverStickyHeader(
                    header: Container(
                      color: topColor,
                      padding: new EdgeInsets.only(
                        left: 16,
                        right: 16,
                        top: 16,
                        bottom: 8,
                      ),
                      alignment: Alignment.bottomLeft,
                      child: DefaultTextStyle(
                        style: TextStyle(
                          fontSize: 16,
                          color: textColor,
                          fontWeight: fontWeight,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            new Text(
                              title,
                            ),
                            new Text(
                              subtitle,
                            )
                          ],
                        ),
                      ),
                    ),
                    sliver: new SliverList(
                      delegate: new SliverChildListDelegate([
                        Stack(
                          children: <Widget>[
                            Positioned.fill(
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  Expanded(
                                    child: Container(
                                      color: topColor,
                                      child: Container(),
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      color: Theme.of(context).primaryColor,
                                      child: Container(),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Card(
                              margin: EdgeInsets.all(0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25.0),
                              ),
                              clipBehavior: Clip.antiAlias,
                              child: ListView.builder(
                                shrinkWrap: true,
                                physics: ClampingScrollPhysics(),
                                itemCount: thisGroup.length,
                                itemBuilder: (context, index){
                                  return buildExcerciseTile(
                                    context, 
                                    thisGroup[index],
                                    index,
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ]),
                    ),
                  ),
                );
              }

              //add sliver showing excercise count
              sliverList.add(
                SliverToBoxAdapter(
                  child: Container(
                    color: Theme.of(context).primaryColor,
                    height: 16 + 48.0 + 16,
                    width: MediaQuery.of(context).size.width,
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.only(left: 16),
                    child: Text(
                      "", //BLANK: the add new buttons fills the space now
                      //listOfGroupOfExcercises.length.toString() + " Workouts",
                      //excercises.value.length.toString() + " Excercises",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              );
            }
            else{
              //add sliver telling user to add item
              sliverList.add(
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(
                    child: FractionallySizedBox(
                      widthFactor: .5,
                      child: FittedBox(
                        fit: BoxFit.cover,
                        child: Text(
                          "Add an excercise below!",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }

            print("length 2: " + listOfGroupOfExcercises.length.toString());

            //add header
            List<Widget> finalWidgetList = new List<Widget>();
            finalWidgetList.add(
              SliverPersistentHeader(
                pinned: false,
                floating: false,
                delegate: PersistentHeaderDelegate(
                  semiClosedHeight: 60,
                  openHeight: MediaQuery.of(context).size.height / 3,
                  closedHeight: 0,
                  workoutCount: listOfGroupOfExcercises.length,
                ),
              ),
            );

            finalWidgetList.addAll(sliverList);

            //return
            return Stack(
              children: <Widget>[
                CustomScrollView(
                  controller: autoScrollController,
                  slivers: finalWidgetList,
                ),
                //TODO: remove this once timer functionality is all handled
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: FloatingActionButton(
                      onPressed: (){
                        Navigator.push(
                          context, 
                          PageTransition(
                            type: PageTransitionType.downToUp, 
                            child: Break(
                              startDuration: Duration(minutes: 5, seconds: 30),
                            )
                          ),
                        );
                      },
                      child: Icon(Icons.search),
                    ),
                  ),
                ),
                //Add New Excercise Button
                Positioned(
                  left: 0,
                  bottom: 0,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: FloatingActionButton.extended(
                      heroTag: 'addNew',
                      onPressed: (){
                        Navigator.push(
                          context, 
                          PageTransition(
                            type: PageTransitionType.rightToLeft, 
                            child: AddWorkout(),
                          ),
                        );
                      },
                      icon: Icon(Icons.add),
                      label: Text("Add New"),
                    ),
                  ),
                ),
              ],
            );
          }
          else{
            return CustomScrollView(
              controller: autoScrollController,
              slivers: [
                SliverPersistentHeader(
                  pinned: false,
                  floating: false,
                  delegate: PersistentHeaderDelegate(
                    semiClosedHeight: 40,
                    openHeight: MediaQuery.of(context).size.height / 3,
                    closedHeight: 0,
                  ),
                ),
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(
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
              ],
            );
          }
        },
      ),
    );
  }
}