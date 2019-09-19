//flutter
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

//internal
import 'package:swol/functions/helper.dart';
import 'package:swol/helpers/addWorkout.dart';
import 'package:swol/helpers/timePicker.dart';
import 'package:swol/utils/data.dart';
import 'package:swol/workout.dart';

class AddWorkout extends StatefulWidget {
  const AddWorkout({
    @required this.workoutsKey,
    Key key,
  }) : super(key: key);

  final GlobalKey<AnimatedListState> workoutsKey;

  @override
  _AddWorkoutState createState() => _AddWorkoutState();
}

class _AddWorkoutState extends State<AddWorkout> {
  TextEditingController nameCtrl = new TextEditingController();
  FocusNode nameFN = new FocusNode();
  ValueNotifier<bool> namePresent = new ValueNotifier(false);
  ValueNotifier<String> url = new ValueNotifier("");
  String errorText;
  int dropdownIndex = defaultFunctionIndex;
  String dropdownValue = functions[defaultFunctionIndex];
  bool autoUpdateEnabled = true;
  ValueNotifier<Duration> breakTime = new ValueNotifier(Duration(minutes: 1, seconds: 30));
  ValueNotifier<int> setTarget = new ValueNotifier(3);

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

    //when url change we update
    url.addListener((){
      setState(() {});
    });

    //update when break updates
    breakTime.addListener((){
      setState(() {});
    });

    //super init
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //cal best for
    String bestFor = "Best For Increasing Muscle ";
    if(breakTime.value <= Duration(seconds: 30)) bestFor += "Endurance";
    else if(breakTime.value <= Duration(seconds: 90)) bestFor += "Mass";
    else if(breakTime.value <= Duration(minutes: 5)) bestFor += "Strength";
    else bestFor = "This Break Is Way Too Long";

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
                  addWorkout(Workout(
                    name: nameCtrl.text,
                    functionID: dropdownIndex,
                    //we do this so that we still get the new keyword
                    //but the newer workouts still pop up on top
                    timeStamp: DateTime.now().subtract(Duration(days: 365 * 100)),
                    url: url.value,
                    //NOTE: we dont add these because the whole point of the app is that you don't set these
                    //Your bodies limits
                    //and the equations set them
                    //weight
                    //reps
                    wait: breakTime.value,
                    sets: setTarget.value,
                    autoUpdatePrediction: autoUpdateEnabled,
                  ));

                  //insert the item into the list
                  widget.workoutsKey.currentState.insertItem(0);

                  //exit pop up
                  Navigator.pop(context);
                }
                else{
                  errorText = "Name Is Required";
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
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Excercise Name",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Flexible(
                        child: Stack(
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.only(
                                right: 24,
                              ),
                              child: TextField(
                                controller: nameCtrl,
                                focusNode: nameFN,
                                keyboardType: TextInputType.text,
                                textInputAction: TextInputAction.done,
                                decoration: InputDecoration(
                                  hintText: "Required*",
                                  errorText: errorText,
                                  //spacer so X doesn't cover the text
                                  suffix: Container(
                                    width: 36,
                                  )
                                ),
                              ),
                            ),
                            Positioned(
                              right: 0,
                              top: 0,
                              bottom: 0,
                              child: Transform.translate(
                                offset: Offset(-16, 8),
                                child: Container(
                                  width: 42,
                                  alignment: Alignment.center,
                                  child: IconButton(
                                    onPressed: (){
                                      nameCtrl.text = "";
                                    },
                                    color: Colors.grey, 
                                    highlightColor: Colors.grey,
                                    icon: Icon(
                                      Icons.close,
                                      color: (namePresent.value) ? Colors.grey : Colors.transparent,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        child: HeaderWithInfo(
                          title: "Form Reference Link",
                          popUp: new FormReferencePopUp(),
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
                        duration: breakTime,
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
                                  child: Text("MINUTES"),
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
                      Container(
                        padding: EdgeInsets.only(
                          top: 16,
                        ),
                        child: Text(bestFor),
                      ),
                      //divide between two somewhat dense fields
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
                      //NOTE: we know that this is naturally of height 48
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
                                child: SetPicker(
                                  setTarget: setTarget,
                                  height: 36,
                                  numberSize: 24,
                                ),
                              ),
                            ),
                            Transform.translate(
                              offset: Offset(-24, 0),
                              child: Text(
                                "Initial Set Target",
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
                        child: new HeaderWithInfo(
                          title: "Initial Prediction Formula",
                          popUp: new PredictionFormulasPopUp(),
                        ),
                      ),
                      DropdownButton<String>(
                        value: dropdownValue,
                        icon: Icon(Icons.arrow_drop_down),
                        isExpanded: true,
                        iconSize: 24,
                        elevation: 16,
                        onChanged: (String newValue) {
                          setState(() {
                            dropdownValue = newValue;
                            dropdownIndex = functionToIndex[dropdownValue];
                            print("index: " + dropdownIndex.toString());
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
                      Transform.translate(
                        //so the switch is where it should be
                        offset: Offset(-12, 0),
                        child: Container(
                          padding: EdgeInsets.only(
                            top: 16,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              Switch(
                                value: autoUpdateEnabled,
                                onChanged: (value) {
                                  setState(() {
                                    autoUpdateEnabled = value;
                                  });
                                },
                              ),
                              Text(
                                "Auto Update Prediction",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  alignment: Alignment.centerRight,
                                  child: Transform.translate(
                                    //so the info is where it should be
                                    offset: Offset(24, 0),
                                    child: IconButton(
                                      onPressed: (){
                                        showDialog<void>(
                                          context: context,
                                          barrierDismissible: true,
                                          builder: (BuildContext context) {
                                            return new AutoUpdatePopUp(); 
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
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}