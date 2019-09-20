import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:page_transition/page_transition.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:swol/addWorkout.dart';
import 'package:swol/helpers/main.dart';
import 'package:swol/tabs/break.dart';
import 'package:swol/utils/data.dart';
import 'package:swol/workout.dart';
import 'package:async/async.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';

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

class ExcerciseSelect extends StatefulWidget {
  @override
  _ExcerciseSelectState createState() => _ExcerciseSelectState();
}

class _ExcerciseSelectState extends State<ExcerciseSelect> with SingleTickerProviderStateMixin{
  Duration maxDistanceBetweenExcercises = Duration(hours: 1);
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
    Excercise workout,
  ){
    //calculations
    Duration timeSince = DateTime.now().difference(workout.lastTimeStamp);
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
        print("id: " + workout.predictionID.toString());
        print("auto: " + workout.autoUpdatePrediction.toString());
        print("url: " + workout.url.toString());
        print("wait: " + workout.lastBreak.toString());
        print("sets: " + workout.setTarget.toString());
      },
      title: Text(workout.name),
      subtitle: subtitle,
      trailing: Icon(Icons.chevron_right),
    );
  }

  @override
  Widget build(BuildContext context) {
    //setup vars
    double expandHeight = MediaQuery.of(context).size.height / 3;
    expandHeight = (expandHeight < 40) ? 40 : expandHeight; 
    Widget persistentHeader = SliverPersistentHeader(
      pinned: true,
      floating: true,
      delegate: PersistentHeaderDelegate(
        openHeight: MediaQuery.of(context).size.height / 3,
        closedHeight: 40,
      ),
    );

    //build
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColorDark,
        title: new SWOL(),
        actions: <Widget>[
          IconButton(
            onPressed: (){
              //TODO: how long until a excercise is considered part of a different workout
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
            sliverList.add(persistentHeader);

            //try to see if we have workouts to add
            if(excercises.value.length > 0){
              //seperate excercise into their groups bassed on the max distance
              List<List<Excercise>> listOfGroupOfExcercises = new List<List<Excercise>>();
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

              //check
              /*
              for(int i = 0; i < listOfGroupOfExcercises.length; i++){
                List<Excercise> excerciseGroup = listOfGroupOfExcercises[i];
                print("group " + i.toString() + " has " + excerciseGroup.length.toString() + " excercises");
                for(int j = 0; j < excerciseGroup.length; j++){
                  Duration timeSince = DateTime.now().difference(excerciseGroup[j].lastTimeStamp);
                  print(formatDuration(timeSince));
                }
              }
              */

              for(int i = 0; i < listOfGroupOfExcercises.length; i++){
                //create header text
                List<Excercise> thisGroup = listOfGroupOfExcercises[i];
                DateTime oldestDT = thisGroup[0].lastTimeStamp;
                Duration timeSince = DateTime.now().difference(oldestDT);

                //highlight new workout section
                bool newWorkout = (timeSince > Duration(days: 365 * 100));
                Color topColor;
                String title;
                Color textColor;
                FontWeight fontWeight;
                if(newWorkout){
                  topColor = Theme.of(context).accentColor;
                  title = "New Workout";
                  textColor = Theme.of(context).primaryColor;
                  fontWeight = FontWeight.bold;
                }
                else{
                  topColor = Theme.of(context).primaryColor;
                  title = ("Workout " + formatDuration(timeSince) + " ago");
                  textColor = Colors.white;
                  fontWeight = FontWeight.normal;
                }

                //add this section to the list of slivers
                sliverList.add(
                  SliverStickyHeader(
                    header: Container(
                      color: topColor,
                      padding: new EdgeInsets.only(
                        left: 24,
                        right: 24,
                        top: 16,
                        bottom: 8,
                      ),
                      alignment: Alignment.bottomLeft,
                      child: Container(
                        alignment: Alignment.centerLeft,
                        child: new Text(
                          title,
                          style: TextStyle(
                            fontSize: 16,
                            color: textColor,
                            fontWeight: fontWeight,
                          ),
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
                                  return buildExcerciseTile(context, thisGroup[index]);
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
                      excercises.value.length.toString() + " Workouts",
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

            //return
            return Stack(
              children: <Widget>[
                CustomScrollView(
                  controller: autoScrollController,
                  slivers: sliverList,
                ),
                //TODO: remove this once timer functionality is all handled
                Positioned(
                  left: 0,
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
                      child: Icon(Icons.timer),
                    ),
                  ),
                ),
                //Add New Excercise Button
                Positioned(
                  right: 0,
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
                persistentHeader,
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