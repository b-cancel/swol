//flutter
import 'package:flutter/material.dart';
import 'package:swol/excercise/defaultDateTimes.dart';

//internal
import 'package:swol/excercise/excerciseData.dart';
import 'package:swol/excercise/excerciseStructure.dart';
import 'package:swol/excerciseSelection/secondary/addNewHero.dart';
import 'package:swol/sharedWidgets/basicFields/excerciseEdit.dart';
import 'package:swol/sharedWidgets/informationDisplay.dart';
import 'package:swol/sharedWidgets/mySlider.dart';
import 'package:swol/sharedWidgets/timeHelper.dart';
import 'package:swol/sharedWidgets/timePicker.dart';
import 'package:swol/excerciseAddition/informationPopUps.dart';
import 'package:swol/other/functions/helper.dart';
import 'package:swol/sharedWidgets/trainingTypes/trainingTypes.dart';

makeTrainingTypePopUp({
    @required BuildContext context,
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
              color: Theme.of(context).primaryColor,
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
                child: Column(
                  children: <Widget>[
                    ScrollableTrainingTypes(
                      lightMode: true,
                      showEndurance: showEndurance,
                      showHypertrophy: showHypertrophy,
                      showStrength: showStrength,
                      highlightField: highlightfield,
                    ),
                    new LearnPageSuggestion(),
                  ],
                ),
              ),
            ],
          );
        }
      );
    };
  }

//main widget
class AddExcercise extends StatelessWidget {
  AddExcercise({
    Key key,
    @required this.navSpread,
  }) : super(key: key);

  final ValueNotifier<bool> navSpread;

  //-----all the variables used below but not passed
  final ValueNotifier<bool> showSaveButton = new ValueNotifier(false);

  //basics
  final ValueNotifier<bool> namePresent = new ValueNotifier(false);
  final ValueNotifier<bool> nameError = new ValueNotifier(false);
  final ValueNotifier<String> name = new ValueNotifier("");
  final ValueNotifier<String> note = new ValueNotifier("");
  final ValueNotifier<String> url = new ValueNotifier("");

  //function select
  final ValueNotifier<int> functionIndex = new ValueNotifier(AnExcercise.defaultFunctionID);
  final ValueNotifier<String> functionString = new ValueNotifier(
    Functions.functions[AnExcercise.defaultFunctionID],
  );

  //recovery period select
  final ValueNotifier<Duration> recoveryPeriod = new ValueNotifier(
    AnExcercise.defaultRecovery,
  );

  //set target select
  final ValueNotifier<int> setTarget = new ValueNotifier(
    AnExcercise.defaultSetTarget,
  );

  //rep target select
  final ValueNotifier<int> repTarget = new ValueNotifier(
    AnExcercise.defaultRepTarget,
  );

  //updated the above
  final ValueNotifier<Duration> repTargetDuration = new ValueNotifier(
    Duration(
      seconds: AnExcercise.defaultRepTarget * 5,
    )
  );

  @override
  Widget build(BuildContext context) {
    print("build add excercise");

    //let the button animate in after the add excercise page slides in
    Future.delayed(Duration(milliseconds: 500), (){
      showSaveButton.value = true;
    });

    //update duration so our ticks update
    repTarget.addListener((){
      repTargetDuration.value = Duration(
        seconds: repTarget.value * 5,
      );
    });

    //for slider hatch mark
    double totalWidth = MediaQuery.of(context).size.width;
    double sliderWidth = totalWidth - (16.0 * 2) - (8 * 2);

    //how long it takes to shift focus to a different section
    Duration changeDuration = Duration(milliseconds: 250);

    //build
    return WillPopScope(
      onWillPop: ()async{
        FocusScope.of(context).unfocus();
        navSpread.value = false;
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
                        navSpread: navSpread,
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
                          child: SaveButton(
                            navSpread: navSpread, 
                            showSaveButton: showSaveButton, 
                            nameError: nameError,
                            //variables
                            namePresent: namePresent, 
                            name: name, 
                            url: url, 
                            note: note, 
                            functionIndex: functionIndex, 
                            repTarget: repTarget, 
                            recoveryPeriod: recoveryPeriod, 
                            setTarget: setTarget, 
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
                      child: BasicEditor(
                        namePresent: namePresent,
                        nameError: nameError,
                        name: name,
                        note: note,
                        url: url,
                      ),
                    ),
                  ),
                  RecoveryTimeCard(
                    changeDuration: changeDuration, 
                    sliderWidth: sliderWidth, 
                    //value notifier below
                    recoveryPeriod: recoveryPeriod, 
                  ),
                  SetTargetCard(
                    setTarget: setTarget,
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      RepTargetCard(
                        changeDuration: changeDuration, 
                        sliderWidth: sliderWidth, 
                        repTargetDuration: repTargetDuration, 
                        repTarget: repTarget,
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
                                bottom: 16,
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
                                  FunctionDropDown(
                                    functionIndex: functionIndex,
                                    functionString: functionString,
                                  ),
                                ],
                              ),
                            ),
                          ]
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FunctionDropDown extends StatefulWidget {
  FunctionDropDown({
    @required this.functionString,
    @required this.functionIndex,
  });

  final ValueNotifier<String> functionString;
  final ValueNotifier<int> functionIndex;

  @override
  _FunctionDropDownState createState() => _FunctionDropDownState();
}

class _FunctionDropDownState extends State<FunctionDropDown> {
  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: widget.functionString.value,
      icon: Icon(Icons.arrow_drop_down),
      isExpanded: true,
      iconSize: 24,
      elevation: 16,
      onChanged: (String newValue) {
        setState(() {
          widget.functionString.value = newValue;
          widget.functionIndex.value = Functions.functionToIndex[widget.functionString.value];
        });
      },
      items: Functions.functions.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      })
      .toList(),
    );
  }
}

class SaveButton extends StatefulWidget {
  const SaveButton({
    Key key,
    @required this.showSaveButton,
    @required this.namePresent,
    @required this.name,
    @required this.url,
    @required this.note,
    @required this.functionIndex,
    @required this.repTarget,
    @required this.recoveryPeriod,
    @required this.setTarget,
    @required this.navSpread,
    @required this.nameError,
  }) : super(key: key);

  final ValueNotifier<bool> showSaveButton;
  final ValueNotifier<bool> namePresent;
  final ValueNotifier<String> name;
  final ValueNotifier<String> url;
  final ValueNotifier<String> note;
  final ValueNotifier<int> functionIndex;
  final ValueNotifier<int> repTarget;
  final ValueNotifier<Duration> recoveryPeriod;
  final ValueNotifier<int> setTarget;
  final ValueNotifier<bool> navSpread;
  final ValueNotifier<bool> nameError;

  @override
  _SaveButtonState createState() => _SaveButtonState();
}

class _SaveButtonState extends State<SaveButton> {

  //so it can be added and removed from listeners
  manualSetState(){
    if(mounted) setState(() {});
  }
  
  @override
  void initState() {
    //add listeners
    widget.showSaveButton.addListener(manualSetState);
    widget.namePresent.addListener(manualSetState);

    //super init
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 250),
      curve: Curves.easeInOut,
      constraints: BoxConstraints(
        //no limit vs limit
        //the 100 is so large its never going to be a limitation
        maxHeight: (widget.showSaveButton.value) ? 100 : 0,
      ),
      child: FittedBox(
        fit: BoxFit.contain,
        child: RaisedButton(
          color: (widget.namePresent.value) 
          ? Theme.of(context).accentColor 
          : Colors.grey,
          onPressed: ()async{
            if(widget.namePresent.value){
              //remove keyboard
              FocusScope.of(context).unfocus();

              //add workout to our list
              await ExcerciseData.addExcercise(
                AnExcercise(
                  //basic
                  name: widget.name.value,
                  url: widget.url.value,
                  note: widget.note.value,

                  //other
                  predictionID: widget.functionIndex.value,
                  repTarget: widget.repTarget.value,
                  recoveryPeriod: widget.recoveryPeriod.value,
                  setTarget: widget.setTarget.value,

                  //---
                  lastTimeStamp: LastTimeStamp.newDateTime(),
                ),
              );

              //exit pop up
              widget.navSpread.value = false;
              Navigator.pop(context);
            }
            else{
              widget.nameError.value = true;
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
  }
}

class RepTargetCard extends StatelessWidget {
  const RepTargetCard({
    Key key,
    @required this.changeDuration,
    @required this.sliderWidth,
    @required this.repTargetDuration,
    @required this.repTarget,
  }) : super(key: key);

  final Duration changeDuration;
  final double sliderWidth;
  final ValueNotifier<Duration> repTargetDuration;
  final ValueNotifier<int> repTarget;

  @override
  Widget build(BuildContext context) {
    return Card(
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
          Container(
            child: Padding(
              padding: const EdgeInsets.only(
                left: 16.0,
              ),
              child: AnimatedRecoveryTimeInfo(
                changeDuration: changeDuration,
                grownWidth: sliderWidth, 
                textHeight: 16, 
                textMaxWidth: 28,
                selectedDuration: repTargetDuration,
                bigTickNumber: 25,
                ranges: [
                  Range(
                    name: "Strength Training",
                    onTap: makeTrainingTypePopUp(
                      context: context,
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
                      context: context,
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
                      context: context,
                      title: "Endurance Training",
                      showEndurance: true,
                      highlightfield: 3,
                    ),
                    left: SliderToolTipButton(
                      buttonText: "13",
                    ),
                    right: SliderToolTipButton(
                      buttonText: "35",
                      tooltipText: "Any More, and we won't be able to estimate your 1 Rep Max",
                    ),
                    startSeconds: (13*5),
                    endSeconds: (35*5),
                  )
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              bottom: 16.0,
              left: 16,
              right: 16,
              top: 8,
            ),
            child: Container(
              color: Theme.of(context).primaryColor,
              height: 2,
              width: MediaQuery.of(context).size.width,
            ),
          ),
          CustomSlider(
            value: repTarget,
            lastTick: 35,
          ),
        ],
      ),
    );
  }
}

class SetTargetCard extends StatelessWidget {
  const SetTargetCard({
    Key key,
    @required this.setTarget,
  }) : super(key: key);

  final ValueNotifier<int> setTarget;

  @override
  Widget build(BuildContext context) {
    return Card(
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
            child: Container(
              child: new HeaderWithInfo(
                title: "Set Target",
                popUp: new SetTargetPopUp(),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.only(
              //Top 16 padding address above
              left: 16,
              right: 16,
            ),
            child: TrainingTypeIndicator(
              setTarget: setTarget,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              top: 8,
              bottom: 16.0,
              left: 16,
              right: 16,
            ),
            child: Container(
              color: Theme.of(context).primaryColor,
              height: 2,
              width: MediaQuery.of(context).size.width,
            ),
          ),
          new CustomSlider(
            value: setTarget,
            lastTick: 9,
          ),
        ]
      ),
    );
  }
}

class RecoveryTimeCard extends StatelessWidget {
  const RecoveryTimeCard({
    Key key,
    @required this.changeDuration,
    @required this.sliderWidth,
    @required this.recoveryPeriod,
  }) : super(key: key);

  final Duration changeDuration;
  final double sliderWidth;
  final ValueNotifier<Duration> recoveryPeriod;

  @override
  Widget build(BuildContext context) {
    return Card(
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
            RecoveryTimeWidget(
              changeDuration: changeDuration, 
              sliderWidth: sliderWidth, 
              textHeight: 16, 
              textMaxWidth: 28, 
              recoveryPeriod: recoveryPeriod, 
            ),
          ],
        ),
      ),
    );
  }
}

class RecoveryTimeWidget extends StatelessWidget {
  const RecoveryTimeWidget({
    Key key,
    @required this.changeDuration,
    @required this.sliderWidth,
    @required this.textHeight,
    @required this.textMaxWidth,
    @required this.recoveryPeriod,
    this.darkTheme: true,
  }) : super(key: key);

  final Duration changeDuration;
  final double sliderWidth;
  final double textHeight;
  final double textMaxWidth;
  final ValueNotifier<Duration> recoveryPeriod;
  final bool darkTheme;

  @override
  Widget build(BuildContext context) {
    //add s? (such a minimal detail)
    int mins = recoveryPeriod.value.inMinutes;
    bool showS = (mins == 1) ? false : true;

    //build
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        FittedBox(
          fit: BoxFit.contain,
          child: AnimatedRecoveryTimeInfo(
            changeDuration: changeDuration,
            grownWidth: sliderWidth, 
            textHeight: textHeight, 
            textMaxWidth: textMaxWidth,
            selectedDuration: recoveryPeriod,
            darkTheme: darkTheme,
            ranges: [
              Range(
                name: "Endurance Training",
                onTap: makeTrainingTypePopUp(
                  context: context,
                  title: "Endurance Training",
                  showEndurance: true,
                  highlightfield: 2,
                ),
                left: new SliderToolTipButton(
                  buttonText: "15s",
                  tooltipText: "Any Less, wouldn't be enough",
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
                  context: context,
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
                  context: context,
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
                  context: context,
                  title: "Strength Training",
                  showStrength: true,
                  highlightfield: 2,
                ),
                left: SliderToolTipButton(
                  buttonText: "3:05",
                ),
                right: SliderToolTipButton(
                  buttonText: "4:55",
                  tooltipText: "Any More, and your muscles would have cooled off",
                ),
                startSeconds: 185,
                endSeconds: 295,
              )
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(
            top: 8,
            bottom: 16.0,
          ),
          child: Container(
            color: Theme.of(context).primaryColor,
            height: 2,
            width: MediaQuery.of(context).size.width,
          ),
        ),
        TimePicker(
          duration: recoveryPeriod,
          darkTheme: darkTheme,
        ),
        MinsSecsBelowTimePicker(
          duration: recoveryPeriod,
          darkTheme: darkTheme,
        ),
      ],
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

    WidgetsBinding.instance.addPostFrameCallback((_){
      controller.animateTo(
        (((MediaQuery.of(context).size.width-48)/4) * section),
        duration: Duration(milliseconds: 250),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void initState() {
    //init
    setTargetToSection();

    //listener
    widget.setTarget.addListener((){
      setTargetToSection();
    });

    //super init
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double tickWidth = 4;
    double totalScreenWidth = MediaQuery.of(context).size.width - 48;
    double totalSliderWidth = (totalScreenWidth/4) * 8;

    double tickSpace = tickWidth * 9;
    double spacerSpace = totalSliderWidth - tickSpace;
    double spacerWidth = spacerSpace / 8;

    List<Widget> ticksAndStuff = new List<Widget>();
    
    //add our first tick
    ticksAndStuff.add(
      Tick(
        tickWidth: tickWidth,
        setTarget: widget.setTarget,
        value: 1,
      ),
    );

    //add spacer then tick 8 times
    for(int i = 0; i < 8; i++){
      //spacer
      ticksAndStuff.add(
        Container(
          width: spacerWidth,
        ),
      );

      //tick
      ticksAndStuff.add(
        Tick(
          tickWidth: tickWidth,
          setTarget: widget.setTarget,
          value: (i+2),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(
        bottom: 16.0,
      ),
      child: Container(
        height: 108, //manually set
        child: Stack(
          children: <Widget>[
            ListView(
              physics: NeverScrollableScrollPhysics(),
              scrollDirection: Axis.horizontal,
              controller: controller,
              children: [
                Stack(
                  children: <Widget>[
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: ticksAndStuff,
                    ),
                    Column(
                      children: <Widget>[
                        Pill(
                          setTarget: widget.setTarget,
                          actives: [4,5,6], 
                          sectionSize: totalScreenWidth/4,
                          name: "Train Strength",
                          onTap: makeTrainingTypePopUp(
                            context: context,
                            title: "Strength Training",
                            showStrength: true,
                            highlightfield: 4,
                          ),
                          leftMultiplier: 2.5,
                          rightMultiplier: 2.5,
                        ),
                        Pill(
                          setTarget: widget.setTarget,
                          actives: [3,4,5], 
                          sectionSize: totalScreenWidth/4,
                          name: "Train Hypertrophy",
                          onTap: makeTrainingTypePopUp(
                            context: context,
                            title: "Hypertrophy Training",
                            showHypertrophy: true,
                            highlightfield: 4,
                          ),
                          leftMultiplier: 1.5,
                          rightMultiplier: 3.5,
                        ),
                        Pill(
                          setTarget: widget.setTarget,
                          actives: [1,2,3], //+1
                          sectionSize: totalScreenWidth/4,
                          name: "Train Endurance",
                          onTap: makeTrainingTypePopUp(
                            context: context,
                            title: "Endurance Training",
                            showEndurance: true,
                            highlightfield: 4,
                          ),
                          leftMultiplier: 0,
                          rightMultiplier: 5.5,
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            Positioned(
              right: 0,
              top: 0,
              bottom: 0,
              child: Center(
                child: Tooltip(
                  message: "You shouldn't do anymore than 6 sets",
                  waitDuration: Duration(milliseconds: 100),
                  preferBelow: false,
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Theme.of(context).primaryColorDark,
                        width: 2,
                      )
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: 4,
                      vertical: 4,
                    ),
                    child: Icon(
                      Icons.warning,
                      color: Theme.of(context).primaryColorDark,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
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
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  width: 2,
                  color: Theme.of(context).primaryColor,
                ),
                color: active ? Theme.of(context).accentColor : Theme.of(context).primaryColor,
              ),
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
                          fontWeight: FontWeight.bold,
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

class Tick extends StatefulWidget {
  const Tick({
    Key key,
    @required this.tickWidth,
    @required this.setTarget,
    @required this.value,
  }) : super(key: key);

  final double tickWidth;
  final ValueNotifier<int> setTarget;
  final int value;

  @override
  _TickState createState() => _TickState();
}

class _TickState extends State<Tick> {
  bool tickActive;

  setTargetToTickActive(){
    tickActive = (widget.setTarget.value == widget.value);
  }

  @override
  void initState() {
    //init
    setTargetToTickActive();

    //update
    widget.setTarget.addListener((){
      setTargetToTickActive();
      setState(() {});
    });

    //super init
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.tickWidth,
      color: (tickActive) ? Theme.of(context).accentColor : Theme.of(context).backgroundColor,
    );
  }
}