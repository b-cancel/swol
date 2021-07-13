//flutter
import 'package:flutter/material.dart';

//plugin
import 'package:awesome_dialog/awesome_dialog.dart';

//internal: widgets
import 'package:swol/shared/widgets/complex/fields/fields/sliders/setTarget/trainingTypes.dart';
import 'package:swol/shared/widgets/complex/trainingTypeTables/trainingTypes.dart';
import 'package:swol/shared/widgets/simple/ourHeaderIconPopUp.dart';
import 'package:swol/shared/widgets/simple/ourSlider.dart';

//internal: other
import 'package:swol/shared/structs/anExercise.dart';
import 'package:swol/shared/methods/theme.dart';

//function
maybeChangeSetTarget(
  BuildContext context,
  AnExercise exercise,
  Function ifFinish,
  Color headerColor,
  int setsPassed,
) {
  //remove focus so the pop up doesnt bring it back
  FocusScope.of(context).unfocus();

  //reused everywhere
  TextStyle bold = TextStyle(
    fontWeight: FontWeight.bold,
  );

  //get stuff
  int target = exercise.setTarget;
  final ValueNotifier<int> setTarget = new ValueNotifier<int>(
    target,
  );
  int curr = setsPassed;
  int setsBelow = target - curr;
  bool isNot1 = (setsBelow != 1 && setsBelow != -1);

  //show the dialog
  showBasicHeaderIconPopUp(
    context,
    [
      Text(
        "Change Set Target?",
        style: TextStyle(
          fontSize: 28,
        ),
      ),
    ],
    [
      Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 16.0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RichText(
              textScaleFactor: MediaQuery.of(
                context,
              ).textScaleFactor,
              text: TextSpan(
                style: TextStyle(
                  color: Colors.black,
                ),
                children: [
                  TextSpan(
                    text: "You did ",
                  ),
                  TextSpan(
                    text: curr < target
                        ? (setsBelow.toString() + " less")
                        : ((setsBelow * -1).toString() + "more"),
                    style: bold,
                  ),
                  TextSpan(
                    text: " set" +
                        (isNot1 ? "s" : "") +
                        " than initially planned\n",
                  ),
                ],
              ),
            ),
            RichText(
              textScaleFactor: MediaQuery.of(
                context,
              ).textScaleFactor,
              text: TextSpan(
                style: TextStyle(
                  color: Colors.black,
                ),
                children: [
                  TextSpan(
                    text: "If you would like to ",
                  ),
                  TextSpan(
                    text: "Change your Set Target ",
                    style: bold,
                  ),
                  TextSpan(
                    text: " you can do so below.\n",
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      ChangeSetTargetWidget(
        setTarget: setTarget,
      ),
    ],
    DialogType.WARNING,
    isDense: true,
    animationType: AnimType.LEFTSLIDE,
    clearBtn: TextButton(
      child: Text(
        "Close",
      ),
      onPressed: () {
        Navigator.pop(context);
      },
    ),
    colorBtn: ElevatedButton(
      child: Text(
        "Finish Set",
      ),
      onPressed: () {
        //update set target
        exercise.setTarget = setTarget.value;

        //pop ourselves
        Navigator.pop(context);

        //proceed as expected
        ifFinish();
      },
    ),
  );
}

class ChangeSetTargetWidget extends StatefulWidget {
  ChangeSetTargetWidget({
    Key? key,
    required this.setTarget,
  }) : super(key: key);

  final ValueNotifier<int> setTarget;

  @override
  _ChangeSetTargetWidgetState createState() => _ChangeSetTargetWidgetState();
}

class _ChangeSetTargetWidgetState extends State<ChangeSetTargetWidget> {
  ValueNotifier<int> sectionID = new ValueNotifier(0);

  setTargetToSectionID() {
    if (widget.setTarget.value <= 2)
      sectionID.value = 0; //endurance
    else {
      if (widget.setTarget.value <= 3)
        sectionID.value = 1; //end/hyp
      else {
        if (widget.setTarget.value <= 5)
          sectionID.value = 2; //hyp/str
        else {
          if (widget.setTarget.value <= 6)
            sectionID.value = 3; //strength
          else
            sectionID.value = 4; //nothing
        }
      }
    }
  }

  @override
  void initState() {
    //initial function calls
    setTargetToSectionID();

    //as the recovery period changes updates should occur
    widget.setTarget.addListener(setTargetToSectionID);

    //super init
    super.initState();
  }

  @override
  void dispose() {
    widget.setTarget.removeListener(setTargetToSectionID);

    //super dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          /*
          Padding(
            padding: EdgeInsets.only(
              bottom: 16,
            ),
            child: Theme(
              data: MyTheme.dark,
              child: TrainingTypeSections(
                cardBackground: false,
                highlightField: 3,
                //endurance / end+hyp / hyp+str / str /str
                sections: [
                  [0],
                  [0, 1],
                  [1, 2],
                  [2],
                  [2],
                ],
                sectionID: sectionID,
              ),
            ),
          ),
          */
          SetTargetToTrainingTypeIndicator(
            setTarget: widget.setTarget,
            wholeWidth: MediaQuery.of(context).size.width,
            oneSidePadding: 16 + 8.0,
          ),
          Padding(
            padding: EdgeInsets.only(
              top: 8,
            ),
            child: CustomSlider(
              value: widget.setTarget,
              lastTick: 9,
              isDark: false,
            ),
          ),
        ],
      ),
    );
  }
}
