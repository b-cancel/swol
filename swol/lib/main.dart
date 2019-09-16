import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:swol/utils/data.dart';
import 'package:swol/workout.dart';

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

  @override
  Widget build(BuildContext context) {
    double expandHeight = MediaQuery.of(context).size.height / 3;
    expandHeight = (expandHeight < 40) ? 40 : expandHeight; 

    return Scaffold(
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
          ExcerciseList(),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: (){

        },
        icon: Icon(Icons.add),
        label: Text("Add New"),
      ),
    );
  }
}

class ExcerciseList extends StatefulWidget {
  @override
  _ExcerciseListState createState() => _ExcerciseListState();
}

class _ExcerciseListState extends State<ExcerciseList> {
  @override
  Widget build(BuildContext context) {
    return new FutureBuilder(
      future: workoutsInit(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if(snapshot.connectionState == ConnectionState.done){
          //create list of items
          List<Widget> inSliver = new List<Widget>();
          List<Workout> workouts = getWorkouts();
          for(int i = 0; i < workouts.length; i ++){
            Workout workout = workouts[i];
            inSliver.add(
              ListTile(
                onTap: (){
                  print("go to the details of this workout");
                },
                title: Text(workout.name),
                subtitle: Text(
                  timeSince(workout.timeStamp)
                ),
                trailing: Icon(Icons.chevron_right),
              )
            );
          }

          //add spacer to not occlude lower items
          inSliver.add(
            Container(
              height: 16 + 48.0 + 16,
              width: MediaQuery.of(context).size.width,
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.only(left: 16),
              child: Text(
                inSliver.length.toString() + " Workouts",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          );

          //build
          return SliverList(
            delegate: new SliverChildListDelegate(
              inSliver,
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

String timeSince(DateTime timestamp, {
  bool showYears: true, //365 days
  bool showMonths: true, //30 days
  bool showWeeks: true, //7 days
  bool showDays: true, //24 hrs
  bool showHours: true, //60 minutes
  bool showMinutes: true, //60 seconds
  bool showSeconds: true, //1000 milliseconds
  bool showMilliseconds: true,
  bool showMicroseconds: true,
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

  //get the time since
  Duration timeSince = DateTime.now().difference(timestamp);

  print(timeSince.toString());

  //digest it given the variables
  if(showYears && timeSince.inDays > 0){
    years = timeSince.inDays % 365;
    timeSince = timeSince - Duration(days: (365 * years));
  }

  if(showMonths && timeSince.inDays > 0){
    months = timeSince.inDays % 30;
    timeSince = timeSince - Duration(days: (30 * months));
  }

  if(showWeeks && timeSince.inDays > 0){
    weeks = timeSince.inDays % 7;
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