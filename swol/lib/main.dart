import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:swol/addWorkout.dart';
import 'package:swol/utils/data.dart';
import 'package:swol/workout.dart';
import 'package:async/async.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //its specifically designed for portrait mode
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    //build main
    return MaterialApp(
      title: 'SWOL',
      theme: ThemeData.dark(),
      home: ExcerciseSelect(),
    );
  }
}

class ExcerciseSelect extends StatelessWidget {
  final AutoScrollController autoScrollController = new AutoScrollController();
  final GlobalKey<AnimatedListState> workoutsKey = GlobalKey<AnimatedListState>();

  @override
  Widget build(BuildContext context) {
    double expandHeight = MediaQuery.of(context).size.height / 3;
    expandHeight = (expandHeight < 40) ? 40 : expandHeight; 

    return Scaffold(
      //NOTE: this seems like it doesn't do anything but 
      //it does remove a space that appears with animated list
      //why? I have no idea...
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(0.0),
        child: Container(),
      ),
      body: CustomScrollView(
        controller: autoScrollController,
        slivers: [
          SliverAppBar(
            backgroundColor: Theme.of(context).primaryColorDark,
            expandedHeight: expandHeight,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              title: Text("Workouts"),
            ),
          ),
          ExcerciseList(
            workoutsKey: workoutsKey,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: (){
          return showDialog<void>(
            context: context,
            barrierDismissible: true,
            builder: (BuildContext context) {
              return new AddWorkout(
                workoutsKey: workoutsKey,
              );
            },
          );
        },
        icon: Icon(Icons.add),
        label: Text("Add New"),
      ),
    );
  }
}

class ExcerciseList extends StatefulWidget {
  ExcerciseList({
    @required this.workoutsKey,
  });

  final GlobalKey<AnimatedListState> workoutsKey;

  @override
  _ExcerciseListState createState() => _ExcerciseListState();
}

class _ExcerciseListState extends State<ExcerciseList> {
  final AsyncMemoizer _memoizer = AsyncMemoizer();
  bool forceFetch = false;

  //So Future Builder only runs once
  fetchData() {
    return this._memoizer.runOnce(() async {
      return await workoutsInit();
    });
  }

  //allow us to animate the addition of new workouts
  buildWorkout(
    BuildContext context, 
    int index, 
    Animation<double> animation,
  ){
    //calculations
    Workout workout = getWorkouts()[index];
    Duration timeSince = DateTime.now().difference(workout.timeStamp);
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
    return SizeTransition(
      sizeFactor: new Tween<double>(
        begin: 0,
        end: 1, 
      ).animate(animation), 
      child: ListTile(
        onTap: (){
          print("go to the details of this workout");
        },
        title: Text(workout.name),
        subtitle: subtitle,
        trailing: Icon(Icons.chevron_right),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new FutureBuilder(
      future: fetchData(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if(snapshot.connectionState == ConnectionState.done){
          //grab data
          List<Workout> workouts = getWorkouts();

          //build
          return SliverList(
            delegate: new SliverChildListDelegate(
              [
                //NOTE: we reverse the list so that we can show the oldest on top
                AnimatedList(
                  key: widget.workoutsKey,
                  shrinkWrap: true, //REQUIRED: in order to properly work in a sliver
                  physics: ClampingScrollPhysics(), //DITTO
                  initialItemCount: getWorkouts().length,
                  itemBuilder: (context, index, animation){
                    return buildWorkout(context, index, animation);
                  },
                ),
                //spacer for bottom of list
                Container(
                  height: 16 + 48.0 + 16,
                  width: MediaQuery.of(context).size.width,
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.only(left: 16),
                  child: Text(
                    workouts.length.toString() + " Workouts",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ]
            ),
          );
        }
        else{
          return SliverFillRemaining(
            hasScrollBody: false,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      }
    );
  }
}

List<String> indexToChar = [
  "y","m","w","d","h","m","s","milli","micro"
];

String formatDuration(Duration timeSince, {
  bool showYears: true, //365 days
  bool showMonths: true, //30 days
  bool showWeeks: true, //7 days
  bool showDays: true, //24 hrs
  bool showHours: true, //60 minutes
  bool showMinutes: false, //60 seconds
  //TODO: left true for testing later
  bool showSeconds: true, //1000 milliseconds
  bool showMilliseconds: false,
  bool showMicroseconds: false,
}){
  //setup vars
  int years = 0;
  int months = 0;
  int weeks = 0;
  int days = 0;
  int hours = 0;
  int minutes = 0;
  int seconds = 0;
  int milliseconds = 0;
  int microseconds = 0;

  //digest it given the variables
  if(showYears && timeSince.inDays > 0){
    years = timeSince.inDays ~/ 365;
    timeSince = timeSince - Duration(days: (365 * years));
  }

  if(showMonths && timeSince.inDays > 0){
    months = timeSince.inDays ~/ 30;
    timeSince = timeSince - Duration(days: (30 * months));
  }

  if(showWeeks && timeSince.inDays > 0){
    weeks = timeSince.inDays ~/ 7;
    timeSince = timeSince - Duration(days: (7 * weeks));
  }

  if(showDays && timeSince.inDays > 0){
    days = timeSince.inDays;
    timeSince = timeSince - Duration(days: days);
  }

  if(showHours && timeSince.inHours > 0){
    hours = timeSince.inHours;
    timeSince = timeSince - Duration(hours: hours);
  }

  if(showMinutes && timeSince.inMinutes > 0){
    minutes = timeSince.inMinutes;
    timeSince = timeSince - Duration(minutes: minutes);
  }

  if(showSeconds && timeSince.inSeconds > 0){
    seconds = timeSince.inSeconds;
    timeSince = timeSince - Duration(seconds: seconds);
  }

  if(showMilliseconds && timeSince.inMilliseconds > 0){
    milliseconds = timeSince.inMilliseconds;
    timeSince = timeSince - Duration(milliseconds: milliseconds);
  }

  if(showMilliseconds && timeSince.inMicroseconds > 0){
    microseconds = timeSince.inMicroseconds;
  }

  //create string
  String output = "";
  List<int> times = [
    years, 
    months, 
    weeks, 
    days, 
    hours, 
    minutes, 
    seconds, 
    milliseconds, 
    microseconds,
  ];
  
  //loop through and generate
  for(int i = 0; i < times.length; i++){
    if(times[i] != 0){
      output += (times[i].toString() + indexToChar[i] + " ");
    }
  }

  //ret
  return output;
}