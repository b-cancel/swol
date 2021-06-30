//flutter
import 'package:flutter/material.dart';

//plugin
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

//internal
import 'package:swol/shared/widgets/simple/oneOrTheOtherIcon.dart';
import 'package:swol/shared/structs/anExercise.dart';
import 'package:swol/other/functions/helper.dart';

//given the
//1. last weight
//2. last reps
//3. prediction function
//we
//1. calculate the 1 rep max or estimated 1 rep max
//2. generate a message to show if the user taps the chipd
class ExerciseTileSubtitle extends StatefulWidget {
  ExerciseTileSubtitle({
    required this.exercise,
    required Key? key,
  }) : super(key: key);

  final AnExercise exercise;

  @override
  _ExerciseTileSubtitleState createState() => _ExerciseTileSubtitleState();
}

class _ExerciseTileSubtitleState extends State<ExerciseTileSubtitle> {
  actualUpdate(Duration randomDuration) {
    //a set was just completed so there WILL be a new last set
    if (widget.exercise.tempStartTime.value == AnExercise.nullDateTime) {
      if (mounted) setState(() {});
    }
  }

  updateState() {
    //waits for all the other variables to be set
    WidgetsBinding.instance?.addPostFrameCallback(actualUpdate);
  }

  @override
  void initState() {
    //super init
    super.initState();

    //only changes when started or ended
    widget.exercise.tempStartTime.addListener(updateState);
  }

  @override
  void dispose() {
    //only changes when started or ended
    widget.exercise.tempStartTime.removeListener(updateState);

    //super dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.exercise.lastWeight == null) {
      //used so all tiles are the same height
      //and can properly show the mini timer
      return Container(
        height: 0,
        width: 0,
        //NOE: we can uncomment for equal spacing (I prefer it to be uneven)
        //height: 30,
      );
    } else {
      //some contstant before I begin
      const double borderRadius = 8;
      const TextStyle BOLD = const TextStyle(
        fontWeight: FontWeight.bold,
      );

      //NOTE: contains defaults for when this set is indeed a one rep max
      bool isOneRepMaxEstimated = false;
      Widget oneRepMaxWidget = Text(
        //we KNOW its not null
        widget.exercise.lastWeight.toString(),
        style: BOLD,
      );

      //only calculate the 1 rep max and all its related values if you must
      if (widget.exercise.lastReps != 1) {
        //we KNOW its not null
        isOneRepMaxEstimated = true;

        //estimate one rep max
        List oneRepMaxValues = Functions.getOneRepMaxValues(
          //we KNOW both are VALID
          widget.exercise.lastWeight!,
          widget.exercise.lastReps!,
        );

        //update onRepMaxWidget
        oneRepMaxWidget = Text(
          oneRepMaxValues[0][widget.exercise.predictionID].round().toString(),
          style: BOLD,
        );

        //extract data

        double standardDevaition = oneRepMaxValues[2];

        //we aren't sure about our result
        //NOTE: updating
        //1. oneRepMaxWidget
        //2. snackBarMessage
        //3. valueBorderColor

        //make that clear by
        //1. showing the devaition
        //2. but also by highligting the GUESS in an appropiate color
        //3. and add an appropiate snackbar with
        //    a. sureness string
        //    b. suggestions to improve
        double mean = oneRepMaxValues[1];
        int deviation;
        if (mean.toInt() == 0 || standardDevaition.toInt() == 0) {
          deviation = 0;
        } else {
          deviation = standardDevaition.toInt();
          // ((standardDevaition / mean) * 100).toInt();
        }

        //we are here because we have some level of uncertainty so we need to display that
        oneRepMaxWidget = Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            oneRepMaxWidget,
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 2.0,
              ),
              child: OneOrTheOtherIcon(
                one: Icon(
                  FontAwesomeIcons.plus,
                  color: Colors.white.withOpacity(0.75),
                ),
                other: Icon(
                  FontAwesomeIcons.minus,
                  color: Colors.white.withOpacity(0.75),
                ),
              ),
            ),
            Text(
              deviation.toInt().toString(),
            ),
          ],
        );
      }
      //ELSE: this is the users 1 rm

      //create the subtitle given the retreived values
      return Row(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Container(
            child: Padding(
              padding: EdgeInsets.only(
                top: 2.0,
                right: 16.0,
                bottom: 4.0,
              ),
              //NOTE: can join rounded edges but not border with rounded edges
              //which is why those are seperate below
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  //-------------------------1 RM tag
                  Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColorDark,
                      borderRadius: new BorderRadius.only(
                        topLeft: Radius.circular(borderRadius),
                        bottomLeft: Radius.circular(borderRadius),
                      ),
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: 4,
                      vertical: 5, //1 pixel to account for border width
                    ),
                    child: Text(
                      (isOneRepMaxEstimated ? "E-" : "") + "1RM",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  //-------------------------Value
                  Container(
                    padding: EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      border: Border.all(
                        //default width of 1.0
                        color: Theme.of(context).primaryColorDark,
                      ),
                      borderRadius: new BorderRadius.only(
                        bottomRight: Radius.circular(borderRadius),
                        topRight: Radius.circular(borderRadius),
                      ),
                    ),
                    child: oneRepMaxWidget,
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Container(
              color: Colors.blue,
            ),
          ),
        ],
      );
    }
  }
}
