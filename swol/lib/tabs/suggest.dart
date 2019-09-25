import 'package:flutter/material.dart';

//plugins
import 'package:auto_size_text/auto_size_text.dart';

class Suggestion extends StatefulWidget {
  @override
  _SuggestionState createState() => _SuggestionState();
}

class _SuggestionState extends State<Suggestion> {
  ValueNotifier<bool> firstTime = new ValueNotifier(false);

  @override
  void initState() { 
    //super init
    super.initState();

    //listen to test look
    firstTime.addListener((){
      setState(() {
        
      });
    });    
  }

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: (){
        firstTime.value = !firstTime.value;
      },
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Expanded(
            child: Container(
              padding: EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  FittedBox(
                    fit: BoxFit.contain,
                    child: Padding(
                      padding: EdgeInsets.only(
                        bottom: 8.0,
                      ),
                      child: DefaultTextStyle(
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                        child: Text("Calibration Set")
                      ),
                    ),
                  ),
                  new CalibStep(
                    number: "1", 
                    text: "Pick ANY Weight you KNOW you can lift for AROUND 10 reps",
                  ),
                  new CalibStep(
                    number: "2",
                    text: "Do as many reps as possible with good form",
                  ),
                  Expanded(
                    child: Container(),
                  )
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              bottom:16.0
            ),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                FlatButton(
                  onPressed: (){
                    Navigator.of(context).pop();
                  },
                  child: Text("Back"),
                ),
                RaisedButton(
                  color: Theme.of(context).accentColor,
                  onPressed: (){
                    print("do thing");
                  },
                  child: Text(
                    "Record Set 1 out of 3",
                    style: TextStyle(
                      color: Theme.of(context).primaryColorDark,
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class CalibStep extends StatelessWidget {
  const CalibStep({
    Key key,
    @required this.number,
    @required this.text,
  }) : super(key: key);

  final String number;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(
        children: <Widget>[
          Column(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(16),
                decoration: new BoxDecoration(
                  color: Theme.of(context).accentColor,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    number,
                    style: TextStyle(
                      color: Theme.of(context).primaryColorDark,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(
                16,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Expanded(
                    child: AutoSizeText(
                      text,
                      softWrap: true,
                      textScaleFactor: 2,
                      maxLines: 3,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}