//flutter
import 'package:flutter/material.dart';

//plugin
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

//internal: action
import 'package:swol/action/page.dart';
import 'package:swol/action/popUps/textValid.dart';

//internal: shared/other
import 'package:swol/shared/structs/anExercise.dart';
import 'package:swol/shared/widgets/simple/conditional.dart';
import 'package:swol/other/functions/W&R=1RM.dart';

//widget
class InaccuracyCalculator extends StatefulWidget {
  const InaccuracyCalculator({
    Key? key,
    required this.exercise,
  }) : super(key: key);

  final AnExercise exercise;

  @override
  _InaccuracyCalculatorState createState() => _InaccuracyCalculatorState();
}

class _InaccuracyCalculatorState extends State<InaccuracyCalculator> {
  updateState() {
    if (mounted) setState(() {});
  }

  @override
  void initState() {
    //super init
    super.initState();

    //listeners
    ExercisePage.setWeight.addListener(updateState);
    ExercisePage.setReps.addListener(updateState);
  }

  @override
  void dispose() {
    //listeners
    ExercisePage.setWeight.removeListener(updateState);
    ExercisePage.setReps.removeListener(updateState);

    //super dipose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //check if we can show how far off they were from the target
    bool weightValid = isTextParsedIsLargerThan0(ExercisePage.setWeight.value);
    bool repsValid = isTextParsedIsLargerThan0(ExercisePage.setReps.value);

    //show different things depending on whether or not the set is valid
    bool setValid = weightValid && repsValid;

    //build
    return Transform.translate(
      offset: Offset(0, (setValid) ? 16 : 0),
      child: Conditional(
        condition: setValid,
        //sets the closestIndex to ?
        ifTrue: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "you can do ",
                ),
                Text(
                  "another exercise",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Text(
              "OR",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Go ",
                ),
                Text(
                  "To Break Timer",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
        //sets the closestIndex to -1
        ifFalse: WaitingForValid(),
      ),
    );
  }
}

class WaitingForValid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: MediaQuery.of(context).size.width / 4,
          child: Image(
            image: new AssetImage("assets/impatient.gif"),
            color: Theme.of(context).accentColor,
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width / 1.75,
          child: FittedBox(
            fit: BoxFit.contain,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Waiting For A Valid Set",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    top: 4,
                  ),
                  child: Text(
                    "Break Timer Started",
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
