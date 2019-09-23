//flutter
import 'package:flutter/material.dart';

//internal
import 'package:swol/functions/helper.dart';
import 'package:swol/helpers/addWorkout.dart';
import 'package:swol/helpers/addWorkoutInfo.dart';
import 'package:swol/helpers/mySlider.dart';
import 'package:swol/helpers/timePicker.dart';
import 'package:swol/utils/data.dart';
import 'package:swol/workout.dart';

//main widget
class AddWorkout extends StatefulWidget {
  const AddWorkout({
    Key key,
  }) : super(key: key);

  @override
  _AddWorkoutState createState() => _AddWorkoutState();
}

class _AddWorkoutState extends State<AddWorkout> {
  //name field
  TextEditingController nameCtrl = new TextEditingController();
  FocusNode nameFN = new FocusNode();
  ValueNotifier<bool> namePresent = new ValueNotifier(false);
  String nameError; //required since the name is required

  //note field
  TextEditingController noteCtrl = new TextEditingController();
  FocusNode noteFN = new FocusNode();
  ValueNotifier<bool> notePresent = new ValueNotifier(false);

  //url field
  ValueNotifier<String> url = new ValueNotifier("");

  //function select
  int functionIndex = defaultFunctionIndex;
  String functionValue = functions[defaultFunctionIndex];

  //recovery period select
  ValueNotifier<Duration> recoveryPeriod = new ValueNotifier(
    Excercise.defaultDuration,
  );

  //set target select
  ValueNotifier<int> setTarget = new ValueNotifier(
    Excercise.defaultSetTarget,
  );

  //rep target select
  ValueNotifier<int> repTarget = new ValueNotifier(
    Excercise.defaultRepTarget,
  );

  @override
  void initState() {
    //autofocus name
    WidgetsBinding.instance.addPostFrameCallback((_){
      FocusScope.of(context).requestFocus(nameFN);
    });

    //update name present
    nameCtrl.addListener((){
      namePresent.value = (nameCtrl.text != "");
    });

    //update button given once name given
    namePresent.addListener((){
      setState(() {});
    });

    //update note present
    noteCtrl.addListener((){
      notePresent.value = (noteCtrl.text != "");
    });

    //update present
    notePresent.addListener((){
      setState(() {});
    });

    //when url change we update
    url.addListener((){
      setState(() {});
    });

    //update when break updates
    recoveryPeriod.addListener((){
      setState(() {});
    });

    //super init
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //add s? (such a minimal detail)
    int mins = recoveryPeriod.value.inMinutes;
    bool showS = (mins == 1) ? false : true;

    //other
    String nameHint = "Required*";

    //for slider hatch mark
    double totalWidth = MediaQuery.of(context).size.width;
    double sliderWidth = totalWidth - (16.0 * 2) - (8 * 2);

    //how long it takes to shift focus to a different section
    Duration changeDuration = Duration(milliseconds: 250);

    //cal best for
    int sectionGrown;
    if(recoveryPeriod.value <= Duration(seconds: 30)) sectionGrown = 0;
    else if(recoveryPeriod.value <= Duration(seconds: 90)) sectionGrown = 1;
    else if(recoveryPeriod.value <= Duration(minutes: 5)) sectionGrown = 2;
    else sectionGrown = 3;

    //size of the middle text and such
    double textMaxWidth = 28;
    double textHeight = 16;

    //denom must match, and 2 items have regular width
    //double grownWidth = sliderWidth * (5 / 7);
    //double regularWidth = sliderWidth * (1 / 7);

    //build
    return Scaffold(
      appBar: AppBar(
        title: Text('Add New Excercise'),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: RaisedButton(
              color: (namePresent.value) 
              ? Theme.of(context).accentColor 
              : Colors.grey,
              onPressed: (){
                if(namePresent.value){
                  //add workout to our list
                  addExcercise(Excercise(
                    name: nameCtrl.text,
                    url: url.value,
                    note: noteCtrl.text,

                    //we must work off of current so the list is build properly
                    //the new excercises you added the longest time ago are on top
                    lastTimeStamp: DateTime.now().subtract(Duration(days: 365 * 100)),
                    lastSetTarget: setTarget.value,


                    predictionID: functionIndex,
                    recoveryPeriod: recoveryPeriod.value,
                    repTarget: repTarget.value,
                  ));

                  //exit pop up
                  Navigator.pop(context);
                }
                else{
                  nameError = "Name Is Required";
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
        ],
      ),
      body: ListView(
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
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      HeaderWithInfo(
                        title: "Excercise Name",
                        popUp: ExcerciseNamePopUp(),
                      ),
                      new TextFieldWithClearButton(
                        ctrl: nameCtrl, 
                        focusnode: nameFN, 
                        hint: nameHint, 
                        error: nameError, 
                        present: namePresent,
                        otherFocusNode: noteFN,
                      ),
                      HeaderWithInfo(
                        title: "Excercise Notes",
                        popUp: ExcerciseNotePopUp(),
                      ),
                      new TextFieldWithClearButton(
                        ctrl: noteCtrl, 
                        focusnode: noteFN, 
                        hint: "Details", 
                        error: null, 
                        present: notePresent,
                      ),
                      Container(
                        child: HeaderWithInfo(
                          title: "Reference Link",
                          popUp: new ReferenceLinkPopUp(),
                        ),
                      ),
                      new ReferenceLinkBox(
                        url: url,
                      ),
                    ],
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
                          title: "Recovery Time Between Sets",
                          popUp: new SetBreakPopUp(),
                        ),
                      ),
                      TimePicker(
                        duration: recoveryPeriod,
                      ),
                      new MinsSecsBelowTimePicker(
                        showS: showS,
                      ),
                      MyDivider(),
                      Container(
                        padding: EdgeInsets.only(
                          top: 16,
                          bottom: 8,
                        ),
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          child: FittedBox(
                            fit: BoxFit.fitWidth,
                            child: Text(
                              "This recovery time is best for increasing muscle",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                      new AnimatedRecoveryTimeInfo(
                        changeDuration: changeDuration, 
                        sectionGrown: sectionGrown, 
                        grownWidth: sliderWidth, 
                        regularWidth: 0, 
                        textHeight: textHeight, 
                        textMaxWidth: textMaxWidth,
                        selectedDuration: recoveryPeriod,
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
                        top: 8,
                        left: 16,
                        right: 16,
                      ),
                      child: new HeaderWithInfo(
                        title: "Rep Target",
                        popUp: new RepTargetPopUp(),
                      ),
                    ),
                    new CustomSlider(
                      value: repTarget,
                      lastTick: 35,
                    ),
                    AnimatedBuilder(
                      animation: repTarget,
                      builder: (context, child){
                        String warning = "";
                        if(repTarget.value <= 5){
                          warning = "At this target, your chances of injury are high,"
                          + "\nmake sure your form is flawless at all times";
                        }
                        else if(repTarget.value >= 21){
                          warning = "At this target, you can quickly damage your tendons,"
                          + "\nmake sure your body is conditioned";
                        }
                        else if(repTarget.value >= 13){
                          warning = "At this target, you can damage your tendons"
                          + "\nmake sure your body is conditioned";
                        }

                        //output warning if necessary
                        if(warning == "") return Container();
                        else{
                          return Container(
                            padding: EdgeInsets.only(
                              left: 24,
                              right: 24,
                              bottom: 16,
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.only(
                                    right: 8,
                                  ),
                                  child: Icon(
                                    Icons.warning,
                                    color: Colors.red,
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    warning,
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
                    Container(
                      padding: EdgeInsets.only(
                        //Top 16 padding address above
                        left: 16,
                        right: 16,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(
                              top: 16,
                              bottom: 0,
                            ),
                            child: Container(
                              color: Theme.of(context).dividerColor,
                              height: 2,
                              width: MediaQuery.of(context).size.width,
                            ),
                          ),
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
                                functionIndex = functionToIndex[functionValue];
                              });
                            },
                            items: functions.map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            })
                            .toList(),
                          ),
                          Container(
                            child: new HeaderWithInfo(
                              title: "Set Target",
                              popUp: new SetTargetPopUp(),
                            ),
                          ),
                        ],
                      ),
                    ),
                    new CustomSlider(
                      value: setTarget,
                      lastTick: 9,
                    ),
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
                    )
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}