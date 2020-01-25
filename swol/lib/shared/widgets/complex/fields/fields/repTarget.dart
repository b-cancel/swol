//flutter
import 'package:flutter/material.dart';

//internal
import 'package:swol/shared/widgets/complex/rangeInformation/animatedCarousel.dart';
import 'package:swol/shared/widgets/complex/fields/headers/fieldHeader.dart';
import 'package:swol/shared/widgets/simple/sliderTipButton.dart';
import 'package:swol/shared/widgets/simple/ourSlider.dart';
import 'package:swol/shared/functions/trainingPopUps.dart';
import 'package:swol/shared/structs/anExcercise.dart';
import 'package:swol/shared/structs/range.dart';
import 'package:swol/shared/methods/theme.dart';

//from suggestion
/*
Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 24,
            ),
            child: Container(
              padding: EdgeInsets.only(
                top: 0,
                bottom: 16,
              ),
              child: Column(
                children: <Widget>[ 
                  RepTargetHeader(subtle: true),
                  Theme(
                    data: MyTheme.light,
                    child: AnimRepTargetInfoWhite(
                      changeDuration: Duration(milliseconds: 300), 
                      repTargetDuration: new ValueNotifier<Duration>(
                        Duration(milliseconds: 300),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 4),
                    child: Container(
                      color: Colors.black, //line color
                      height: 2,
                      width: MediaQuery.of(context).size.width,
                    ),
                  ),
                ],
              ),
            ),
          ),
          //slide must be full width without the 16 horizontal padding
          CustomSlider(
            value: new ValueNotifier<int>(1),
            lastTick: 35,
          ),
        ],
      ),
*/

//from add


/*
Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(
              top: 8,
              left: 16,
              right: 16,
              bottom: 16,
            ),
            child: Column(
              children: <Widget>[ 
                RepTargetHeader(),
                Theme(
                  data: MyTheme.light,
                  child: AnimRepTargetInfoWhite(
                    changeDuration: widget.changeDuration, 
                    repTargetDuration: widget.repTargetDuration,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 8),
                  child: Container(
                    color: Colors.black, //line color
                    height: 2,
                    width: MediaQuery.of(context).size.width,
                  ),
                ),
              ],
            ),
          ),
          //slide must be full width without the 16 horizontal padding
          CustomSlider(
            value: widget.repTarget,
            lastTick: 35,
          ),
        ],
      ),
*/

class RepTargetField extends StatefulWidget {
  RepTargetField({
    @required this.repTarget,
    @required this.changeDuration,
  });

  final ValueNotifier<int> repTarget;
  final Duration changeDuration;

  @override
  _RepTargetFieldState createState() => _RepTargetFieldState();
}

class _RepTargetFieldState extends State<RepTargetField> {
  final ValueNotifier<Duration> repTargetDuration = new ValueNotifier(
    Duration(
      seconds: AnExcercise.defaultRepTarget * 5,
    )
  );

  repTargetUpdate(){
    repTargetDuration.value = Duration(
      seconds: widget.repTarget.value * 5,
    );
  }

  @override
  void initState() {
    //handle listeners that will then make it possible to give tips all throghout
    widget.repTarget.addListener(repTargetUpdate);

    //super init
    super.initState();
  }

  @override
  void dispose() {
    widget.repTarget.removeListener(repTargetUpdate);

    //super dispose 
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(
            top: 8,
            left: 16,
            right: 16,
            bottom: 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              RepTargetHeader(),
              Theme(
                data: MyTheme.light,
                child: AnimRepTargetInfoWhite(
                  changeDuration: widget.changeDuration, 
                  repTargetDuration: repTargetDuration,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 8),
                child: Container(
                  color: Colors.black, //line color
                  height: 2,
                  width: MediaQuery.of(context).size.width,
                ),
              ),
            ],
          ),
        ),
        //slide must be full width without the 16 horizontal padding
        CustomSlider(
          value: widget.repTarget,
          lastTick: 35,
        ),
      ],
    );
  }
}

//used by rep target (BoxFit.contained) and within white theme
class AnimRepTargetInfoWhite extends StatelessWidget {
  const AnimRepTargetInfoWhite({
    Key key,
    @required this.changeDuration,
    @required this.repTargetDuration,
  }) : super(key: key);

  final Duration changeDuration;
  final ValueNotifier<Duration> repTargetDuration;

  @override
  Widget build(BuildContext context) {
    return AnimatedRangeInformation(
      changeDuration: changeDuration,
      selectedDuration: repTargetDuration,
      bigTickNumber: 25,
      ranges: [
        Range(
          name: "Strength Training",
          onTap: makeStrengthTrainingPopUp(context, 3),
          left: new SlideRangeExtent(
            buttonText: "1",
          ),
          right: SlideRangeExtent(
            buttonText: "6",
          ),
          startSeconds: (1*5),
          endSeconds: (6*5),
        ),
        Range(
          name: "Hypertrophy Training",
          onTap: makeHypertrophyTrainingPopUp(context, 3),
          left: SlideRangeExtent(
            buttonText: "7",
          ),
          right: SlideRangeExtent(
            buttonText: "12",
          ),
          startSeconds: (7*5),
          endSeconds: (12*5),
        ),
        Range(
          name: "Endurance Training",
          onTap: makeEnduranceTrainingPopUp(context, 3),
          left: SlideRangeExtent(
            buttonText: "13",
          ),
          right: SlideRangeExtent(
            buttonText: "35",
            tipText: "Any More, and we will have trouble \nestimating your 1 Rep Max",
          ),
          startSeconds: (13*5),
          endSeconds: (35*5),
        )
      ],
    );
  }
}