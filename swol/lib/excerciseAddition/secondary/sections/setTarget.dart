//flutter
import 'package:flutter/material.dart';

//internal
import 'package:swol/shared/widgets/complex/fields/headers/headerWithInfoButton.dart';
import 'package:swol/excerciseAddition/secondary/trainingTypes.dart';
import 'package:swol/shared/widgets/simple/ourSlider.dart';

//widget
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
            child: SetTargetHeader(),
          ),
          Container(
            padding: EdgeInsets.only(
              //Top 16 padding address above
              left: 16,
              right: 16,
            ),
            child: SetTargetToTrainingTypeIndicator(
              setTarget: setTarget,
              wholeWidth: MediaQuery.of(context).size.width,
              oneSidePadding: 16 + 8.0,
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
              color: Colors.black, //line color
              height: 2,
              width: MediaQuery.of(context).size.width,
            ),
          ),
          CustomSlider(
            value: setTarget,
            lastTick: 9,
          ),
        ]
      ),
    );
  }
}