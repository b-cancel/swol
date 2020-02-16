//flutter
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

//internal: shared
import 'package:swol/shared/methods/extensions/sharedPreferences.dart';
import 'package:swol/shared/methods/vibrate.dart';
import 'package:swol/shared/methods/theme.dart';

//internal: utils
import 'package:swol/shared/widgets/simple/triangleAngle.dart';
import 'package:swol/shared/widgets/simple/playOnceGif.dart';

//widget
class UELA extends StatefulWidget {
  UELA({
    @required this.afterConfirm,
  });

  final Function afterConfirm;

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
    Widget holdWidget = Container();

    Color theColor = Colors.blue;
    //Color(0xFF33C3D5);

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
                    afterConfirm: () => widget.afterConfirm(),
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
      data: MyTheme.light,
      child: AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(12.0)
          ),
        ),
        contentPadding: EdgeInsets.all(0),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Stack(
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    color: theColor,
                    borderRadius: new BorderRadius.only(
                      topLeft:  const  Radius.circular(12.0),
                      topRight: const  Radius.circular(12.0),
                    ),
                  ),
                  padding: EdgeInsets.only(
                    top: 8,
                  ),
                  child: ClipOval(
                    child: PlayGifOnce( 
                      assetName: "assets/popUpGifs/agree.gif",
                      runTimeMS: 2370,
                      frameCount: 70,
                      colorWhite: false,
                    ),
                  ),
                ),
                Positioned.fill(
                  child: Center(
                    child: holdWidget,
                  ),
                ),
              ],
            ),
            Stack(
              children: <Widget>[
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 16.0,
                        bottom: 8,
                      ),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16,
                        ),
                        child: DefaultTextStyle(
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                            color: Colors.black,
                          ),
                          child: Column(
                            children: <Widget>[
                              Text("End User License"),
                              Text("Agreement"),
                            ],
                          ),
                        ),
                      ),
                    ),
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
                  ],
                ),
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
                      child: Text("Close App"),
                    ),
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
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
                          color: theColor,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          "Hold To Agree",
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
        )
      ),
    );
  }
}

class BasicCountDown extends StatefulWidget {
  BasicCountDown({
    @required this.seconds,
    @required this.afterConfirm,
  });

  final int seconds;
  final Function afterConfirm;

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
      Vibrator.vibrateOnce(); 
      //give permission
      SharedPrefsExt.setTermsAgreed(true);
      //pop the permission pop up
      Navigator.of(context).pop();
      //start showing basic features (if they haven't yet been shown)
      widget.afterConfirm();
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