//flutter
import 'package:flutter/material.dart';
import 'package:swol/shared/methods/theme.dart';
import 'package:swol/shared/methods/vibrate.dart';
import 'package:swol/shared/structs/anExercise.dart';

//internal
import 'package:swol/shared/widgets/complex/fields/headers/fieldHeader.dart';
import 'package:swol/other/functions/helper.dart';
import 'package:swol/shared/widgets/simple/conditional.dart';
import 'package:swol/shared/widgets/simple/functionTable.dart';
import 'package:swol/shared/widgets/simple/toLearnPage.dart';

class PredictionFormulasPopUpBody extends StatelessWidget {
  const PredictionFormulasPopUpBody({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: 24,
          ),
          alignment: Alignment.centerLeft,
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
                  text: "Select the formula that" + " you would like to ",
                ),
                TextSpan(
                  text: "Estimate",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(
                  text: " your ",
                ),
                TextSpan(
                  text: "One Rep Max",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(text: " and your "),
                TextSpan(
                  text: "Goal Set\n",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
        Theme(
          data: MyTheme.dark,
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 24,
            ),
            child: Padding(
              padding: EdgeInsets.only(
                bottom: 8.0,
              ),
              child: FunctionCardTable(),
            ),
          ),
        ),
        SuggestToLearnPage(),
      ],
    );
  }
}

class FunctionDropDown extends StatefulWidget {
  FunctionDropDown({
    required this.functionID,
    required this.repTarget,
  });

  final ValueNotifier<int> functionID;
  final ValueNotifier<int> repTarget;

  @override
  _FunctionDropDownState createState() => _FunctionDropDownState();
}

class _FunctionDropDownState extends State<FunctionDropDown> {
  ValueNotifier<int> selectedFunctionOrder =
      new ValueNotifier(AnExercise.defaultRepTarget);

  updateState() {
    if (mounted) setState(() {});
  }

  //IF it updates function order
  //we will hear the change and update state
  maybeUpdateFunctionOrder() {
    int newValue = widget.repTarget.value;
    if (newValue <= 8 || newValue == 10) {
      selectedFunctionOrder.value = widget.repTarget.value;
    } else if (newValue == 9) {
      selectedFunctionOrder.value = 8;
    } else if (newValue < 14) {
      selectedFunctionOrder.value = 11;
    } else if (newValue < 17) {
      selectedFunctionOrder.value = 14;
    } else if (newValue < 22) {
      selectedFunctionOrder.value = 17;
    } else
      selectedFunctionOrder.value = 22;
  }

  @override
  void initState() {
    //super init
    super.initState();
    //listen to rep target change
    widget.repTarget.addListener(maybeUpdateFunctionOrder);
    selectedFunctionOrder.addListener(updateState);
  }

  @override
  void dispose() {
    //remove listeners
    widget.repTarget.removeListener(maybeUpdateFunctionOrder);
    selectedFunctionOrder.removeListener(updateState);

    //super dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        canvasColor: MyTheme.dark.primaryColorDark,
      ),
      child: DropdownButton<int>(
        value: widget.functionID.value, //the ID selected
        icon: Icon(Icons.arrow_drop_down),
        isExpanded: true,
        iconSize: 24,
        elevation: 16,
        onChanged: (int? newValue) {
          if (newValue != null) {
            Vibrator.vibrateOnce();
            setState(() {
              widget.functionID.value = newValue;
            });
          }
        },
        items: Functions
            .repTargetToFunctionIndicesOrder[selectedFunctionOrder.value]
            ?.map<DropdownMenuItem<int>>((int functionID) {
          bool selected = (functionID == widget.functionID.value);
          String thisFunctionString = Functions.functions[functionID];

          //indices
          int idAtEnd = Functions
              .repTargetToFunctionIndicesOrder[selectedFunctionOrder.value]![0];
          int idAtStart = Functions
              .repTargetToFunctionIndicesOrder[selectedFunctionOrder.value]![7];

          //widget
          return DropdownMenuItem<int>(
            value: functionID,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  //what in the currently selected position
                  thisFunctionString,
                  style: TextStyle(
                    fontWeight: selected ? FontWeight.bold : FontWeight.normal,
                    color: selected
                        ? Colors.white
                        : Colors.white.withOpacity(0.75),
                  ),
                ),
                Flexible(
                  child: Visibility(
                    visible: selected == false &&
                        (functionID == idAtStart || functionID == idAtEnd),
                    child: Padding(
                      padding: EdgeInsets.only(
                        right: 8.0,
                      ),
                      child: Conditional(
                        condition: functionID == idAtEnd,
                        ifTrue: Text(
                          "Higher E-1RM",
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        ifFalse: Text(
                          "Lower E-1RM",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}
