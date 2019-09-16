import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:swol/functions/helper.dart';
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
  String errorText;

  int dropdownIndex = defaultFunctionIndex;
  String dropdownValue = functions[defaultFunctionIndex];

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

    //super init
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData.light(),
      child: AlertDialog(
        title: Text('Add New Workout'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Flexible(
              child: TextField(
                controller: nameCtrl,
                focusNode: nameFN,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(
                  labelText: "Workout Name",
                  errorText: errorText,
                  suffix: Transform.translate(
                    offset: Offset(0, 8),
                    child: InkWell(
                      onTap: (){
                        nameCtrl.text = "";
                      },
                      child: Container(
                        height: 24,
                        width: 24,
                        padding: EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: (namePresent.value) ? Colors.grey : Colors.transparent,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.close,
                          size: 20,
                          color: (namePresent.value) ? Colors.white : Colors.transparent,
                        )
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(
                top: 16,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    "Initial Prediction Formula",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    onPressed: (){
                      showDialog<void>(
                        context: context,
                        barrierDismissible: true,
                        builder: (BuildContext context) {
                          return Theme(
                            data: ThemeData.light(),
                            child: SimpleDialog(
                              title: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Padding(
                                    padding: EdgeInsets.only(
                                      right: 4,
                                    ),
                                    child: Icon(
                                      Icons.info,
                                      color: Colors.blue,
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        Container(
                                          alignment: Alignment.centerLeft,
                                          child: Text("Prediction Formulas"),
                                        ),
                                        Container(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            "Not sure? Keep the default\n",
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.black,
                                              fontWeight: FontWeight.normal,
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  Transform.translate(
                                    offset: Offset(0, -12),
                                    child: IconButton(
                                      onPressed: (){
                                        Navigator.pop(context);
                                      },
                                      icon: Icon(Icons.close),
                                    ),
                                  )
                                ],
                              ),
                              children: <Widget>[
                                Container(
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
                              ],
                            ),
                          );
                        },
                      );
                    },
                    icon: Icon(Icons.info),
                    color: Colors.blue,
                  )
                ],
              ),
            ),
            DropdownButton<String>(
              value: dropdownValue,
              icon: Icon(Icons.arrow_drop_down),
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
          ],
        ),
        actions: <Widget>[
          FlatButton(
            child: Text('Close'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          RaisedButton(
            color: (namePresent.value) ? Colors.blue : Colors.grey,
            onPressed: (){
              if(namePresent.value){
                //add workout to our list
                addWorkout(Workout(
                  name: nameCtrl.text,
                  //we do this so that we still get the new keyword
                  //but the newer workouts still pop up on top
                  timeStamp: DateTime.now().subtract(Duration(days: 365 * 100)),
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
              "Add",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MyDivider extends StatelessWidget {
  const MyDivider({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: 16,
        bottom: 8,
      ),
      child: Divider(
        height: 0,
      ),
    );
  }
}