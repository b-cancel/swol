//flutter
import 'package:flutter/material.dart';
import 'package:swol/shared/methods/theme.dart';

//internal
import 'package:swol/shared/widgets/complex/fields/fields/setTarget/trainingTypes.dart';
import 'package:swol/shared/widgets/complex/fields/headers/fieldHeader.dart';
import 'package:swol/shared/widgets/simple/ourSlider.dart';
import 'package:swol/shared/widgets/simple/toLearnPage.dart';
import 'package:swol/trainingTypes/trainingTypes.dart';

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
            padding: EdgeInsets.symmetric(
              horizontal: 16,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SetTargetHeader(),
                SetTargetToTrainingTypeIndicator(
                  setTarget: setTarget,
                  wholeWidth: MediaQuery.of(context).size.width,
                  oneSidePadding: 16 + 8.0,
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    bottom: 16.0,
                  ),
                  child: Container(
                    color: Colors.black, //line color
                    height: 2,
                    width: MediaQuery.of(context).size.width,
                  ),
                ),
              ],
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

class SetTargetHeader extends StatelessWidget {
  const SetTargetHeader({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: MyTheme.light,
      child: HeaderWithInfo(
        header: "Set Target",
        title: "Set Target",
        subtitle: "Not sure? Keep the default",
        body: SetTargetPopUpBody(),
      ),
    );
  }
}

class SetTargetPopUpBody extends StatelessWidget {
  const SetTargetPopUpBody({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
          ),
          child: RichText(
            text: TextSpan(
              style: TextStyle(
                color: Colors.black,
              ),
              children: [
                TextSpan(
                  text: "Select a ",
                ),
                TextSpan(
                  text: "set target",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  )
                ),
                TextSpan(
                  text: " for the ",
                ),
                TextSpan(
                  text: "training type",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  )
                ),
                TextSpan(
                  text: " you are working towards"
                ),
              ]
            ),
          ),
        ),
        Theme(
          data: ThemeData.dark(),
          child: Container(
              color: Colors.white,
              width: MediaQuery.of(context).size.width,
              child: AllTrainingTypes(
                lightMode: true,
                highlightField: 4,
              ),
            ),
        ),
        SuggestToLearnPage(),
      ],
    );
  }
}