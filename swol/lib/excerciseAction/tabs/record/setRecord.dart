import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:swol/excerciseAction/tabs/sharedWidgets/bottomButtons.dart';
import 'package:swol/excerciseAction/tabs/suggest/suggestion.dart';

//TODO: use directionality widget to switch start direction "directionality" 

class SetRecord extends StatelessWidget {
  SetRecord({
    @required this.excerciseID,
    @required this.backToSuggestion,
    @required this.setBreak,
    @required this.statusBarHeight,
  });

  final int excerciseID;
  final Function backToSuggestion;
  final Function setBreak;
  final double statusBarHeight;

  @override
  Widget build(BuildContext context) {
    double fullHeight = MediaQuery.of(context).size.height;
    double appBarHeight = 56; //constant according to flutter docs
    double spaceToRedistribute = fullHeight - appBarHeight - statusBarHeight ;

    return Container(
      width: fullHeight,
      child: Stack(
        children: <Widget>[
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: BottomButtons(
              forwardAction: setBreak,
              forwardActionWidget: Text(
                "Take Set Break",
                style: TextStyle(
                  color: Theme.of(context).primaryColorDark,
                ),
              ),
              backAction: backToSuggestion,
            ),
          ),
          Positioned(
            top: 0,
            child: SetRecordCardBottom(
              rawSpaceToRedistribute: spaceToRedistribute,
            ),
          ),
        ],
      ),
    );
  }
}

class SetRecordCardBottom extends StatelessWidget {
  const SetRecordCardBottom({
    Key key,
    @required this.rawSpaceToRedistribute,
    this.removeBottomButtonSpacing: true,
    this.extraSpacing: 24,
  }) : super(key: key);

  final double rawSpaceToRedistribute;
  final double extraSpacing;
  final bool removeBottomButtonSpacing;

  @override
  Widget build(BuildContext context) {
    double spaceToRedistribute = rawSpaceToRedistribute;

    //make instinct based removals since all the UI is semi contected
    spaceToRedistribute -= extraSpacing;
    if(removeBottomButtonSpacing){
      //NOTE: 64 is the height of the bottom buttons
      spaceToRedistribute -= 64;
    }

    //the recorded set that will ofcourse in the final product change
    int weight = 9999;
    int reps = 888;
    
    //card radius
    Radius cardRadius = Radius.circular(24);

    //calculate golden ratios
    List<double> bigToSmall = [
      rawSpaceToRedistribute * (2/3),
      rawSpaceToRedistribute * (1/3),
    ];

    List<double> secondBigToSmall = [
      bigToSmall[1] * (2/3),
      bigToSmall[1] * (1/3),
    ];

    //actual card data
    Widget actualCard = Container(
      padding: EdgeInsets.symmetric(
        horizontal: 24,
        vertical: 16,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.only(
          topRight: cardRadius,
          bottomRight: cardRadius,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "Record Set",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 48,
            ),
          ),
          OutlineTextField(
            weight: weight,
          ),
          OutlineTextField(
            weight: reps,
            isWeight: false,
          ),
        ],
      ),
    );

    return Container(
      //The extra padding that just looked right
      height: spaceToRedistribute - 12,
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            color: Theme.of(context).cardColor,
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).accentColor,
                borderRadius: BorderRadius.only(
                  bottomLeft: cardRadius,
                  bottomRight: cardRadius,
                ),
              ),
              width: MediaQuery.of(context).size.width,
              height: 24,
            ),
          ),
          Hero(
            tag: 'goalSet',
            child: Container(
              height: secondBigToSmall[0],
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.only(
                    bottomRight: cardRadius,
                    bottomLeft: cardRadius,
                  ),
                ),
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.all(16),
                child: ShowSet(
                  lastWeight: 160, 
                  lastReps: 8,
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(),
          ),
          actualCard,
        ],
      ),
    );
    
    

    
    /*
    //build
    return Container(
      height: spaceToRedistribute,
      width: MediaQuery.of(context).size.width,
      //child: actualCard,
      
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Container(
            color: Theme.of(context).cardColor,
            height: heightBigSmall[1] - 8,
            width: MediaQuery.of(context).size.width,
          ),
          Container(
            height: 16,
            //color: Colors.red,
            width: MediaQuery.of(context).size.width,
            alignment: Alignment.center,
            child: OverflowBox(
              alignment: Alignment.center,
              //NOTE: we are working from the center of our space
              //the largest box we can have at that point without overflowing from up top
              //is going to be double the size of the smaller portion
              //this works but then whatever we fit into it we also need to account for atleast a 16 pixel padding on top and bottom
              maxHeight: heightBigSmall[1] * 2,
              minHeight: 0,
              child: Container(
                height: heightBigSmall[1] * 2,
                child: Padding(
                  padding: EdgeInsets.only(
                    top: 16,
                  ),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxHeight: heightBigSmall[1] * 2 - 16,
                      ),
                      child: actualCard,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Container(
            height: heightBigSmall[0] - 8,
            width: MediaQuery.of(context).size.width,
          ),
        ],
      ),
      
    );
    */
  }
}

class OutlineTextField extends StatelessWidget {
  const OutlineTextField({
    Key key,
    @required this.weight,
    this.isWeight: true,
  }) : super(key: key);

  final int weight;
  final bool isWeight;

  @override
  Widget build(BuildContext context) {
    double fontSize = 72;
    double difference = 24;
    double difference2 = 16;

    return Container(
      padding: EdgeInsets.only(
        top: 8,
      ),
      child: IntrinsicHeight(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              decoration: new BoxDecoration(
                border: new Border.all(
                  color: Theme.of(context).primaryColorDark, 
                  width: 4.0,
                ),
                borderRadius: new BorderRadius.circular(6.0),
              ),
              padding: EdgeInsets.all(4),
              child: Text(
                isWeight ? "9____" : "8___",
                style: TextStyle(
                  fontSize: fontSize + (isWeight ? difference2 : 0),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(
                left: 8
              ),
              //color: Colors.red,
              child: isWeight 
              ? Container(
                alignment: Alignment.bottomLeft,
                padding: EdgeInsets.only(
                  bottom: 8,
                  right: 16,
                ),
                child: Icon(
                  FontAwesomeIcons.dumbbell,
                  size: fontSize - difference,
                ),
              )
              : DefaultTextStyle(
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
                child: DefaultTextStyle(
                  style: TextStyle(
                    fontSize: fontSize - difference * 2,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text("successfully"),
                      Text("completed"),
                      Text("lifts"),
                    ],
                  ),
                ),
              )
            ),
          ],
        ),
      ),
    );
  }
}