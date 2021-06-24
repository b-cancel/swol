//flutter
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:swol/action/page.dart';

//internal
import 'package:swol/shared/widgets/complex/fields/fields/sliders/setTarget/pills.dart';
import 'package:swol/shared/widgets/simple/ourToolTip.dart';
import 'package:swol/shared/methods/theme.dart';

//widgets
class SetTargetToTrainingTypeIndicator extends StatefulWidget {
  SetTargetToTrainingTypeIndicator({
    required this.setTarget,
    required this.wholeWidth,
    required this.oneSidePadding,
  });

  final ValueNotifier<int> setTarget;
  final double wholeWidth;
  final double oneSidePadding;

  @override
  _SetTargetToTrainingTypeIndicatorState createState() =>
      _SetTargetToTrainingTypeIndicatorState();
}

class _SetTargetToTrainingTypeIndicatorState
    extends State<SetTargetToTrainingTypeIndicator> {
  int section;
  ScrollController controller = new ScrollController();

  setTargetToSection() {
    if (widget.setTarget.value > 7)
      section = 4;
    else {
      section = widget.setTarget.value - 3;
      section = (section < 0) ? 0 : section;
    }

    WidgetsBinding.instance?.addPostFrameCallback((_) {
      controller.animateTo(
        (((widget.wholeWidth - (2 * widget.oneSidePadding)) / 4) * section),
        duration: ExercisePage.transitionDuration,
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void initState() {
    //init
    setTargetToSection();

    //listener
    widget.setTarget.addListener(setTargetToSection);

    //super init
    super.initState();
  }

  @override
  void dispose() {
    widget.setTarget.removeListener(setTargetToSection);

    //super dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double tickWidth = 4;
    double totalScreenWidth = MediaQuery.of(context).size.width - 48;
    double totalSliderWidth = (totalScreenWidth / 4) * 8;

    double tickSpace = tickWidth * 9;
    double spacerSpace = totalSliderWidth - tickSpace;
    double spacerWidth = spacerSpace / 8;

    List<Widget> ticksAndStuff = [];

    //add our first tick
    ticksAndStuff.add(
      Tick(
        tickWidth: tickWidth,
        setTarget: widget.setTarget,
        value: 1,
      ),
    );

    //add spacer then tick 8 times
    for (int i = 0; i < 8; i++) {
      //spacer
      ticksAndStuff.add(
        Container(
          width: spacerWidth,
        ),
      );

      //tick
      ticksAndStuff.add(
        Tick(
          tickWidth: tickWidth,
          setTarget: widget.setTarget,
          value: (i + 2),
        ),
      );
    }

    return Container(
      //NOTE: MUST BE manually set
      height: 92,
      width: totalSliderWidth,
      child: Stack(
        children: <Widget>[
          ListView(
            physics: NeverScrollableScrollPhysics(),
            scrollDirection: Axis.horizontal,
            controller: controller,
            children: [
              Stack(
                children: <Widget>[
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: ticksAndStuff,
                  ),
                  Theme(
                    //light so that our pop ups work properly
                    data: MyTheme.light,
                    child: ThePills(
                      setTarget: widget.setTarget,
                      totalScreenWidth: totalScreenWidth,
                    ),
                  ),
                  Positioned(
                    right: 4,
                    top: 0,
                    bottom: 0,
                    child: Center(
                      child: NoMoreThan6Sets(),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class NoMoreThan6Sets extends StatelessWidget {
  const NoMoreThan6Sets({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        showWidgetToolTip(
          context,
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Flexible(
                child: Text(
                  "Any More than 6 sets, might do you more harm than good",
                  textAlign: TextAlign.right,
                ),
              ),
            ],
          ),
          direction: PreferDirection.topRight,
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
              border: Border.all(
            color: Theme.of(context).primaryColorDark,
            width: 2,
          )),
          padding: EdgeInsets.symmetric(
            horizontal: 4,
            vertical: 4,
          ),
          child: Icon(
            Icons.warning,
            color: Theme.of(context).primaryColorDark,
          ),
        ),
      ),
    );
  }
}

class Tick extends StatefulWidget {
  const Tick({
    Key? key,
    required this.tickWidth,
    required this.setTarget,
    required this.value,
  }) : super(key: key);

  final double tickWidth;
  final ValueNotifier<int> setTarget;
  final int value;

  @override
  _TickState createState() => _TickState();
}

class _TickState extends State<Tick> {
  bool tickActive;

  updateState() {
    if (mounted) {
      setTargetToTickActive();
      setState(() {});
    }
  }

  setTargetToTickActive() {
    tickActive = (widget.setTarget.value == widget.value);
  }

  @override
  void initState() {
    //init
    setTargetToTickActive();

    //update
    widget.setTarget.addListener(updateState);

    //super init
    super.initState();
  }

  @override
  void dispose() {
    widget.setTarget.removeListener(updateState);

    //super dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.tickWidth,
      color: (tickActive)
          ? Theme.of(context).accentColor
          : MyTheme.dark.backgroundColor,
    );
  }
}
