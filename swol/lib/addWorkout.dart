//flutter
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

//internal
import 'package:swol/functions/helper.dart';
import 'package:swol/helpers/addWorkout.dart';
import 'package:swol/helpers/timePicker.dart';
import 'package:swol/utils/data.dart';
import 'package:swol/workout.dart';

//plugins
import 'package:flutter_xlider/flutter_xlider.dart';

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
  ValueNotifier<Duration> recoveryPeriod = new ValueNotifier(Duration(minutes: 1, seconds: 30));

  //set target select
  ValueNotifier<int> setTarget = new ValueNotifier(3);

  //rep target select
  ValueNotifier<int> repTarget = new ValueNotifier(10);

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
    double textMaxWidth = 24;
    double textHeight = 16;

    //denom must match, and 2 items have regular width
    double grownWidth = sliderWidth * (5 / 7);
    double regularWidth = sliderWidth * (1 / 7);

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
                      ClipRRect(
                        borderRadius: new BorderRadius.all(
                          Radius.circular(16.0),
                        ),
                        child: Container(
                          color: Colors.grey.withOpacity(0.25),
                          padding: EdgeInsets.all(0),
                          child: IntrinsicHeight(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: <Widget>[
                                MaterialButton(
                                  color: Theme.of(context).accentColor,
                                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                  padding: EdgeInsets.all(0),
                                  onPressed: (){
                                    Clipboard.getData('text/plain').then((clipboarContent) {
                                      url.value = clipboarContent.text;
                                    });
                                  },
                                  child: Text(
                                    "Paste",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: MaterialButton(
                                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                    padding: EdgeInsets.only(
                                      left: 16,
                                    ),
                                    onPressed: (){
                                      url.value = "";
                                    },
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                        vertical: 8,
                                      ),
                                      alignment: Alignment.centerLeft,
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        children: <Widget>[
                                          Expanded(
                                            child: Text(
                                              (url.value == "") ? 'Tap to paste the link' : url.value,
                                              style: TextStyle(
                                                color: (url.value == "") ? Colors.grey : Colors.white,
                                              ),
                                              overflow: TextOverflow.clip,
                                            ),
                                          ),
                                          Container(
                                            padding: EdgeInsets.only(
                                              right: 8,
                                            ),
                                            child: (url.value == "") 
                                            ? Container()
                                            : Icon(Icons.close),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
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
                          title: "Break Between Sets",
                          popUp: new SetBreakPopUp(),
                        ),
                      ),
                      TimePicker(
                        duration: recoveryPeriod,
                      ),
                      DefaultTextStyle(
                        style: TextStyle(
                          fontWeight: FontWeight.bold
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 24,
                                ),
                                child: FittedBox(
                                  fit: BoxFit.cover,
                                  child: Text(
                                    "MINUTE"
                                    + ((showS) ? "S" : ""),
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              //spacing of columns + width of dots
                              width: (16 * 2) + 16.0,
                            ),
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 24,
                                ),
                                child: FittedBox(
                                  fit: BoxFit.cover,
                                  child: Text("SECONDS"),
                                ),
                              ),
                            ),
                          ],
                        ),
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
                            child: Text("Best For Increasing Muscle"),
                          ),
                        ),
                      ),
                      Center(
                        child: Stack(
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(
                                top: 16.0,
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  AnimatedContainer(
                                    duration: changeDuration,
                                    width: (sectionGrown == 0) ? grownWidth : regularWidth,
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: (sectionGrown == 0) ? 16 : 0,
                                      ),
                                      child: FittedBox(
                                        fit: BoxFit.fitWidth,
                                        child: Text("ENDURANCE"),
                                      ),
                                    ),
                                  ),
                                  AnimatedContainer(
                                    duration: changeDuration,
                                    width: (sectionGrown == 1) ? grownWidth : regularWidth,
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: (sectionGrown == 1) ? 16 : 0,
                                      ),
                                      child: FittedBox(
                                        fit: BoxFit.fitWidth,
                                        child: Text("\t\t\t\tMASS\t\t\t\t"),
                                      ),
                                    ),
                                  ),
                                  AnimatedContainer(
                                    duration: changeDuration,
                                    width: (sectionGrown == 2) ? grownWidth : regularWidth,
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: (sectionGrown == 2) ? 16 : 0,
                                      ),
                                      child: FittedBox(
                                        fit: BoxFit.fitWidth,
                                        child: Text("STRENGTH"),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  height: textHeight,
                                  width: textMaxWidth,
                                  child: FittedBox(
                                    fit: BoxFit.fitHeight,
                                    child: Center(
                                      child: Text("0s\t\t"),
                                    ),
                                  ),
                                ),
                                AnimatedContainer(
                                  duration: changeDuration,
                                  constraints: BoxConstraints(
                                    maxWidth: ((sectionGrown == 0) ? grownWidth : regularWidth)
                                    //remove the left number fully from here
                                    - textMaxWidth
                                    //and the right number half from here
                                    - (textMaxWidth / 2),
                                  ),
                                ),
                                Container(
                                  height: textHeight,
                                  width: textMaxWidth,
                                  child: FittedBox(
                                    fit: BoxFit.fitHeight,
                                    child: Center(
                                      child: Text("30s"),
                                    ),
                                  ),
                                ),
                                AnimatedContainer(
                                  duration: changeDuration,
                                  constraints: BoxConstraints(
                                    maxWidth: ((sectionGrown == 1) ? grownWidth : regularWidth)
                                    //the left and right numbers removed half from here
                                    - textMaxWidth,
                                  ),
                                ),
                                Container(
                                  height: textHeight,
                                  width: textMaxWidth,
                                  child: FittedBox(
                                    fit: BoxFit.fitHeight,
                                    child: Center(
                                      child: Text("90s"),
                                    ),
                                  ),
                                ),
                                AnimatedContainer(
                                  duration: changeDuration,
                                  constraints: BoxConstraints(
                                    maxWidth: ((sectionGrown == 2) ? grownWidth : regularWidth)
                                    //remove the right number fully from here
                                    - textMaxWidth
                                    //and the left number half from here
                                    - (textMaxWidth / 2),
                                  ),
                                ),
                                Container(                                  
                                  height: textHeight,
                                  width: textMaxWidth,
                                  child: FittedBox(
                                    fit: BoxFit.fitHeight,
                                    child: Center(
                                      child: Text("5m"),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
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
                    Stack(
                      alignment: AlignmentDirectional.bottomCenter,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(
                            bottom: 14.75, //TODO: adjust for final product
                            left: 16,
                            right: 16,
                          ),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).accentColor,
                                    border: Border.all(
                                      width: 2, 
                                      color: Colors.black,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  height: 16,
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).backgroundColor,
                                    border: Border.all(
                                      width: 2, 
                                      color: Colors.black,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  height: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          child: FlutterSlider(
                            step: 1,
                            jump: true,
                            //TODO: set to our default value
                            values: [8],
                            min: 1,
                            max: 35,
                            handlerWidth: 35,
                            handlerHeight: 35,
                            touchSize: 35,
                            handlerAnimation: FlutterSliderHandlerAnimation(
                              scale: 1.25,
                            ),
                            handler: FlutterSliderHandler(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Theme.of(context).primaryColorDark,
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                child: Center(
                                  child: Icon(
                                    Icons.repeat, 
                                    size: 25,
                                  ),
                                ),
                              ),
                              foregroundDecoration: BoxDecoration()
                            ),
                            tooltip: FlutterSliderTooltip(
                              alwaysShowTooltip: true,
                              textStyle: TextStyle(fontSize: 17, color: Colors.white),
                              boxStyle: FlutterSliderTooltipBox(
                                decoration: BoxDecoration(
                                  color: Colors.redAccent.withOpacity(0.7)
                                )
                              ),
                              rightSuffix: Text(" reps"),
                            ),
                            trackBar: FlutterSliderTrackBar(
                              activeTrackBarHeight: 16,
                              inactiveTrackBarHeight: 16,
                              //NOTE: They need their own outline to cover up mid division of background
                              inactiveTrackBar: BoxDecoration(
                                color: Theme.of(context).backgroundColor,
                                border: Border(
                                  top: BorderSide(width: 2, color: Colors.black),
                                  bottom: BorderSide(width: 2, color: Colors.black),
                                ),
                              ),
                              activeTrackBar: BoxDecoration(
                                color: Theme.of(context).accentColor,
                                border: Border(
                                  top: BorderSide(width: 2, color: Colors.black),
                                  bottom: BorderSide(width: 2, color: Colors.black),
                                ),
                              ),
                            ),
                            //NOTE: hatch marks don't work unfortunately
                            onDragging: (handlerIndex, lowerValue, upperValue) {
                              /*
                              _lowerValue = lowerValue;
                              _upperValue = upperValue;
                              */
                              setState(() {});
                            },
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: EdgeInsets.only(
                        //Top 98 padding address above
                        left: 16,
                        right: 16,
                        bottom: 16,
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
                          Padding(
                            padding: EdgeInsets.only(
                              top: 16,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: <Widget>[
                                Transform.translate(
                                  offset: Offset(-16, 0),
                                  child: Container(
                                    height: 36,
                                    width: 48.0 + (16 * 2),
                                    padding: EdgeInsets.only(
                                      right: 16,
                                      left: 8,
                                    ),
                                    child: HorizontalPicker(
                                      setTarget: setTarget,
                                      height: 36,
                                      numberSize: 24,
                                    ),
                                  ),
                                ),
                                Transform.translate(
                                  offset: Offset(-24, 0),
                                  child: Text(
                                    "Set Target",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    alignment: Alignment.centerRight,
                                    child: Transform.translate(
                                      offset: Offset(12, 0),
                                      child: IconButton(
                                        onPressed: (){
                                          showDialog<void>(
                                            context: context,
                                            barrierDismissible: true,
                                            builder: (BuildContext context) {
                                              return new SetTargetPopUp(); 
                                            },
                                          );
                                        },
                                        icon: Icon(Icons.info),
                                        color: Theme.of(context).accentColor,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
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

class TextFieldWithClearButton extends StatelessWidget {
  const TextFieldWithClearButton({
    Key key,
    @required this.ctrl,
    @required this.focusnode,
    @required this.hint,
    @required this.error,
    @required this.present,
    this.otherFocusNode,
  }) : super(key: key);

  final TextEditingController ctrl;
  final FocusNode focusnode;
  final String hint;
  final String error;
  final ValueNotifier<bool> present;
  final FocusNode otherFocusNode;

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Stack(
        children: <Widget>[
          TextField(
            controller: ctrl,
            focusNode: focusnode,
            maxLines: (otherFocusNode == null) ? null : 1,
            minLines: (otherFocusNode == null) ? 2 : 1,
            keyboardType: TextInputType.text,
            textInputAction: (otherFocusNode == null) 
            ? TextInputAction.newline
            : TextInputAction.next,
            decoration: InputDecoration(
              hintText: hint,
              errorText: error,
              //spacer so X doesn't cover the text
              suffix: Container(
                width: 36,
              )
            ),
            onEditingComplete: (){
              if(otherFocusNode != null){
                FocusScope.of(context).requestFocus(otherFocusNode);
              }
            },
          ),
          Positioned(
            right: 0,
            top: 0,
            bottom: 0,
            child: Transform.translate(
              offset: Offset(8, 0),
              child: IconButton(
                onPressed: (){
                  ctrl.text = "";
                },
                color: Colors.grey, 
                highlightColor: Colors.grey,
                icon: Icon(
                  Icons.close,
                  color: (present.value) ? Colors.grey : Colors.transparent,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}