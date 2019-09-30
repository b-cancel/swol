//flutter
import 'package:flutter/material.dart';

//plugin
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:async/async.dart';
import 'package:swol/learn/learn.dart';

//internal: basics
import 'package:swol/other/theme.dart';
import 'package:swol/excerciseSearch/searchesData.dart';
import 'package:swol/excercise/excerciseData.dart';
import 'package:swol/excercise/excerciseStructure.dart';
import 'package:swol/excerciseSelection/decoration.dart';
import 'package:swol/excerciseSelection/persistentHeaderDelegate.dart';
import 'package:swol/other/durationFormat.dart';
import 'package:swol/sharedWidgets/excerciseTile.dart';
import 'package:swol/sharedWidgets/scrollToTop.dart';

//internal: links
import 'package:swol/excerciseAddition/addExcercise.dart';
import 'package:swol/excerciseSearch/searchExcercise.dart';

class ExcerciseSelect extends StatefulWidget {
  @override
  _ExcerciseSelectState createState() => _ExcerciseSelectState();
}

//NOTE: only stateful for SingleTickerProvider
//using regular since FutureBuilder MAY cause the animation to trigger twice
//although I'm preventing that by using the memoizer
//flutter doesn't detect that and this silences the error
class _ExcerciseSelectState extends State<ExcerciseSelect> with TickerProviderStateMixin{
  final AutoScrollController autoScrollController = new AutoScrollController();
  final AsyncMemoizer _memoizer = AsyncMemoizer();

  fetchData() {
    return this._memoizer.runOnce(() async {
      await SearchesData.searchesInit();
      return await ExcerciseData.excercisesInit();
    });
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
        title: new SwolLogo(),
        actions: <Widget>[
          IconButton(
            onPressed: (){
              showThemeSwitcher(context);
            },
            icon: Icon(Icons.settings),
          )
          /*
          IconButton(
            onPressed: (){
              Navigator.push(
                context, 
                PageTransition(
                  type: PageTransitionType.upToDown, 
                  child: LearnExcercise(),
                ),
              );
            },
            icon: Icon(FontAwesomeIcons.bookOpen),
          ),
          */
        ],
      ),
      body: new FutureBuilder(
        future: fetchData(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if(snapshot.connectionState == ConnectionState.done){
            return ListOnDone(
              autoScrollController: autoScrollController,
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

class ListOnDone extends StatefulWidget {
  ListOnDone({
    @required this.autoScrollController,
  });

  final AutoScrollController autoScrollController;

  @override
  _ListOnDoneState createState() => _ListOnDoneState();
}

class _ListOnDoneState extends State<ListOnDone> {
  bool newWorkoutSection = false;
  bool hiddenWorkoutSection = false;
  final Duration maxDistanceBetweenExcercises = Duration(hours: 1, minutes: 30);
  ValueNotifier<bool> onTop = new ValueNotifier(true);

  @override
  void initState() {
    //Updates every time we update[timestamp], add, or remove some excercise
    ExcerciseData.excercisesOrder.addListener((){
      setState(() {});
    });

    //scroll inits
    //auto scroll controller
    widget.autoScrollController.addListener((){
      ScrollPosition position = widget.autoScrollController.position;
      double currentOffset = widget.autoScrollController.offset;

      //Determine whether we are on the top of the scroll area
      if (currentOffset <= position.minScrollExtent) {
        onTop.value = true;
      }
      else onTop.value = false;
    });

    //super init
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> sliverList = new List<Widget>();
    List<List<AnExcercise>> listOfGroupOfExcercises = new List<List<AnExcercise>>();

    //try to see if we have workouts to add
    if(ExcerciseData.getExcercises().value.length > 0){
      //seperate excercise into their groups bassed on the max distance
      DateTime lastDateTime = DateTime(1500);
      for(int i = 0; i < ExcerciseData.excercisesOrder.value.length; i++){
        int excerciseID = ExcerciseData.excercisesOrder.value[i];

        //easy to access vars
        AnExcercise excercise = ExcerciseData.getExcercises().value[excerciseID];
        DateTime thisDateTime = excercise.lastTimeStamp;

        //make sure that a group exists for this excercise
        //here we are making a new section if needed
        if(thisDateTime.difference(lastDateTime) > maxDistanceBetweenExcercises){
          //do we really need the new section?
          Duration timeSince = DateTime.now().difference(thisDateTime);
          Duration prevTimeSince = DateTime.now().difference(lastDateTime);
          bool newGroupRequired;

          //check if it belongs to a special section
          bool newWorkout = timeSince > Duration(days: 365 * 100);
          bool hiddenWorkout = timeSince < Duration.zero;
          
          //update to show correct workout count
          if(newWorkoutSection == false && newWorkout){
            newWorkoutSection = true;
          }

          if(hiddenWorkoutSection == false && hiddenWorkout){
            hiddenWorkoutSection = true;
          }

          //if we have a new workout then we only need a new group
          //if the last item was also a new workout
          if(newWorkout || hiddenWorkout){
            //NOTE: its never both
            if(newWorkout){
              bool prevNewWorkout = prevTimeSince > Duration(days: 365 * 100);
              if(prevNewWorkout) newGroupRequired = false;
              else newGroupRequired = true;
            }
            else{
              bool prevHiddenWorkout = prevTimeSince < Duration.zero;
              if(prevHiddenWorkout) newGroupRequired = false;
              else newGroupRequired = true;
            }
          }
          else newGroupRequired = true;

          //add a new group because its needed
          //or because we have no other group
          if(newGroupRequired || listOfGroupOfExcercises.length == 0){
            listOfGroupOfExcercises.add(new List<AnExcercise>());
          }
        }

        //add this excercise to our 1. newly created group 2. OR old group
        listOfGroupOfExcercises[listOfGroupOfExcercises.length - 1].add(
          excercise,
        );

        //update lastDateTime
        lastDateTime = thisDateTime;
      }

      //fill sliver list
      for(int i = 0; i < listOfGroupOfExcercises.length; i++){
        //create header text
        List<AnExcercise> thisGroup = listOfGroupOfExcercises[i];
        DateTime oldestDT = thisGroup[0].lastTimeStamp;
        Duration timeSince = DateTime.now().difference(oldestDT);

        //change title if new or in progress
        //TODO: handle in progress
        String title = DurationFormat.format(
          timeSince,
          showMinutes: false,
          showSeconds: false,
          showMilliseconds: false,
          showMicroseconds: false,
          short: false,
        );
        String subtitle = "on a " + DurationFormat.weekDayToString[oldestDT.weekday];
        bool isHidden = false;
        if(timeSince > Duration(days: 365 * 100)){
          title = "New Excercises";
          subtitle = null;
        }
        else if(timeSince < Duration.zero){
          isHidden = true;
          title = "Hidden Excercises";
          subtitle = null;
        }

        //highlight first workout section
        //NOTE: may be NEW, or IN PROGRESS, or simple NEXT
        bool isFirstSection = (i == 0);
        Color topColor;
        Color textColor;
        FontWeight fontWeight;
        if(isFirstSection || isHidden){
          topColor = Theme.of(context).accentColor;
          textColor = Theme.of(context).primaryColor;
          fontWeight = FontWeight.bold;
        }
        else{
          topColor = Theme.of(context).primaryColor;
          textColor = Colors.white;
          fontWeight = FontWeight.normal;
        }

        //determine if hidden are below
        Color bottomColor = Theme.of(context).primaryColor;
        if((i + 1) < listOfGroupOfExcercises.length){
          //there is a section below our but is it hidden
          DateTime prevTS = listOfGroupOfExcercises[i+1][0].lastTimeStamp;
          Duration timeSince = DateTime.now().difference(prevTS);
          if(timeSince < Duration.zero){
            bottomColor = Theme.of(context).accentColor;
          }
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
                    (subtitle == null)
                    ? MyChip(
                      chipString: (isHidden) ? "HIDDEN" : "NEW", 
                      inverse: true,
                    )
                    : Text(
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
                              color: bottomColor,
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
                          return ExcerciseTile(
                            excerciseID: thisGroup[index].id,
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
            //56 larger button height
            //48 smaller button height
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
          workoutCount: listOfGroupOfExcercises.length 
          //exclude new workouts
          - (newWorkoutSection ? 1 : 0) 
          //exclude hidden workouts
          - (hiddenWorkoutSection ? 1 : 0),
        ),
      ),
    );

    finalWidgetList.addAll(sliverList);

    //return
    return Stack(
      children: <Widget>[
        CustomScrollView(
          controller: widget.autoScrollController,
          slivers: finalWidgetList,
        ),
        Positioned(
          right: 0,
          bottom: 0,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: FloatingActionButton.extended(
              onPressed: (){
                Navigator.push(
                  context, 
                  PageTransition(
                    type: PageTransitionType.downToUp, 
                    child: SearchExcercise(),
                  ),
                );
              },
              icon: Icon(Icons.search),
              label: Text("Search"),
            ),
          ),
        ),
        ScrollToTopButton(
          onTop: onTop,
          autoScrollController: widget.autoScrollController,
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
                    child: AddExcercise(),
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
}