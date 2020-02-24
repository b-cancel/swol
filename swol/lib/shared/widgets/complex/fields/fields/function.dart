//flutter
import 'package:flutter/material.dart';
import 'package:swol/shared/methods/theme.dart';
import 'package:swol/shared/methods/vibrate.dart';
import 'package:swol/shared/structs/anExcercise.dart';

//internal
import 'package:swol/shared/widgets/complex/fields/headers/fieldHeader.dart';
import 'package:swol/other/functions/helper.dart';
import 'package:swol/shared/widgets/simple/functionTable.dart';
import 'package:swol/shared/widgets/simple/toLearnPage.dart';

//widget
class PredictionField extends StatelessWidget {
  const PredictionField({
    Key key,
    @required this.functionIndex,
    @required this.functionString,
    @required this.repTarget,
    this.subtle: false,
  }) : super(key: key);

  final ValueNotifier<int> functionIndex;
  final ValueNotifier<String> functionString;
  final ValueNotifier<int> repTarget;
  final bool subtle;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        PredictionFormulaHeader(
          subtle: subtle,
        ),
        FunctionDropDown(
          functionIndex: functionIndex,
          functionString: functionString,
          repTarget: repTarget,
        ),
      ],
    );
  }
}

class PredictionFormulaHeader extends StatelessWidget {
  PredictionFormulaHeader({
    this.subtle: false,
  });

  final bool subtle;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: MyTheme.light,
      child: HeaderWithInfo(
        header: "Prediction Formula",
        title: "Prediction Formulas",
        subtitle: "Not sure? Keep the default",
        body: PredictionFormulasPopUpBody(),
        isDense: true,
        subtle: subtle,
      ),
    );
  }
}

class PredictionFormulasPopUpBody extends StatelessWidget {
  const PredictionFormulasPopUpBody({
    Key key,
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
            text: TextSpan(
                style: TextStyle(
                  color: Colors.black,
                ),
                children: [
                  TextSpan(
                    text: "Select the formula that you ",
                  ),
                  TextSpan(
                    text: "beleive",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: " will predict your ",
                  ),
                  TextSpan(
                    text: "ability",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(text: " for this excercise\n"),
                ]),
          ),
        ),
        Theme(
          data: MyTheme.dark,
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 24,
            ),
            child: Padding(
              padding: const EdgeInsets.only(
                bottom: 16.0,
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
    @required this.functionString,
    @required this.functionIndex,
    @required this.repTarget,
  });

  final ValueNotifier<String> functionString;
  final ValueNotifier<int> functionIndex;
  final ValueNotifier<int> repTarget;

  @override
  _FunctionDropDownState createState() => _FunctionDropDownState();
}

class _FunctionDropDownState extends State<FunctionDropDown> {
  ValueNotifier<int> selectedFunctionOrder = new ValueNotifier(AnExcercise.defaultRepTarget);
  static final Map<int, List<int>> repTargetToFunctionOrder = {
    1 : [2,	  0,    7, 	5, 	1,  4, 	3, 	6], //chose 0 location
    2 : [0,	  2,    1, 	4, 	5,  3, 	7, 	6],
    3 : [0,	  1,    4, 	2, 	5,  3, 	7, 	6],
    4 : [0,	  4,    1, 	5, 	2,  3, 	7, 	6],
    5 : [4,	  0, 	  1, 	5, 	3,  7, 	2, 	6], //chose 0 location
    6 : [4,	  0,    1, 	7, 	3, 	5, 	6,	2],
    7 : [4,	  0,    1, 	7, 	3,  6, 	5, 	2],
    8 : [4,	  7,    0, 	1, 	6,	3, 	5,	2],
    //missing 9
    10 : [4,	7,   	6, 	0,	3, 	1, 	5, 	2], //chose 0 location
    11 : [7,	4,   	6, 	3, 	5,  0,	1,	2],
    //missing 12 and 13
    14 : [7,	4,   	6, 	3, 	5,  0,	1,	2],
    //missing 15, 16, and 17
    17 : [7,	4,   	6, 	5,	3,	2,	1,	0],
    //missing 18 through 21
    22 : [7,	6,	  4, 	5, 	3,	2,	1,	0],
  };

  updateState(){
    if(mounted) setState(() {});
  }

  //IF it updates function order 
  //we will hear the change and update state
  maybeUpdateFunctionOrder(){
    int newValue = widget.repTarget.value;
    if(newValue <= 8 || newValue == 10){
      selectedFunctionOrder.value = widget.repTarget.value;
    }
    else if(newValue == 9){
      selectedFunctionOrder.value = 8;
    }
    else if(newValue < 14){
      selectedFunctionOrder.value = 11;
    }
    else if(newValue < 17){
      selectedFunctionOrder.value = 14;
    }
    else if(newValue < 22){
      selectedFunctionOrder.value = 17;
    }
    else selectedFunctionOrder.value = 22;
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
      child: DropdownButton<String>(
        value: widget.functionString.value,
        icon: Icon(Icons.arrow_drop_down),
        isExpanded: true,
        iconSize: 24,
        elevation: 16,
        onChanged: (String newValue) {
          Vibrator.vibrateOnce();
          setState(() {
            widget.functionString.value = newValue;
            widget.functionIndex.value =
                Functions.functionToIndex[widget.functionString.value];
          });
        },
        items: Functions.functions.map<DropdownMenuItem<String>>((String value) {
          bool selected = value == widget.functionString.value;
          return DropdownMenuItem<String>(
            value: value,
            child: Text(
              value,
              style: TextStyle(
                fontWeight: selected ? FontWeight.bold : FontWeight.normal,
                color: selected ? Colors.white : Colors.white.withOpacity(0.75),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
