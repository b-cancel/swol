import 'package:flutter/material.dart';
import 'package:swol/excerciseAction/tabs/sharedWidgets/bottomButtons.dart';
import 'package:swol/excerciseAction/tabs/suggest/suggest.dart';

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
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(24),
                        bottomRight: Radius.circular(24),
                      ),
                    ),
                    padding: EdgeInsets.all(16),
                    child: Container(
                      color: Colors.red,
                    ),
                  ),
                ),
                BottomButtonPadding(),
              ],
            ),
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