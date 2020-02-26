//flutter
import 'package:flutter/material.dart';

//plugin
import 'package:carousel_slider/carousel_slider.dart';
import 'package:swol/action/page.dart';

//internal
import 'package:swol/other/functions/helper.dart';
import 'package:swol/shared/methods/vibrate.dart';

//NOTE: should not dispose predictionID since the value was passed
class ChangeFunction extends StatefulWidget {
  ChangeFunction({
    @required this.functionID,
    @required this.middleArrows,
  });

  final ValueNotifier<int> functionID;
  final bool middleArrows;

  @override
  _ChangeFunctionState createState() => _ChangeFunctionState();
}

class _ChangeFunctionState extends State<ChangeFunction> {
  final ValueNotifier<bool> lastFunction = new ValueNotifier<bool>(false);
  final ValueNotifier<bool> firstFunction = new ValueNotifier<bool>(false);

  var carousel;

  updateCarousel(){
    print("working with order: " + ExcercisePage.orderedIDs.value.toString());

    //update first last without setting state
    int idIsAtHighest = ExcercisePage.orderedIDs.value[0];
    int idIsAtLowest = ExcercisePage.orderedIDs.value[7];
    firstFunction.value = (widget.functionID.value == idIsAtLowest);
    lastFunction.value = (widget.functionID.value == idIsAtHighest);

    //calc inital page
    int selectedID = widget.functionID.value;
    int selectedPage = ExcercisePage.orderedIDs.value.indexOf(selectedID);
    
    //new carousel
    carousel = CarouselSlider(
      initialPage: selectedPage, //DOES NOT WORK initially after the first time
      height: 36,
      enableInfiniteScroll: false,
      autoPlay: false,
      scrollDirection: Axis.vertical,
      viewportFraction: 1.0,
      onPageChanged: (int selectedIndex) { //the index of the page not the ID of the function
        Vibrator.vibrateOnce();
        widget.functionID.value = ExcercisePage.orderedIDs.value[selectedIndex];
        updateFirstLast();
      },
      items: ExcercisePage.orderedIDs.value.map((functionID) {
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
                          color: functionID != idIsAtLowest
                              ? null
                              : Theme.of(context).cardColor,
                        ),
                      ),
                      Text(
                        Functions.functions[functionID],
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Visibility(
                        visible: widget.middleArrows,
                        child: Icon(
                          Icons.arrow_drop_up,
                          color: functionID != idIsAtHighest
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

    //show this new carousel
    setState(() {});

    //TODO: figure out why I need this
    //wait one frame to set the initial page since the initial page parameter doesn't work
    WidgetsBinding.instance.addPostFrameCallback((_){
      carousel.jumpToPage(selectedPage);
    });
  }

  updateFirstLast() {
    int idIsAtHighest = ExcercisePage.orderedIDs.value[0];
    int idIsAtLowest = ExcercisePage.orderedIDs.value[7];
    firstFunction.value = (widget.functionID.value == idIsAtLowest);
    lastFunction.value = (widget.functionID.value == idIsAtHighest);
  }

  updateState() {
    if (mounted) setState(() {});
  }

  @override
  void initState() {
    //super init
    super.initState();

    //make carousel (and also sets first and last)
    updateCarousel();

    //create listeners
    ExcercisePage.orderedIDs.addListener(updateCarousel);
    lastFunction.addListener(updateState);
    firstFunction.addListener(updateState);
  }

  @override
  void dispose() {
    //remove listeners
    lastFunction.removeListener(updateState);
    firstFunction.removeListener(updateState);
    ExcercisePage.orderedIDs.removeListener(updateCarousel);

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
                      onTap: firstFunction.value ? null : () => nextFunction(),
                      child: Container(),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: lastFunction.value ? null : () => prevFunction(),
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
