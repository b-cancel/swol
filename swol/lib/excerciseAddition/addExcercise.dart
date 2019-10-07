//flutter
import 'package:flutter/material.dart';

//internal
import 'package:swol/excercise/excerciseData.dart';
import 'package:swol/excercise/excerciseStructure.dart';
import 'package:swol/excerciseSelection/addNewHero.dart';
import 'package:swol/sharedWidgets/excerciseEdit.dart';
import 'package:swol/sharedWidgets/informationDisplay.dart';
import 'package:swol/sharedWidgets/mySlider.dart';
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

    //super init
    super.initState();
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
                      CustomSlider(
                        value: repTarget,
                        lastTick: 35,
                      ),
                      CustomSliderWarning(repTarget: repTarget),
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
                      )
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}