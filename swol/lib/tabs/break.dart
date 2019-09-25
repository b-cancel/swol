import 'package:flutter/material.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:swol/helpers/break.dart';
import 'package:swol/helpers/timePicker.dart';

class Break extends StatefulWidget {
  Break({
    @required this.recoveryDuration,
  });

  final ValueNotifier<Duration> recoveryDuration;

  @override
  _BreakState createState() => _BreakState();
}

class _BreakState extends State<Break> with SingleTickerProviderStateMixin {
  //primary vars
  DateTime timerStart;

  //before changing fullDuration we let the picker change this
  ValueNotifier<Duration> possibleFullDuration = new ValueNotifier(Duration.zero);

  //init
  @override
  void initState() {
    //TODO: use the timer start of the object
    //record the time the timer started
    timerStart = DateTime.now();

    //super init
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //size the liquid loader
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    double size = (width < height) ? width : height;

    //build
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(16),
              child: OutlineButton(
                borderSide: BorderSide(
                  color: Theme.of(context).primaryTextTheme.caption.color,
                  width: 2,
                ),
                onPressed: (){
                  possibleFullDuration.value = widget.recoveryDuration.value;

                  showDialog<void>(
                    context: context,
                    barrierDismissible: true,
                    builder: (BuildContext context) {
                      return Theme(
                        data: ThemeData.light(),
                        child: AlertDialog(
                          title: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                "Change Break Time",
                              ),
                              Text(
                                "Don't Worry! The Timer Won't Reset",
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12,
                                ),
                              )
                            ],
                          ),
                          content: Container(
                            child: TimePicker(
                              duration: possibleFullDuration,
                              darkTheme: false,
                            ),
                          ),
                          actions: <Widget>[
                            FlatButton(
                              onPressed: (){
                                Navigator.pop(context);
                              },
                              child: Text("Cancel"),
                            ),
                            RaisedButton(
                              onPressed: (){
                                widget.recoveryDuration.value = possibleFullDuration.value;
                                Navigator.pop(context);
                              },
                              child: Text(
                                "Change",
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            )
                          ],
                        ),
                      ); 
                    },
                  );
                },
                child: Text("Change Break Time"),
              ),
            ),
            Expanded(
              child: Center(
                child: Container(
                  height: size,
                  width: size,
                  padding: EdgeInsets.all(24),
                  child: AnimLiquidIndicator(
                    durationFull: widget.recoveryDuration,
                    timerStart: timerStart,
                    //size of entire bubble = size container - padding for each size
                    centerSize: size - (24 * 2),
                  ),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  FlatButton(
                    onPressed: (){
                      Navigator.pop(context);
                    },
                    child: Text("Back"),
                  ),
                  //both paddings + button size
                  //height: (16 * 2) + 48.0,
                  RaisedButton(
                    color: Theme.of(context).accentColor,
                    textColor: Theme.of(context).primaryColor,
                    onPressed: (){
                      Navigator.pop(context);
                    },
                    child: Text("Next Set"),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}