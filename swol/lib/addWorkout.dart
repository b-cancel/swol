import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:swol/functions/helper.dart';
import 'package:swol/helpers/addWorkout.dart';
import 'package:swol/utils/data.dart';
import 'package:swol/workout.dart';
import 'package:flutter_picker/flutter_picker.dart';

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
  int minutes = 1;
  int seconds = 45;

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

    //super init
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add New Workout'),
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
                    //weight
                    //reps
                    wait: Duration(minutes: minutes, seconds: seconds),
                    //sets
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
        padding: EdgeInsets.only(
          bottom: 24,
        ),
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(
              left: 24,
              top: 24,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
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
                            labelText: "Workout Name",
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
                  padding: EdgeInsets.only(
                    top: 16,
                  ),
                  child: new HeaderWithInfo(
                    title: "Initial Preduction Formula",
                    popUp: MyInfoDialog(
                      title: "Prediction Formulas",
                      subtitle: "Not sure? Keep the default",
                      child: Container(
                        padding: EdgeInsets.only(
                          left: 32,
                          right: 32,
                          bottom: 16,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "These formulas were originally used to calculate an individual's 1 rep max\n",
                              ),
                            ),
                            Container(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "But you can also use them to determine what your next set should be",
                              ),
                            ),
                            new MyDivider(),
                            Container(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Assming that you have both\n",
                              ),
                            ),
                            Container(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "1. Kept proper form",
                              ),
                            ),
                            Container(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "2. And taken an appropiate break between sets",
                              ),
                            ),
                            new MyDivider(),
                            //
                            Container(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Which formula works best for you depends on"
                                + " how much your nervous system is limiting you" 
                                + " for a particular excercise",
                              ),
                            ),
                            new MyDivider(),
                            //
                            Container(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Exercises that use MORE muscle will put MORE strain on your nervous system\n",
                              ),
                            ),
                            Container(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Exercises that use LESS muscle will put LESS strain on your nervous system",
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    right: 24,
                  ),
                  child: DropdownButton<String>(
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
                ),
                Transform.translate(
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
                            child: IconButton(
                              onPressed: (){
                                showDialog<void>(
                                  context: context,
                                  barrierDismissible: true,
                                  builder: (BuildContext context) {
                                    return MyInfoDialog(
                                      title: "Auto Update",
                                      subtitle: "Not sure? Keep the default",
                                      child: Container(
                                        padding: EdgeInsets.only(
                                          left: 32,
                                          right: 32,
                                          bottom: 16,
                                        ),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: <Widget>[
                                            Container(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                "As mentioned in the previous pop up,"
                                                  + " which formula works best for you depends on"
                                                  + " how much your nervous system is limiting you" 
                                                  + " for a particular excercise",
                                              ),
                                            ),
                                            new MyDivider(),
                                            Container(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                "But the forumla that you decided to use initally might not be accurately predicting real world results",
                                              ),
                                            ),
                                            new MyDivider(),
                                            Container(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                "Which would mean that your nervous system is limiting you more or less than you initially expected",
                                              ),
                                            ),
                                            new MyDivider(),
                                            Container(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                "So by enabling this, you allow the us to switch to a formula that matches your results after each set",
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ); 
                                  },
                                );
                              },
                              icon: Icon(Icons.info),
                              color: Theme.of(context).accentColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(
                    top: 16,
                  ),
                  child: HeaderWithInfo(
                    title: "Form Reference Link",
                    popUp: MyInfoDialog(
                      title: "Form Reference Link",
                      child: Container(
                        padding: EdgeInsets.only(
                          left: 32,
                          right: 32,
                          bottom: 16,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Form is incredibly important!"
                              ),
                            ),
                            new MyDivider(),
                            Container(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Especially as you're approaching your 1 rep max, if you form isn't perfect you could get permanently injured!",
                              ),
                            ),
                            new MyDivider(),
                            Container(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "So it's a good idea to keep a link to a video or picture of the proper form of each excercise, especially when you are starting",
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    right: 24,
                  ),
                  child: ClipRRect(
                    borderRadius: new BorderRadius.all(
                      Radius.circular(45.0),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.25),
                        borderRadius: new BorderRadius.all(
                          Radius.circular(45.0),
                        ),
                      ),
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
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.only(
              top: 16,
              left: 24,
            ),
            child: HeaderWithInfo(
              title: "Break Between Sets",
              popUp: MyInfoDialog(
                title: "Set Break",
                subtitle: "Not sure? Keep the default",
                child: Container(
                  padding: EdgeInsets.only(
                    left: 32,
                    right: 32,
                    bottom: 16,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "You need to give your muscles time to recover!"
                        ),
                      ),
                      MyDivider(),
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Exactly how much rest depends on two things\n",
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "1. How you specifically want to improve",
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "2. And how much muscle this particular excercise uses",
                        ),
                      ),
                      MyDivider(),
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Exercises that use MORE muscle will put require LONGER breaks\n",
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Exercises that use LESS muscle will put require SHORTER breaks",
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              left: 24,
              right: 24
            ),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Expanded(
                  child: Center(child: Text("Minutes")),
                ),
                Container(
                  //spacing of columns + width of dots
                  width: (24 * 2) + 16.0,
                ),
                Expanded(
                  child: Center(child: Text("Seconds")),
                ),
              ],
            ),
          ),
          Picker(
            hideHeader: true,
            looping: false,
            backgroundColor: Theme.of(context).canvasColor,
            containerColor: Theme.of(context).canvasColor,
            delimiter: [
              PickerDelimiter(
                child: Center(
                  child: Container(
                    height: 80,
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          width: 16,
                          height: 16,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                          ),
                        ),
                        Container(
                          width: 16,
                          height: 16,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    )
                  ),
                ),
              ),
            ],
            height: 100,
            selecteds: [minutes,secondOptions.indexOf(seconds)],
            onSelect: (Picker picker, int index, List<int> ints){
              //TODO: to string these 2 individually
              print(picker.getSelectedValues());
              List selections = picker.getSelectedValues();
              minutes = int.parse(selections[0]);
              seconds = int.parse(selections[1]);
            },
            adapter: PickerDataAdapter<String>(
              pickerdata: new JsonDecoder().convert(Times),
              isArray: true,
            ),
            columnPadding: EdgeInsets.symmetric(
              horizontal:24,
            ),
            //---still being messed
            textStyle: TextStyle(
              color: Theme.of(context).primaryTextTheme.title.color,
            ),
            selectedTextStyle: TextStyle(
              color: Theme.of(context).primaryTextTheme.title.color,
              fontSize: 48,
            ),
            //textScaleFactor: 2,
            itemExtent: 48,
          ).makePicker(),
        ],
      ),
    );
  }
}

const List<int> secondOptions = [
   0, 5, 10, 15, 20, 25,
   30, 35, 40, 45, 50, 55
];

const Times = '''
[
    [0, 1, 2, 3, 4, 5],
    [
      0, 5, 10, 15, 20, 25,
      30, 35, 40, 45, 50, 55
    ]
]
''';