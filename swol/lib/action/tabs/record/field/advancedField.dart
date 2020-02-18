import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:swol/action/page.dart';
import 'package:swol/action/popUps/textValid.dart';
import 'package:swol/action/tabs/record/field/customField.dart';
import 'package:swol/action/tabs/record/field/fieldIcon.dart';
import 'package:swol/shared/functions/goldenRatio.dart';
import 'package:swol/shared/methods/theme.dart';

class RecordFields extends StatefulWidget { 
  RecordFields({
    @required this.heroAnimDuration,
  });

  final Duration heroAnimDuration;

  //weight field
  @override
  _RecordFieldsState createState() => _RecordFieldsState();
}

class _RecordFieldsState extends State<RecordFields> {
  final TextEditingController weightController = new TextEditingController();
  final FocusNode weightFocusNode = new FocusNode();

  final TextEditingController repsController = new TextEditingController();
  final FocusNode repsFocusNode = new FocusNode();

  updateWeightNotifier() {
    ExcercisePage.setWeight.value = weightController.text;
  }

  updateRepsNotifier() {
    ExcercisePage.setReps.value = repsController.text;
  }

  @override
  void initState() {
    //supe init
    super.initState();

    //NOTE: set the initial values of our controllers from notifiers
    weightController.text = ExcercisePage.setWeight.value;
    repsController.text = ExcercisePage.setReps.value;

    //add listeners
    weightController.addListener(updateWeightNotifier);
    repsController.addListener(updateRepsNotifier);

    //autofocus if possible
    WidgetsBinding.instance.addPostFrameCallback((_) {
      //NOTE: if you don't wait until transition things begin to break
      Future.delayed(widget.heroAnimDuration, () {
        focusOnFirstInvalid();
      });
    });

    //attach a listener so a change in it will cause a refocus
    //done from warning, error, and notes page
    ExcercisePage.causeRefocusIfInvalid.addListener(focusOnFirstInvalid);
  }

  @override
  void dispose() {
    //remove listeners
    ExcercisePage.causeRefocusIfInvalid.removeListener(focusOnFirstInvalid);

    //remove notifiers
    weightController.removeListener(updateWeightNotifier);
    repsController.removeListener(updateRepsNotifier);

    //super dispose
    super.dispose();
  }

  //if both are valid nothing happens
  //NOTE: in all cases where this is used the keyboard is guaranteed to be closed
  //and its closed automatically by unfocusing so there are no weird exceptions to cover
  focusOnFirstInvalid() {
    //maybe focus on weight
    if (isTextValid(weightController.text) == false) {
      //clear with value that could be nothing but invalid
      if(weightController.text == "0") weightController.clear();
      //request focus
      FocusScope.of(context).requestFocus(weightFocusNode);
      //NOTE: cursor automatically gets shifted to the end
    } else { //maybe focus on reps
      if (isTextValid(repsController.text) == false) {
        //clear with value that could be nothing but invalid
        if(repsController.text == "0") repsController.clear();
        //request focus
        FocusScope.of(context).requestFocus(repsFocusNode);
        //NOTE: cursor automatically gets shifted to the end
      }
    }

    //whatever cause the refocusing
    //no longer needs it
    ExcercisePage.causeRefocusIfInvalid.value = false;
  }

  @override
  Widget build(BuildContext context) {
    //-32 is for 16 pixels of padding from both sides
    double screenWidth = MediaQuery.of(context).size.width - 32;
    List<double> goldenBS = measurementToGoldenRatioBS(screenWidth);
    double iconSize = goldenBS[1];
    List<double> golden2BS = measurementToGoldenRatioBS(iconSize);
    iconSize = golden2BS[1];
    double borderSize = 3;

    //build
    return Theme(
      //NOTE: must be edited here since the color differ 
      //from what they are for the name, notes, and link field
      data: MyTheme.dark.copyWith(
        textSelectionColor: MyTheme.dark.primaryColorDark,
        //NOTE: probably due to a flutter bug I can't set the selection 
        //"textSelectionHandleColor" here because it just won't show
      ),
      child: Container(
        height: (iconSize * 2) + 8,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            RecordField(
              focusNode: weightFocusNode,
              controller: weightController,
              isLeft: true,
              borderSize: borderSize,
              otherFocusNode: repsFocusNode,
              otherController: repsController
            ),
            Column(
              children: <Widget>[
                TappableIcon(
                  focusNode: weightFocusNode,
                  iconSize: iconSize,
                  borderSize: borderSize,
                  icon: Padding(
                    padding: const EdgeInsets.only(
                      right: 8,
                    ),
                    child: Icon(
                      FontAwesomeIcons.dumbbell,
                    ),
                  ),
                  isLeft: true,
                ),
                TappableIcon(
                  focusNode: repsFocusNode,
                  iconSize: iconSize,
                  borderSize: borderSize,
                  icon: Icon(Icons.repeat),
                  isLeft: false,
                ),
              ],
            ),
            RecordField(
              focusNode: repsFocusNode,
              controller: repsController,
              isLeft: false,
              borderSize: borderSize,
              otherFocusNode: weightFocusNode,
              otherController: weightController,
            ),
          ],
        ),
      ),
    );
  }
}