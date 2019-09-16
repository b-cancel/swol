import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
          children: <Widget>[
            Flexible(
              child: TextField(
                controller: nameCtrl,
                focusNode: nameFN,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(
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