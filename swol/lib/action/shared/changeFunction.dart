//flutter
import 'package:flutter/material.dart';

//plugin
import 'package:carousel_slider/carousel_slider.dart';
import 'package:swol/action/page.dart';
import 'package:swol/action/popUps/textValid.dart';

//internal
import 'package:swol/other/functions/helper.dart';
import 'package:swol/shared/methods/vibrate.dart';
import 'package:swol/shared/widgets/simple/conditional.dart';

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

  updateCarousel({bool alsoSetState: true}){
    //update first last without setting state
    int idIsAtHighest = ExercisePage.orderedIDs.value[0];
    int idIsAtLowest = ExercisePage.orderedIDs.value[7];
    firstFunction.value = (widget.functionID.value == idIsAtLowest);
    lastFunction.value = (widget.functionID.value == idIsAtHighest);

    //calc inital page
    int selectedID = widget.functionID.value;
    int selectedPage = ExercisePage.orderedIDs.value.indexOf(selectedID);
    
    //new carousel
    carousel = CarouselSlider(
      initialPage: selectedPage, //DOES NOT WORK initially after the first time
      height: 36,
      enableInfiniteScroll: false,
      autoPlay: false,
      scrollDirection: Axis.vertical,
      viewportFraction: 1.0,
      onPageChanged: (int selectedIndex) { //the index of the page not the ID of the function
        int selectedID = ExercisePage.orderedIDs.value[selectedIndex];
        if(widget.functionID.value != selectedID){
          Vibrator.vibrateOnce();
          widget.functionID.value = selectedID;
        }

        //updates outer arrows
        int idIsAtHighest = ExercisePage.orderedIDs.value[0];
        int idIsAtLowest = ExercisePage.orderedIDs.value[7];
        firstFunction.value = (widget.functionID.value == idIsAtLowest);
        lastFunction.value = (widget.functionID.value == idIsAtHighest);
      },
      items: ExercisePage.orderedIDs.value.map((functionID){
        return Builder(
          builder: (BuildContext context) {
            //no matter what this is going to span the entirety of the space
            return Center(
              child: Container(
                height: 36,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Visibility(
                      visible: widget.middleArrows,
                      child: InnerArrows(
                        hideArrow: functionID == idIsAtLowest,
                        functionID: functionID,
                        isUpArrow: false,
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
                      child: InnerArrows(
                        hideArrow: functionID == idIsAtHighest,
                        functionID: functionID,
                        isUpArrow: true,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }).toList(),
    );

    //set state if needed
    if(alsoSetState){
      //show this new carousel
      setState(() {});

      //TODO: figure out why I need this
      //wait one frame to set the initial page since the initial page parameter doesn't work
      WidgetsBinding.instance.addPostFrameCallback((_){
        carousel.jumpToPage(selectedPage);
      });
    }
    //ELSE: the carousel is being build in init
  }

  @override
  void initState() {
    //super init
    super.initState();

    //make carousel (and also sets first and last)
    updateCarousel(alsoSetState: false);

    //create listeners
    ExercisePage.orderedIDs.addListener(updateCarousel);
  }

  @override
  void dispose() {
    //remove listeners
    ExercisePage.orderedIDs.removeListener(updateCarousel);

    //super dispose
    super.dispose();
  }

  upOneFunction() {
    if(firstFunction.value == false){
      carousel.nextPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.bounceIn,
      );
    }
  }

  downOneFunction() {
    if(lastFunction.value == false){
      carousel.previousPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.bounceIn,
      );
    }
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
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: Stack(
            children: <Widget>[
              Conditional(
                condition: widget.middleArrows, 
                ifTrue: carousel,
                ifFalse: Row(
                  children: <Widget>[
                    OuterArrows(
                      disabled: firstFunction, 
                      icon: Icons.arrow_drop_down,
                    ),
                    Expanded(
                      child: carousel,
                    ),
                    OuterArrows(
                      disabled: lastFunction, 
                      icon: Icons.arrow_drop_up,
                    ),
                  ],
                ),
              ),
              Positioned.fill(
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: () => upOneFunction(),
                        child: Container(),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: () => downOneFunction(),
                        child: Container(),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class OuterArrows extends StatefulWidget {
  OuterArrows({
    @required this.disabled,
    @required this.icon,
  });

  final ValueNotifier<bool> disabled;
  final IconData icon;

  @override
  _OuterArrowsState createState() => _OuterArrowsState();
}

class _OuterArrowsState extends State<OuterArrows> {
  updateState(){
    if(mounted) setState(() {});
  }

  @override
  void initState() {
    //super init
    super.initState();

    //listne to changes
    widget.disabled.addListener(updateState);
  }

  @override
  void dispose() { 
    //stop listening
    widget.disabled.removeListener(updateState);

    //super dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Icon(
      widget.icon,
      color: widget.disabled.value ? Theme.of(context).primaryColorDark : null,
    );
  }
}

class InnerArrows extends StatefulWidget {
  InnerArrows({
    @required this.functionID,
    @required this.isUpArrow,
    @required this.hideArrow,
  });

  final int functionID;
  final bool isUpArrow;
  final bool hideArrow;

  @override
  _InnerArrowsState createState() => _InnerArrowsState();
}

class _InnerArrowsState extends State<InnerArrows> {
  updateState(){
    if(mounted) setState(() {});
  }

  @override
  void initState() {
    super.initState();
    ExercisePage.closestIndex.addListener(updateState);
  }

  @override
  void dispose() { 
    ExercisePage.closestIndex.removeListener(updateState);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Color arrowColor;

    //check if the set is valid
    bool weightValid = isTextValid(ExercisePage.setWeight.value);
    bool repsValid = isTextValid(ExercisePage.setReps.value);
    bool setValid = weightValid && repsValid;

    //if it is then we may have a closestIndex
    if(setValid){
      //if the closestIndex is something valid
      int lastClosestIndex = ExercisePage.closestIndex.value;
      if(lastClosestIndex != -1){ 
        //if we arent the closest function then prompt the user to change
        int closestFunctionID = ExercisePage.orderedIDs.value[lastClosestIndex];
        if(widget.functionID != closestFunctionID){
          print("*****************not matching");
          int ourIndex = ExercisePage.orderedIDs.value.indexOf(widget.functionID);
          bool targetIsDown = (lastClosestIndex > ourIndex);
          //color arrow if called for
          if(widget.isUpArrow && targetIsDown == false) arrowColor = Colors.red;
          else if(widget.isUpArrow == false && targetIsDown) arrowColor = Colors.red;
        }
      }
    }
    
    return Icon(
      widget.isUpArrow ?  Icons.arrow_drop_up : Icons.arrow_drop_down,
      color: widget.hideArrow ? Theme.of(context).cardColor : arrowColor,
    );
  }
}