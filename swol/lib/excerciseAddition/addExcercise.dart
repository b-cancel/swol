//flutter
import 'package:flutter/material.dart';

//plugins
import 'package:vector_math/vector_math_64.dart' as vect;

//internal
import 'package:swol/excercise/excerciseData.dart';
import 'package:swol/excercise/excerciseStructure.dart';
import 'package:swol/excerciseSelection/addNewHero.dart';
import 'package:swol/learn/body.dart';
import 'package:swol/sharedWidgets/excerciseEdit.dart';
import 'package:swol/sharedWidgets/informationDisplay.dart';
import 'package:swol/sharedWidgets/mySlider.dart';
import 'package:swol/sharedWidgets/timeHelper.dart';
import 'package:swol/sharedWidgets/timePicker.dart';
import 'package:swol/excerciseAddition/informationPopUps.dart';
import 'package:swol/other/functions/helper.dart';

//main widget
class AddExcercise extends StatefulWidget {
  const AddExcercise({
    Key key,
    @required this.navSpread,
  }) : super(key: key);

  final ValueNotifier<bool> navSpread;

  @override
  _AddExcerciseState createState() => _AddExcerciseState();
}

class _AddExcerciseState extends State<AddExcercise> {
  ValueNotifier<bool> showSaveButton = new ValueNotifier(false);

  //basics
  ValueNotifier<bool> namePresent = new ValueNotifier(false);
  ValueNotifier<bool> nameError = new ValueNotifier(false);
  ValueNotifier<String> name = new ValueNotifier("");
  ValueNotifier<String> note = new ValueNotifier("");
  ValueNotifier<String> url = new ValueNotifier("");

  //function select
  int functionIndex = AnExcercise.defaultFunctionID;
  String functionValue = Functions.functions[AnExcercise.defaultFunctionID];

  //recovery period select
  ValueNotifier<Duration> recoveryPeriod = new ValueNotifier(
    AnExcercise.defaultRecovery,
  );

  //set target select
  ValueNotifier<int> setTarget = new ValueNotifier(
    AnExcercise.defaultSetTarget,
  );

  //rep target select
  ValueNotifier<int> repTarget = new ValueNotifier(
    AnExcercise.defaultRepTarget,
  );
  //updated the above
  ValueNotifier<Duration> repTargetDuration = new ValueNotifier(
    Duration(
      seconds: AnExcercise.defaultRepTarget * 5,
    )
  );

  @override
  void initState() {
    Future.delayed(Duration(milliseconds: 500), (){
      showSaveButton.value = true;
    });

    //update when break updates
    recoveryPeriod.addListener((){
      setState(() {});
    });

    //update button given once name given
    namePresent.addListener((){
      setState(() {});
    });

    //update duration for UI updates
    repTarget.addListener((){
      repTargetDuration.value = Duration(
        seconds: repTarget.value * 5,
      );
    });

    //super init
    super.initState();
  }

  makeTrainingTypePopUp({
    @required String title,
    bool showStrength: false,
    bool showHypertrophy: false,
    bool showEndurance: false,
    int highlightfield: -1,
  }){
    return (){
      showDialog(
        context: context,
        builder: (BuildContext context){
          return SimpleDialog(
            contentPadding: EdgeInsets.all(0),
            titlePadding: EdgeInsets.all(0),
            title: Container(
              width: MediaQuery.of(context).size.width,
              color: Colors.blue,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(
                        right: 8,
                      ),
                      child: Icon(
                        Icons.info,
                        color: Colors.white,
                      ),
                    ),
                    new Text(
                      title,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            children: <Widget>[
              Container(
                color: Colors.white,
                width: MediaQuery.of(context).size.width,
                child: ScrollableTrainingTypes(
                  lightMode: true,
                  showEndurance: showEndurance,
                  showHypertrophy: showHypertrophy,
                  showStrength: showStrength,
                  highlightField: highlightfield,
                ),
              ),
            ],
          );
        }
      );
    };
  }

  @override
  Widget build(BuildContext context) {
    //add s? (such a minimal detail)
    int mins = recoveryPeriod.value.inMinutes;
    bool showS = (mins == 1) ? false : true;

    //for slider hatch mark
    double totalWidth = MediaQuery.of(context).size.width;
    double sliderWidth = totalWidth - (16.0 * 2) - (8 * 2);

    //how long it takes to shift focus to a different section
    Duration changeDuration = Duration(milliseconds: 250);

    //size of the middle text and such
    double textMaxWidth = 28;
    double textHeight = 16;

    //denom must match, and 2 items have regular width
    //double grownWidth = sliderWidth * (5 / 7);
    //double regularWidth = sliderWidth * (1 / 7);

    //build
    return WillPopScope(
      onWillPop: ()async{
        FocusScope.of(context).unfocus();
        widget.navSpread.value = false;
        return true; //can still pop
      },
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight),
          child: Container(
            width: MediaQuery.of(context).size.width,
            color: Colors.transparent,
            child: SafeArea(
              child: Container(
                child: Stack(
                  alignment: Alignment.center,
                  children: <Widget>[
                    Positioned(
                      left: 0,
                      bottom: 0,
                      top: 0,
                      right: 0,
                      child: AddNewHero(
                        inAppBar: true,
                        navSpread: widget.navSpread,
                      ),
                    ),
                    Positioned(
                      right: 0,
                      bottom: 0,
                      top: 0,
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.only(
                            right: 8.0,
                          ),
                          child: AnimatedBuilder(
                            animation: showSaveButton,
                            builder: (context, child){
                              return AnimatedContainer(
                                duration: Duration(milliseconds: 250),
                                curve: Curves.easeInOut,
                                constraints: BoxConstraints(
                                  //no limit vs limit
                                  //the 100 is so large its never going to be a limitation
                                  maxHeight: (showSaveButton.value) ? 100 : 0,
                                ),
                                child: FittedBox(
                                  fit: BoxFit.contain,
                                  child: RaisedButton(
                                    color: (namePresent.value) 
                                    ? Theme.of(context).accentColor 
                                    : Colors.grey,
                                    onPressed: ()async{
                                      if(namePresent.value){
                                        //remove keyboard
                                        FocusScope.of(context).unfocus();

                                        //add workout to our list
                                        await ExcerciseData.addExcercise(AnExcercise(
                                          //basic
                                          name: name.value,
                                          url: url.value,
                                          note: note.value,

                                          //we must work off of current so the list is build properly
                                          //the new excercises you added the longest time ago are on top
                                          lastTimeStamp: DateTime.now().subtract(Duration(days: 365 * 100)),

                                          //other
                                          lastSetTarget: setTarget.value,
                                          predictionID: functionIndex,
                                          recoveryPeriod: recoveryPeriod.value,
                                          repTarget: repTarget.value,
                                        ));

                                        //exit pop up
                                        widget.navSpread.value = false;
                                        Navigator.pop(context);
                                      }
                                      else{
                                        nameError.value = true;
                                        setState(() {});
                                      }
                                    },
                                    child: Text(
                                      "Save",
                                      style: TextStyle(
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        body: Container(
          color: Theme.of(context).scaffoldBackgroundColor,
          child: ListView(
            shrinkWrap: true,
            padding: EdgeInsets.symmetric(
              vertical: 16,
            ),
            children: <Widget>[
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Card(
                    margin: EdgeInsets.all(8),
                    child: Padding(
                      padding: EdgeInsets.only(
                        top: 8,
                        left: 16,
                        right: 16,
                        bottom: 16,
                      ),
                      child: new BasicEditor(
                        namePresent: namePresent,
                        nameError: nameError,
                        name: name,
                        note: note,
                        url: url,
                      ),
                    ),
                  ),
                  Card(
                    margin: EdgeInsets.all(8),
                    child: Container(
                      padding: EdgeInsets.only(
                        top: 8,
                        left: 16,
                        right: 16,
                        bottom: 16,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Container(
                            child: HeaderWithInfo(
                              title: "Recovery Time",
                              popUp: SetBreakPopUp(),
                            ),
                          ),
                          AnimatedRecoveryTimeInfo(
                            changeDuration: changeDuration,
                            grownWidth: sliderWidth, 
                            textHeight: textHeight, 
                            textMaxWidth: textMaxWidth,
                            selectedDuration: recoveryPeriod,
                            ranges: [
                              Range(
                                name: "Endurance Training",
                                onTap: makeTrainingTypePopUp(
                                  title: "Endurance Training",
                                  showEndurance: true,
                                  highlightfield: 2,
                                ),
                                left: new SliderToolTipButton(
                                  buttonText: "15s",
                                  tooltipText: "any less, wouldn't be enough",
                                ),
                                right: SliderToolTipButton(
                                  buttonText: "1m",
                                ),
                                startSeconds: 15,
                                endSeconds: 60,
                              ),
                              Range(
                                name: "Hypertrophy Training",
                                onTap: makeTrainingTypePopUp(
                                  title: "Hypertrophy Training",
                                  showHypertrophy: true,
                                  highlightfield: 2,
                                ),
                                left: SliderToolTipButton(
                                  buttonText: "1:05",
                                ),
                                right: SliderToolTipButton(
                                  buttonText: "2m",
                                ),
                                startSeconds: 65,
                                endSeconds: 120,
                              ),
                              Range(
                                name: "Hypertrophy/Strength (50/50)",
                                onTap: makeTrainingTypePopUp(
                                  title: "Hyper/Str (50/50)",
                                  showHypertrophy: true,
                                  showStrength: true,
                                  highlightfield: 2,
                                ),
                                left: SliderToolTipButton(
                                  buttonText: "2:05",
                                ),
                                right: SliderToolTipButton(
                                  buttonText: "3m",
                                ),
                                startSeconds: 125,
                                endSeconds: 180,
                              ),
                              Range(
                                name: "Strength Training",
                                onTap: makeTrainingTypePopUp(
                                  title: "Strength Training",
                                  showStrength: true,
                                  highlightfield: 2,
                                ),
                                left: SliderToolTipButton(
                                  buttonText: "3:05",
                                ),
                                right: SliderToolTipButton(
                                  buttonText: "4:55",
                                  tooltipText: "any more, and your muscles would've cooled off",
                                ),
                                startSeconds: 185,
                                endSeconds: 295,
                              )
                            ],
                          ),
                          TimePicker(
                            duration: recoveryPeriod,
                          ),
                          MinsSecsBelowTimePicker(
                            showS: showS,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Card(
                    margin: EdgeInsets.all(8),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.only(
                            //Top 16 padding address above
                            left: 16,
                            right: 16,
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Container(
                                child: new HeaderWithInfo(
                                  title: "Set Target",
                                  popUp: new SetTargetPopUp(),
                                ),
                              ),
                              TrainingTypeIndicator(
                                setTarget: setTarget,
                              ),
                            ],
                          ),
                        ),
                        new CustomSlider(
                          value: setTarget,
                          lastTick: 9,
                        ),
                        //TODO: when set target is above 6
                        //TODO: explain that it might be best to increase something else
                        //TODO: because if you wait this long , your muscles will cool down between sets
                        AnimatedBuilder(
                          animation: setTarget,
                          builder: (context, child){
                            if(setTarget.value <= 6) return Container();
                            else{
                              return Container(
                                padding: EdgeInsets.only(
                                  left: 24,
                                  right: 24,
                                  bottom: 16,
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: <Widget>[
                                    Padding(
                                      padding: EdgeInsets.only(
                                        right: 8,
                                      ),
                                      child: Icon(
                                        Icons.warning,
                                        color: Colors.yellow,
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        "Consider increasing weight or reps instead",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              );
                            }
                          },
                        ),
                      ]
                    ),
                  ),
                  Card(
                    margin: EdgeInsets.all(8),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.only(
                            top: 8,
                            left: 16,
                            right: 16,
                          ),
                          child: new HeaderWithInfo(
                            title: "Rep Target",
                            popUp: new RepTargetPopUp(),
                          ),
                        ),
                        CustomSlider(
                          value: repTarget,
                          lastTick: 35,
                        ),
                        Container(
                          child: Padding(
                            padding: const EdgeInsets.only(
                              left: 16.0,
                              bottom: 16,
                            ),
                            child: AnimatedRecoveryTimeInfo(
                              changeDuration: changeDuration,
                              grownWidth: sliderWidth, 
                              textHeight: textHeight, 
                              textMaxWidth: textMaxWidth,
                              selectedDuration: repTargetDuration,
                              bigTickNumber: 25,
                              ranges: [
                                Range(
                                  name: "Strength Training",
                                  onTap: makeTrainingTypePopUp(
                                    title: "Strength Training",
                                    showStrength: true,
                                    highlightfield: 3,
                                  ),
                                  left: new SliderToolTipButton(
                                    buttonText: "1",
                                  ),
                                  right: SliderToolTipButton(
                                    buttonText: "6",
                                  ),
                                  startSeconds: (1*5),
                                  endSeconds: (6*5),
                                ),
                                Range(
                                  name: "Hypertrophy Training",
                                  onTap: makeTrainingTypePopUp(
                                    title: "Hypertrophy Training",
                                    showHypertrophy: true,
                                    highlightfield: 3,
                                  ),
                                  left: SliderToolTipButton(
                                    buttonText: "7",
                                  ),
                                  right: SliderToolTipButton(
                                    buttonText: "12",
                                  ),
                                  startSeconds: (7*5),
                                  endSeconds: (12*5),
                                ),
                                Range(
                                  name: "Endurance Training",
                                  onTap: makeTrainingTypePopUp(
                                    title: "Endurance Training",
                                    showEndurance: true,
                                    highlightfield: 3,
                                  ),
                                  left: SliderToolTipButton(
                                    buttonText: "13",
                                  ),
                                  right: SliderToolTipButton(
                                    buttonText: "35",
                                    tooltipText: "any more, and the one rep max equation function will fail",
                                  ),
                                  startSeconds: (13*5),
                                  endSeconds: (35*5),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Card(
                    margin: EdgeInsets.all(8),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.only(
                            //Top 16 padding address above
                            left: 16,
                            right: 16,
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Container(
                                child: new HeaderWithInfo(
                                  title: "Prediction Formula",
                                  popUp: new PredictionFormulasPopUp(),
                                ),
                              ),
                              DropdownButton<String>(
                                value: functionValue,
                                icon: Icon(Icons.arrow_drop_down),
                                isExpanded: true,
                                iconSize: 24,
                                elevation: 16,
                                onChanged: (String newValue) {
                                  setState(() {
                                    functionValue = newValue;
                                    functionIndex = Functions.functionToIndex[functionValue];
                                  });
                                },
                                items: Functions.functions.map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                })
                                .toList(),
                              ),
                            ],
                          ),
                        ),
                      ]
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TrainingTypeIndicator extends StatefulWidget {
  TrainingTypeIndicator({
    @required this.setTarget,
  });

  final ValueNotifier<int> setTarget;

  @override
  _TrainingTypeIndicatorState createState() => _TrainingTypeIndicatorState();
}

class _TrainingTypeIndicatorState extends State<TrainingTypeIndicator> {
  int section;
  ScrollController controller = new ScrollController();

  setTargetToSection(){
    if(widget.setTarget.value > 7) section = 4;
    else{
      section = widget.setTarget.value - 3;
      section = (section < 0) ? 0 : section;
    }
  }

  @override
  void initState() {
    //init
    setTargetToSection();

    //listener
    widget.setTarget.addListener((){
      setTargetToSection();
      controller.animateTo(
        (((MediaQuery.of(context).size.width-48)/4) * section),
        duration: Duration(milliseconds: 250),
        curve: Curves.easeInOut,
      );
    });

    //super init
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double sectionSize = (MediaQuery.of(context).size.width-48)/4;
    return Container(
      height: 96, //manually set
      child: ListView(
        physics: NeverScrollableScrollPhysics(),
        scrollDirection: Axis.horizontal,
        controller: controller,
        children: [
          Stack(
            children: <Widget>[
              
              Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Tick(
                    tickActive: (widget.setTarget.value == 1),
                  ),
                  Container(
                    height: 16,
                    width: sectionSize,
                    color: Colors.red,
                    child: Text("1"),
                  ),
                  Tick(
                    tickActive: (widget.setTarget.value == 2),
                  ),
                  Container(
                    height: 16,
                    width: sectionSize,
                    color: Colors.blue,
                    child: Text("2"),
                  ),
                  Tick(
                    tickActive: (widget.setTarget.value == 3),
                  ),
                  Container(
                    height: 16,
                    width: sectionSize,
                    color: Colors.red,
                    child: Text("3"),
                  ),
                  Tick(
                    tickActive: (widget.setTarget.value == 4),
                  ),
                  Container(
                    height: 16,
                    width: sectionSize,
                    color: Colors.blue,
                    child: Text("4"),
                  ),
                  Tick(
                    tickActive: (widget.setTarget.value == 5),
                  ),
                  Container(
                    height: 16,
                    width: sectionSize,
                    color: Colors.red,
                    child: Text("5"),
                  ),
                  Tick(
                    tickActive: (widget.setTarget.value == 6),
                  ),
                  Container(
                    height: 16,
                    width: sectionSize,
                    color: Colors.blue,
                    child: Text("6"),
                  ),
                  Tick(
                    tickActive: (widget.setTarget.value == 7),
                  ),
                  Container(
                    height: 16,
                    width: sectionSize,
                    color: Colors.red,
                    child: Text("7"),
                  ),
                  Tick(
                    tickActive: (widget.setTarget.value == 8),
                  ),
                  Container(
                    height: 16,
                    width: sectionSize,
                    color: Colors.blue,
                    child: Text("8"),
                  ),
                  Tick(
                    tickActive: (widget.setTarget.value == 9),
                  ),
                ],
              ),
              
              Column(
                children: <Widget>[
                  Pill(
                    setTarget: widget.setTarget,
                    actives: [4,5,6],
                    sectionSize: sectionSize,
                    name: "Endurance Training",
                    onTap: (){
                      print("end");
                    },
                    leftMultiplier: 2.5,
                    rightMultiplier: 2.5,
                  ),
                  Pill(
                    setTarget: widget.setTarget,
                    actives: [3,4,5],
                    sectionSize: sectionSize,
                    name: "Hypertrophy Training",
                    onTap: (){
                      print("hyper");
                    },
                    leftMultiplier: 1.5,
                    rightMultiplier: 3.5,
                  ),
                  Pill(
                    setTarget: widget.setTarget,
                    actives: [2,3,4],
                    sectionSize: sectionSize,
                    name: "Strength Training",
                    onTap: (){
                      print("str");
                    },
                    leftMultiplier: .5,
                    rightMultiplier: 4.5,
                  ),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }
}

class Pill extends StatefulWidget {
  const Pill({
    Key key,
    @required this.sectionSize,
    @required this.setTarget,
    @required this.actives,
    @required this.name,
    @required this.onTap,
    @required this.leftMultiplier,
    @required this.rightMultiplier,
  }) : super(key: key);

  final double sectionSize;
  final ValueNotifier<int> setTarget;
  final List<int> actives;
  final String name;
  final Function onTap;
  final double leftMultiplier;
  final double rightMultiplier;

  @override
  _PillState createState() => _PillState();
}

class _PillState extends State<Pill> {
  bool active;

  setTargetToActive(){
    active = widget.actives.contains(widget.setTarget.value);
  }

  @override
  void initState() {
    //init
    setTargetToActive();

    //by update
    widget.setTarget.addListener((){
      setTargetToActive();
      setState(() {});
    });

    //super
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: 4,
      ),
      child: Row(
        children: <Widget>[
          Container(
            width: widget.leftMultiplier * widget.sectionSize,
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: AnimatedContainer(
              duration: Duration(milliseconds: 250),
              color: active ? Theme.of(context).accentColor : Theme.of(context).primaryColor,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: widget.onTap,
                  child: Container(
                    padding: EdgeInsets.all(4),
                    width: (widget.sectionSize * 3),
                    child: Center(
                      child: Text(
                        widget.name,
                        style: TextStyle(
                          color: active  ? Theme.of(context).primaryColor : Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Container(
            width: widget.rightMultiplier * widget.sectionSize,
          )
        ],
      ),
    );
  }
}

class Tick extends StatelessWidget {
  const Tick({
    Key key,
    @required this.tickActive,
  }) : super(key: key);

  final bool tickActive;

  @override
  Widget build(BuildContext context) {
    double tickHeight = 16;
    double tickWidth = 3;

    double actualTickWidth =  (tickActive) ? tickWidth : 0;

    return Container();
    
    /*SizedOverflowBox(
      size: Size(actualTickWidth, tickHeight),
      child: Container(
        height: tickHeight,
        width: actualTickWidth,
        color: Theme.of(context).accentColor,
      ),
    );
    */
  }
}