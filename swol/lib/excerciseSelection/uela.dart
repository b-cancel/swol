//flutter
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

//packages
import 'package:flutter_icons/flutter_icons.dart';
import 'package:swol/sharedWidgets/excerciseListTile/triangleAngle.dart';
import 'package:swol/utils/onboarding.dart';

//internal
import 'package:swol/utils/vibrate.dart';

class UELA extends StatefulWidget {
  @override
  _UELAState createState() => _UELAState();
}

class _UELAState extends State<UELA> {
  final ValueNotifier<bool> holding = new ValueNotifier<bool>(false);

  updateState(){
    if(mounted) setState(() {});
  }

  @override
  void initState(){ 
    holding.addListener(updateState);
    super.initState();
  }

  @override
  void dispose(){ 
    holding.removeListener(updateState);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String tab = "\t\t\t\t\t";
    String newLine = "\n";
    Widget holdWidget = Container();
    if(holding.value){
      holdWidget = Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.75),
              borderRadius: BorderRadius.circular(12),
            ),
            padding: EdgeInsets.all(16),
            child: DefaultTextStyle(
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
              child: Column(
                children: <Widget>[
                  Text(
                    "Hold To Agree",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  BasicCountDown(
                    seconds: 3,
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    }

    //build
    return Theme(
      data: ThemeData.light(),
      child: SimpleDialog(
        contentPadding: EdgeInsets.all(0),
        children: <Widget>[
          Container(
            color: Colors.black.withOpacity(0.85),
            padding: EdgeInsets.all(16),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: Text(
                    "End User\nLicense Agreement",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                      color: Colors.white,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.visible,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 8.0,
                  ),
                  child: Icon(
                    MaterialCommunityIcons.getIconData("file-document-edit"),
                    color: Colors.white,
                    size: 32,
                  ),
                ),
              ],
            ),
          ),
          Stack(
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(16),
                child: DefaultTextStyle(
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      RichText(
                        text: TextSpan(
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                          ),
                          children: [
                            TextSpan(
                              text: tab + "In order to help you, we offer many suggestions throughout the app.",
                            ),
                            TextSpan(
                              text: " But it's your responsibility to stay safe.",
                              style: TextStyle(
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ]
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          top: 12.0,
                        ),
                        child: RichText(
                          text: TextSpan(
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                            ),
                            children: [
                              TextSpan(
                                text: tab + "We are not liable for any harm that you may cause yourself or others by following our suggestions.",
                              ),
                              TextSpan(
                                text: " Follow our suggestions at your own risk.",
                                style: TextStyle(
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ]
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned.fill(
                child: Center(
                  child: holdWidget,
                ),
              )
            ],
          ),
          Padding(
            padding: EdgeInsets.only(
              bottom: 8.0,
            ),
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: 16,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  FlatButton(
                    onPressed: (){
                      SystemChannels.platform.invokeMethod('SystemNavigator.pop');
                    },
                    child: Text("Close The App"),
                  ),
                  GestureDetector(
                    onTapDown: (tapDownDetails){
                      holding.value = true;
                    },
                    onTapUp: (tapUpDetails){
                      holding.value = false;
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        "I Agree",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class BasicCountDown extends StatefulWidget {
  BasicCountDown({
    @required this.seconds,
  });

  final int seconds;

  @override
  _BasicCountDownState createState() => _BasicCountDownState();
}

class _BasicCountDownState extends State<BasicCountDown> with SingleTickerProviderStateMixin{
  AnimationController controller;

  updateState(){
    if(mounted) setState(() {});
  }

  vibrateOnComplete(AnimationStatus status)async{
    if(status == AnimationStatus.completed){
      //vibrate to let the user know they are done
      Vibrator.vibrate(); 
      //give permission
      await OnBoarding.givePermission();
      //pop the permission pop up
      Navigator.of(context).pop();
      //start showing basic features (if they haven't yet been shown)
      OnBoarding.discoverSwolLogo(context);
    }
  }

  @override
  void initState() { 
    controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: widget.seconds),
    );
    controller.addListener(updateState);
    controller.addStatusListener(vibrateOnComplete);
    controller.forward();
    super.initState();
  }

  @override
  void dispose() {
    controller.removeStatusListener(vibrateOnComplete);
    controller.removeListener(updateState);
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double progress;
    Widget centerWidget;
    if(controller.isAnimating){
      Duration timePassed = controller.lastElapsedDuration;
      int secondsPassed = timePassed.inSeconds;
      int secondsLeft = widget.seconds - secondsPassed;
      Duration msLeft = timePassed - Duration(seconds: secondsPassed);

      //calculate progress
      progress = msLeft.inMilliseconds / Duration(seconds: 1).inMilliseconds;

      //output widget
      centerWidget = Text(
        secondsLeft.toString(),
        style: TextStyle(
          color: Colors.black,
          fontSize: 24,
        ),
      );
    }
    else{
      progress = 1;

      //output widget
      centerWidget = Icon(
        Icons.check,
        size: 24,
        color: Colors.black,
      );
    }
     
    return Padding(
      padding: EdgeInsets.only(
        top: 8.0,
      ),
      child: Container(
        width: 48,
        height: 48,
        child: Stack(
          children: <Widget>[
            ClipOval(
              child: Container(
                color: Colors.white.withOpacity(0.75),
              ),
            ),
            (progress == 1) 
            ? ClipOval(
              child: Container(
                color: Colors.white,
              ),
            )
            : ClipOval(
              child: TriangleAngle(
                size: 48,
                start: 0.0,
                end: progress * 360,
                color: Colors.white,
              ),
            ),
            Center(
              child: centerWidget,
            ),
          ],
        ),
      ),
    );
  }
}