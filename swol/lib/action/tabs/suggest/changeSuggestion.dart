//flutter
import 'package:flutter/material.dart';

//internal: shared
import 'package:swol/shared/widgets/complex/fields/fields/sliders/repTarget.dart';
import 'package:swol/shared/widgets/complex/fields/fields/function.dart';
import 'package:swol/action/tabs/suggest/corners.dart';

//widget
class SuggestionChanger extends StatelessWidget {
  const SuggestionChanger({
    Key? key,
    required this.repTarget,
    required this.arrowRadius,
    required this.cardRadius,
  }) : super(key: key);

  final ValueNotifier<int> repTarget;
  final Radius arrowRadius;
  final Radius cardRadius;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 24,
            ),
            child: TextWithCorners(
              text: "and your Rep Target",
              radius: cardRadius,
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
                bottomRight: arrowRadius,
                bottomLeft: arrowRadius,
              ),
            ),
            padding: EdgeInsets.only(
              bottom: 12,
            ),
            child: RepTargetField(
              repTarget: repTarget,
              subtle: true,
            ),
          ),
        ),
      ],
    );
  }
}

class PredictionFormulaSpacer extends StatelessWidget {
  const PredictionFormulaSpacer({
    Key? key,
    required this.arrowRadius,
  }) : super(key: key);

  final Radius arrowRadius;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        TextWithCorners(
          text: "using your Prediction Formula",
          radius: arrowRadius,
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
