import 'package:flutter/material.dart';
import 'package:swol/learn/shared.dart';
import 'package:swol/sharedWidgets/trainingTypes/trainingTypes.dart';

class TrainingBody extends StatelessWidget {
  const TrainingBody({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).primaryColorDark,
      child: Column(
        children: <Widget>[
          SectionDescription(
            child: Text(
              "Select a training based on the results you desire\n\n"
              + "But first research the risks, and have a plan to eliminate or minimize them",
            ),
          ),
          AllTrainingTypes(),
        ],
      ),
    );
  }
}