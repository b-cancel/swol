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
  bool autoUpdateEnabled = true;

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
        contentPadding: EdgeInsets.only(
          left: 24,
          bottom: 24,
          top: 24,
        ),
        content: Container(
          width: double.maxFinite,
          child: ListView(
            shrinkWrap: true,
            children: <Widget>[
              Column(
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
                                color: Colors.grey, //namePresent.value) ? Colors.grey : Colors.transparent,
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
                                      return  MyInfoDialog(
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
                                color: Colors.blue,
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
                  functionID: dropdownIndex,
                  autoUpdatePrediction: autoUpdateEnabled,
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

class HeaderWithInfo extends StatelessWidget {
  const HeaderWithInfo({
    Key key,
    @required this.title,
    @required this.popUp,
  }) : super(key: key);

  final String title;
  final Widget popUp;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        right: 12,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            title,
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
                  return popUp; 
                },
              );
            },
            icon: Icon(Icons.info),
            color: Colors.blue,
          )
        ],
      ),
    );
  }
}

class MyInfoDialog extends StatelessWidget {
  const MyInfoDialog({
    @required this.title,
    this.subtitle: "",
    @required this.child,
    Key key,
  }) : super(key: key);

  final String title;
  final String subtitle;
  final Widget child;

  @override
  Widget build(BuildContext context) {
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
                    child: Text(title),
                  ),
                  (subtitle == "") ? Container()
                  : Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      subtitle,
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
          child,
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