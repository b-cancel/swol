//flutter
import 'package:flutter/material.dart';
import 'package:swol/shared/methods/theme.dart';

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
    this.subtle: false,
  }) : super(key: key);

  final ValueNotifier<int> functionIndex;
  final ValueNotifier<String> functionString;
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
  });

  final ValueNotifier<String> functionString;
  final ValueNotifier<int> functionIndex;

  @override
  _FunctionDropDownState createState() => _FunctionDropDownState();
}

class _FunctionDropDownState extends State<FunctionDropDown> {
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
          setState(() {
            widget.functionString.value = newValue;
            widget.functionIndex.value =
                Functions.functionToIndex[widget.functionString.value];
          });
        },
        items:
            Functions.functions.map<DropdownMenuItem<String>>((String value) {
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
