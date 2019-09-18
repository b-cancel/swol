import 'package:flutter/material.dart';

import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';
import 'package:swol/helpers/break.dart';

class Break extends StatefulWidget {
  Break({
    @required this.startDuration,
  });

  final Duration startDuration;

  @override
  _BreakState createState() => _BreakState();
}

class _BreakState extends State<Break> with SingleTickerProviderStateMixin {
  ValueNotifier<Duration> fullDuration;
  DateTime timerStart;
  //we start fill because we are getting rid of lactate
  ValueNotifier<double> indicatorFill = new ValueNotifier(1);

  @override
  void initState() {
    //record the time the timer started
    timerStart = DateTime.now();

    //set the duration
    fullDuration = new ValueNotifier(widget.startDuration);

    //super init
    super.initState();

    //start the "timer"
    reload();
  }

  //NOTE: we only really care about seconds / 1,000 milliseconds
  //sadly when doing async processes you can't exactly guarantee
  //thing will reload exactly every 1,000 milliseconds
  //so for the sake of simplicity we update every 100 milliseconds
  reload()async{
    Future.delayed(Duration(milliseconds: 1),(){
      //possible update second
      double tempIndicatorFill;
      Duration timeSince = DateTime.now().difference(timerStart);
      if(timeSince.inSeconds == 0) tempIndicatorFill = 1;
      else if(timeSince >= fullDuration.value) tempIndicatorFill = 0;
      else{
        tempIndicatorFill = 1 - (timeSince.inSeconds/ fullDuration.value.inSeconds);
      }

      //indeed update things
      if(indicatorFill.value != tempIndicatorFill){
        indicatorFill.value = tempIndicatorFill;
        setState(() {});
      }
      
      //continue doing so every so often
      reload();
    });
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
                  print("hi");
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
                    indicatorFill: indicatorFill,
                  ),
                  
                  
                  /*LiquidCircularProgressIndicator(
                    value: indicatorFill,
                    backgroundColor: Colors.white, // Defaults to the current Theme's backgroundColor.
                    borderColor: Colors.transparent,
                    borderWidth: 0,
                    direction: Axis.vertical, // The direction the liquid moves (Axis.vertical = bottom to top, Axis.horizontal = left to right). Defaults to Axis.vertical.
                  ),
                  */
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