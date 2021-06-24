//flutter
import 'package:flutter/material.dart';

//internal
import 'package:swol/shared/widgets/complex/fields/fields/sliders/setTarget/trainingTypes.dart';
import 'package:swol/shared/widgets/complex/fields/fields/sliders/sliderField.dart';
import 'package:swol/shared/widgets/complex/fields/headers/fieldHeader.dart';
import 'package:swol/shared/widgets/complex/trainingTypeTables/trainingTypes.dart';
import 'package:swol/shared/widgets/simple/toLearnPage.dart';
import 'package:swol/shared/methods/theme.dart';

//widget
class SetTargetField extends StatelessWidget {
  const SetTargetField({
    Key? key,
    required this.setTarget,
    this.subtle: false,
  }) : super(key: key);

  final ValueNotifier<int> setTarget;
  final bool subtle;

  @override
  Widget build(BuildContext context) {
    return SliderField(
      lastTick: 9,
      value: setTarget,
      header: SetTargetHeader(),
      indicator: SetTargetToTrainingTypeIndicator(
        setTarget: setTarget,
        wholeWidth: MediaQuery.of(context).size.width,
        oneSidePadding: 16 + 8.0,
      ),
    );
  }
}

class SetTargetHeader extends StatelessWidget {
  const SetTargetHeader({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: MyTheme.light,
      child: HeaderWithInfo(
        header: "Set Target",
        title: "Set Target",
        subtitle: "Not sure? Keep the default",
        isDense: true,
        body: SetTargetPopUpBody(),
      ),
    );
  }
}

class SetTargetPopUpBody extends StatelessWidget {
  const SetTargetPopUpBody({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 24,
          ),
          child: RichText(
            textScaleFactor: MediaQuery.of(
              context,
            ).textScaleFactor,
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
                      )),
                  TextSpan(
                    text: " for the ",
                  ),
                  TextSpan(
                      text: "training type",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      )),
                  TextSpan(text: " you are working towards"),
                ]),
          ),
        ),
        Theme(
          data: MyTheme.dark,
          child: Padding(
            padding: EdgeInsets.symmetric(
              vertical: 8,
            ),
            child: AllTrainingTypes(
              highlightField: 4,
            ),
          ),
        ),
        SuggestToLearnPage(),
      ],
    );
  }
}
