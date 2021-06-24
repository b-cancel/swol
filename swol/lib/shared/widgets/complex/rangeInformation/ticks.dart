//flutter
import 'package:flutter/material.dart';

//generate ticks
class RangeTicks extends StatefulWidget {
  RangeTicks({
    required this.startTick,
    required this.endTick,
    required this.bigTickNumber,
    this.selectedDuration,
    this.darkTheme,
  });

  final int startTick;
  final int endTick;
  final int bigTickNumber;
  final ValueNotifier<Duration> selectedDuration;
  final bool darkTheme;

  @override
  _RangeTicksState createState() => _RangeTicksState();
}

class _RangeTicksState extends State<RangeTicks> {
  updateState() {
    if (mounted) setState(() {});
  }

  @override
  void initState() {
    widget.selectedDuration.addListener(updateState);
    super.initState();
  }

  @override
  void dispose() {
    widget.selectedDuration.removeListener(updateState);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double tickWidth = 3;

    Widget spacer = Expanded(
      child: Container(),
    );

    int selected = widget.selectedDuration.value.inSeconds;

    //generate ticks
    List<Widget> ticks = [];
    int tickCount = ((widget.endTick - widget.startTick) ~/ 5) + 1;
    for (int i = 0; i < tickCount; i++) {
      int thisTick = widget.startTick + (i * 5);
      bool highlight = (thisTick == selected);
      bool bigTick = ((thisTick % widget.bigTickNumber) == 0);

      //add tick
      ticks.add(
        Container(
          width: 0,
          child: OverflowBox(
            minWidth: tickWidth,
            maxWidth: tickWidth,
            child: Container(
              height: (bigTick) ? 16 : 8,
              width: tickWidth,
              color: (highlight)
                  ? Theme.of(context).accentColor
                  : (widget.darkTheme)
                      ? Theme.of(context).backgroundColor
                      : Colors.grey.withOpacity(0.5),
            ),
          ),
        ),
      );

      //add trailing spacer
      ticks.add(spacer);
    }

    //remove trailing spacer
    ticks.removeLast();

    //build
    return Row(
      children: ticks,
    );
  }
}
