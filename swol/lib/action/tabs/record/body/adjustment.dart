import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:swol/action/shared/changeFunction.dart';
import 'package:swol/action/shared/halfColored.dart';
import 'package:swol/action/shared/setDisplay.dart';
import 'package:swol/shared/structs/anExcercise.dart';

class MakeFunctionAdjustment extends StatefulWidget {
  const MakeFunctionAdjustment({
    Key key,
    @required this.heroUp,
    @required this.heroAnimDuration,
    @required this.heroAnimTravel,
    @required this.excercise,
  }) : super(key: key);

  final AnExcercise excercise;
  final ValueNotifier<bool> heroUp;
  final Duration heroAnimDuration;
  final double heroAnimTravel;

  @override
  _MakeFunctionAdjustmentState createState() => _MakeFunctionAdjustmentState();
}

class _MakeFunctionAdjustmentState extends State<MakeFunctionAdjustment> {
  final ValueNotifier<int> predictionID = new ValueNotifier<int>(0);

  updatePredictionID() {
    widget.excercise.predictionID = predictionID.value;
  }

  @override
  void initState() {
    //super init
    super.initState();

    //init value and notifier addition
    predictionID.value = widget.excercise.predictionID;
    predictionID.addListener(updatePredictionID);
  }

  @override
  void dispose() { 
    //remove listener
    predictionID.removeListener(updatePredictionID);

    //super dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //color for "suggestion"
    //TODO: because we are wrapped in a white so the pop up works well
    //TODO: this distance color will be white even though it should be the dark card color
    //TODO: fix that... maybe... clean white is kinda cool to
    Color distanceColor = Theme.of(context).cardColor;
    int id = 0;
    if (id == 1)
      distanceColor = Colors.red.withOpacity(0.33);
    else if (id == 2)
      distanceColor = Colors.red.withOpacity(0.66);
    else if (id == 3) distanceColor = Colors.red;

    return Container(
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width,
            height: 24,
            color: Theme.of(context).accentColor,
          ),
          TopBackgroundColored(
            color: Theme.of(context).accentColor,
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.all(
                  Radius.circular(24),
                ),
              ),
              child: SetDisplay(
                useAccent: false,
                title: "Goal Set",
                heroUp: widget.heroUp,
                heroAnimDuration: widget.heroAnimDuration,
                heroAnimTravel: widget.heroAnimTravel,
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Container(
                        child: Text(
                          "24",
                          style: GoogleFonts.robotoMono(
                            color: distanceColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 96,
                            wordSpacing: 0,
                          ),
                        ),
                      ),
                      DefaultTextStyle(
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              Icon(
                                FontAwesomeIcons.percentage,
                                color: distanceColor,
                                size: 42,
                              ),
                              Text(
                                "higher",
                                style: TextStyle(
                                  fontSize: 42,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Transform.translate(
                    offset: Offset(0, -16),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Center(
                          child: Text(
                            "than calculated by the",
                            style: TextStyle(
                              fontSize: 22,
                            ),
                          ),
                        ),
                        ChangeFunction(
                          predictionID: predictionID,
                          middleArrows: true,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}