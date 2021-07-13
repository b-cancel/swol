//flutter
import 'package:flutter/material.dart';

//internal: shared
import 'package:swol/shared/widgets/complex/fields/fields/sliders/repTarget.dart';
import 'package:swol/shared/widgets/complex/fields/fields/function.dart';
import 'package:swol/action/tabs/suggest/corners.dart';
import 'package:swol/shared/widgets/complex/fields/headers/fieldHeader.dart';

//widget
class SuggestionChanger extends StatelessWidget {
  const SuggestionChanger({
    Key? key,
    required this.repTarget,
    required this.cardRadius,
  }) : super(key: key);

  final ValueNotifier<int> repTarget;
  final Radius cardRadius;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Expanded(
          child: Center(
            child: Text(
              "you should be able to lift",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.all(
              cardRadius,
            ),
          ),
          child: Column(
            children: [
              Container(
                height: 56,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.all(
                    cardRadius,
                  ),
                ),
                padding: EdgeInsets.all(16),
                child: Text("hi"),
              ),
              Transform.translate(
                offset: Offset(
                  0,
                  24,
                ),
                child: RepTargetField(
                  repTarget: repTarget,
                  subtle: true,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 16,
                ),
                child: RepTargetHeader(
                  subtle: true,
                ),
              ),
            ],
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
