//flutter
import 'package:flutter/material.dart';
import 'package:swol/excerciseAddition/popUps/popUpFunctions.dart';

//internal from addition
import 'package:swol/excerciseAddition/secondary/trainingTypeHelpers.dart';

//internal from shared
import 'package:swol/sharedWidgets/informationDisplay.dart';
import 'package:swol/sharedWidgets/mySlider.dart';

class SetTargetCard extends StatelessWidget {
  const SetTargetCard({
    Key key,
    @required this.setTarget,
  }) : super(key: key);

  final ValueNotifier<int> setTarget;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(
              //Top 16 padding address above
              left: 16,
              right: 16,
            ),
            child: Container(
              child: new HeaderWithInfo(
                title: "Set Target",
                popUpFunction: () => setTargetPopUp(context),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.only(
              //Top 16 padding address above
              left: 16,
              right: 16,
            ),
            child: TrainingTypeIndicator(
              setTarget: setTarget,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              top: 8,
              bottom: 16.0,
              left: 16,
              right: 16,
            ),
            child: Container(
              color: Theme.of(context).primaryColor,
              height: 2,
              width: MediaQuery.of(context).size.width,
            ),
          ),
          new CustomSlider(
            value: setTarget,
            lastTick: 9,
          ),
        ]
      ),
    );
  }
}