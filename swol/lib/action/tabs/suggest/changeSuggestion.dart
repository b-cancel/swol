//flutter
import 'package:flutter/material.dart';
import 'package:swol/action/tabs/suggest/corners.dart';

//plugin
import 'package:swol/action/shared/changeFunction.dart';

//internal: shared
import 'package:swol/shared/widgets/complex/fields/fields/sliders/repTarget.dart';
import 'package:swol/shared/widgets/complex/fields/fields/function.dart';
import 'package:swol/shared/structs/anExcercise.dart';

//widget
class SuggestionChanger extends StatefulWidget {
  const SuggestionChanger({
    Key key,
    @required this.excercise,
    @required this.arrowRadius,
    @required this.cardRadius,
  }) : super(key: key);

  final AnExcercise excercise;
  final Radius arrowRadius;
  final Radius cardRadius;

  @override
  _SuggestionChangerState createState() => _SuggestionChangerState();
}

class _SuggestionChangerState extends State<SuggestionChanger> {
  ValueNotifier<int> repTarget;

  //updating function
  updateRepTarget() {
    widget.excercise.repTarget = repTarget.value;
  }

  //init
  @override
  void initState() {
    //super init
    super.initState();

    //create notifiers
    repTarget = new ValueNotifier<int>(widget.excercise.repTarget);

    //add listeners
    repTarget.addListener(updateRepTarget);
  }

  //dispose
  @override
  void dispose() { 
    //remove listeners
    repTarget.removeListener(updateRepTarget);

    //dispose notifiers
    repTarget.dispose();

    //super dispose
    super.dispose();
  }

  //build
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Expanded(
          child: PredictionFormulaSpacer(
            arrowRadius: widget.arrowRadius,
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 24.0,
          ),
          child: Container(
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.only(
                bottomRight: widget.cardRadius,
                bottomLeft: widget.cardRadius,
              ),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 24,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  PredictionFormulaHeader(
                    subtle: true,
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      bottom: 8.0,
                    ),
                    child: ChangeFunction(
                      excercise: widget.excercise, 
                      middleArrows: false,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 24,
            ),
            child: TextWithCorners(
              text: "and your Rep Target",
              radius: widget.cardRadius,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 24.0,
          ),
          child: Container(
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.only(
                bottomRight: widget.arrowRadius,
                bottomLeft: widget.arrowRadius,
              ),
            ),
            padding: EdgeInsets.only(
              bottom: 12,
            ),
            child: RepTargetField(
              changeDuration: Duration(milliseconds: 300),
              repTarget: repTarget,
              subtle: true,
            ),
          ),
        ),
        Expanded(
          child: TextWithCorners(
            useAccent: true,
            text: "your next set should be",
            radius: widget.arrowRadius,
          ),
        ),
      ],
    );
  }
}

class PredictionFormulaSpacer extends StatelessWidget {
  const PredictionFormulaSpacer({
    Key key,
    @required this.arrowRadius,
  }) : super(key: key);

  final Radius arrowRadius;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        TextWithCorners(
         text: "using your Prediction Formula",
         radius: arrowRadius
       ),
       Positioned.fill(
         child: Container(
           child: Row(
             children: <Widget>[
               Container(
                 color: Theme.of(context).primaryColorDark,
                 width: 24,
               ),
               Expanded(
                 child: Container(),
               ),
               Container(
                 color: Theme.of(context).primaryColorDark,
                 width: 24,
               )
             ],
           ),
         ),
       ),
     ],
    );
  }
}