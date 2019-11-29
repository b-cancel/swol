import 'package:flutter/material.dart';
import 'package:swol/excerciseAction/tabs/sharedWidgets/bottomButtons.dart';

class SetRecord extends StatelessWidget {
  SetRecord({
    @required this.excerciseID,
    @required this.backToSuggestion,
    @required this.setBreak,
  });

  final int excerciseID;
  final Function backToSuggestion;
  final Function setBreak;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      color: Colors.green,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            child: Container(),
          ),
          BottomButtons(
            forwardAction: setBreak,
            forwardActionWidget: Text(
              "Take Set Break",
              style: TextStyle(
                color: Theme.of(context).primaryColorDark,
              ),
            ),
            backAction: backToSuggestion,
          )
        ],
      ),
    );
  }
}