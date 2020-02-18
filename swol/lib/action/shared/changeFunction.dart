//flutter
import 'package:flutter/material.dart';

//plugin
import 'package:carousel_slider/carousel_slider.dart';

//internal
import 'package:swol/other/functions/helper.dart';
import 'package:swol/shared/methods/vibrate.dart';

//NOTE: should not dispose predictionID since the value was passed
class ChangeFunction extends StatefulWidget {
  ChangeFunction({
    @required this.predictionID,
    @required this.middleArrows,
  });

  final ValueNotifier<int> predictionID;
  final bool middleArrows;

  @override
  _ChangeFunctionState createState() => _ChangeFunctionState();
}

class _ChangeFunctionState extends State<ChangeFunction> {
  final ValueNotifier<bool> lastFunction = new ValueNotifier<bool>(false);
  final ValueNotifier<bool> firstFunction = new ValueNotifier<bool>(false);

  var carousel;

  updateFirstLast() {
    firstFunction.value = (widget.predictionID.value == 0);
    lastFunction.value = (widget.predictionID.value == Functions.functions.length - 1);
  }

  updateState() {
    if (mounted) setState(() {});
  }

  @override
  void initState() {
    //super init
    super.initState();

    //set values
    updateFirstLast();

    //create listeners
    lastFunction.addListener(updateState);
    firstFunction.addListener(updateState);

    //make carousel
    carousel = CarouselSlider(
      initialPage: widget.predictionID.value,
      height: 36,
      enableInfiniteScroll: false,
      autoPlay: false,
      reverse: true,
      scrollDirection: Axis.vertical,
      viewportFraction: 1.0,
      onPageChanged: (int val) {
        Vibrator.vibrateOnce();
        widget.predictionID.value = val;
        updateFirstLast();
      },
      items: Functions.functions.map((functionName) {
        return Builder(
          builder: (BuildContext context) {
            return Center(
              child: Container(
                height: 36,
                child: Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Visibility(
                        visible: widget.middleArrows,
                        child: Icon(
                          Icons.arrow_drop_down,
                          color: functionName != Functions.functions[0]
                              ? null
                              : Theme.of(context).cardColor,
                        ),
                      ),
                      Text(
                        functionName,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Visibility(
                        visible: widget.middleArrows,
                        child: Icon(
                          Icons.arrow_drop_up,
                          color: functionName != Functions.functions[
                            Functions.functions.length - 1
                          ]
                              ? null
                              : Theme.of(context).cardColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      }).toList(),
    );
  }

  @override
  void dispose() {
    //remove listeners
    lastFunction.removeListener(updateState);
    firstFunction.removeListener(updateState);

    //dispose notifiers
    lastFunction.dispose();
    firstFunction.dispose();

    //super dispose
    super.dispose();
  }

  nextFunction() {
    carousel.nextPage(
      duration: Duration(milliseconds: 300),
      curve: Curves.bounceIn,
    );
  }

  prevFunction() {
    carousel.previousPage(
      duration: Duration(milliseconds: 300),
      curve: Curves.bounceIn,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.only(
        bottomRight: Radius.circular(12),
        bottomLeft: Radius.circular(12),
      ),
      child: Material(
        color: Colors.transparent,
        child: Stack(
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              child: Row(
                children: <Widget>[
                  Visibility(
                    visible: widget.middleArrows == false,
                    child: Icon(
                      Icons.arrow_drop_down,
                      color: firstFunction.value
                          ? Theme.of(context).primaryColorDark
                          : null,
                    ),
                  ),
                  Expanded(
                    child: carousel,
                  ),
                  Visibility(
                    visible: widget.middleArrows == false,
                    child: Icon(
                      Icons.arrow_drop_up,
                      color: lastFunction.value
                          ? Theme.of(context).primaryColorDark
                          : null,
                    ),
                  )
                ],
              ),
            ),
            Positioned.fill(
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: firstFunction.value ? null : () => prevFunction(),
                      child: Container(),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: lastFunction.value ? null : () => nextFunction(),
                      child: Container(),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
