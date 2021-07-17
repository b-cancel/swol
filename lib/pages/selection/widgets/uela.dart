//flutter
import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

//internal: shared
import 'package:swol/shared/methods/extensions/sharedPreferences.dart';
import 'package:swol/shared/methods/vibrate.dart';
import 'package:swol/shared/methods/theme.dart';

//internal: utils
import 'package:swol/shared/widgets/simple/popUpAdjustments.dart';
import 'package:swol/shared/widgets/simple/triangleAngle.dart';
import 'package:swol/shared/widgets/simple/playOnceGif.dart';

import 'package:flutter_markdown/flutter_markdown.dart';

import '../../../policyDialog.dart';

//widget
class UELA extends StatefulWidget {
  UELA({
    required this.afterConfirm,
  });

  final Function afterConfirm;

  @override
  _UELAState createState() => _UELAState();
}

class _UELAState extends State<UELA> {
  final ValueNotifier<bool> holding = new ValueNotifier<bool>(false);

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: MyTheme.light,
      child: WillPopScope(
        onWillPop: () async {
          //close the app
          SystemChannels.platform.invokeMethod('SystemNavigator.pop');

          //dont allow pop up to go away
          return false;
        },
        child: AlertDialog(
          backgroundColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12.0)),
          ),
          contentPadding: EdgeInsets.all(0),
          content: UelaBody(
            holding: holding,
            afterConfirm: widget.afterConfirm,
          ),
        ),
      ),
    );
  }
}

class UelaBody extends StatelessWidget {
  const UelaBody({
    Key? key,
    required this.holding,
    required this.afterConfirm,
  }) : super(key: key);

  final ValueNotifier<bool> holding;
  final Function afterConfirm;

  @override
  Widget build(BuildContext context) {
    String tab = "\t\t\t\t\t";
    return ClipRRect(
      borderRadius: new BorderRadius.all(
        Radius.circular(12.0),
      ),
      child: ScrollViewWithShadow(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Stack(
              children: <Widget>[
                TopPicture(),
                Positioned.fill(
                  child: Center(
                    child: AnimatedBuilder(
                      animation: holding,
                      //no reusable child
                      builder: (context, child) {
                        return Visibility(
                          visible: holding.value,
                          child: TheCountDown(
                            afterConfirm: afterConfirm,
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(8),
                ),
              ),
              child: Column(
                children: [
                  TitleThatContainsTRBL(
                    hasTopIcon: true,
                    child: Column(
                      children: <Widget>[
                        Text(
                          "End User License",
                          style: TextStyle(
                            fontSize: 28,
                          ),
                        ),
                        Text(
                          "Agreement",
                          style: TextStyle(
                            fontSize: 28,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        RichText(
                          textScaleFactor: MediaQuery.of(
                            context,
                          ).textScaleFactor,
                          text: TextSpan(
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                            ),
                            children: [
                              TextSpan(
                                text: tab +
                                    "In order to help you, we offer many suggestions throughout the app.",
                              ),
                              TextSpan(
                                text:
                                    " But it's your responsibility to stay safe.",
                                style: TextStyle(
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            top: 12.0,
                          ),
                          child: RichText(
                            textScaleFactor: MediaQuery.of(
                              context,
                            ).textScaleFactor,
                            text: TextSpan(
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                              ),
                              children: [
                                TextSpan(
                                  text: tab +
                                      "We are not liable for any harm that you may cause yourself or others by following our suggestions.",
                                ),
                                TextSpan(
                                  text:
                                      " Follow our suggestions at your own risk.",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            top: 12.0,
                          ),
                          child: RichText(
                            textScaleFactor: MediaQuery.of(
                              context,
                            ).textScaleFactor,
                            text: TextSpan(
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                              ),
                              children: [
                                TextSpan(
                                  text: tab + "Read our ",
                                ),
                                TextSpan(
                                  text: " Privacy Policy Here",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w900,
                                    color: Colors.blue,
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          return PolicyDialog(
                                            mdFileName: 'privacyPolicy.md',
                                          );
                                        },
                                      );
                                    },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  BottomButtonsThatResizeTRBL(
                    hasTopIcon: false,
                    secondary: TextButton(
                      onPressed: () {
                        //close the app, don't restart, encourage good behavior of sending and exiting right after done
                        SystemChannels.platform
                            .invokeMethod('SystemNavigator.pop');

                        //this work on ios but isn't allowed, and seems like a crash on android
                        //exit(0);
                      },
                      child: Text("Close App"),
                    ),
                    primary: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTapDown: (tapDownDetails) {
                        holding.value = true;
                      },
                      onTapUp: (tapUpDetails) {
                        holding.value = false;
                      },
                      child: IgnorePointer(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Theme.of(context).accentColor,
                          ),
                          onPressed: () {},
                          child: Text(
                            "Hold To Agree",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TheCountDown extends StatelessWidget {
  const TheCountDown({
    required this.afterConfirm,
    Key? key,
  }) : super(key: key);

  final Function afterConfirm;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.75),
            shape: BoxShape.circle,
          ),
          padding: EdgeInsets.all(16),
          child: DefaultTextStyle(
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(
                    top: 24,
                  ),
                  child: Text(
                    "Hold To Agree",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                BasicCountDown(
                  seconds: 3,
                  afterConfirm: () => afterConfirm(),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class TopPicture extends StatelessWidget {
  const TopPicture({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned.fill(
            child: Container(
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: [
                  Flexible(
                    flex: 1,
                    child: Container(),
                  ),
                  Flexible(
                    flex: 1,
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(8),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            padding: EdgeInsets.all(8),
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).accentColor,
                shape: BoxShape.circle,
              ),
              height: 175,
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
          ),
        ],
      ),
    );
  }
}

class BasicCountDown extends StatefulWidget {
  BasicCountDown({
    required this.seconds,
    required this.afterConfirm,
  });

  final int seconds;
  final Function afterConfirm;

  @override
  _BasicCountDownState createState() => _BasicCountDownState();
}

class _BasicCountDownState extends State<BasicCountDown>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;

  updateState() {
    if (mounted) setState(() {});
  }

  vibrateOnComplete(AnimationStatus status) async {
    if (status == AnimationStatus.completed) {
      //vibrate to let the user know they are done
      Vibrator.vibrateOnce();
      //agree
      SharedPrefsExt.setTermsAgreed(true);
      //pop the agreement pop up
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
    if (controller.isAnimating) {
      //TODO: confirm fix
      Duration timePassed = controller.lastElapsedDuration ?? Duration.zero;
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
    } else {
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
