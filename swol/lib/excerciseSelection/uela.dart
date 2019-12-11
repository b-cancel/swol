import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:swol/utils/onboarding.dart';

class UELA extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String tab = "\t\t\t\t\t";
    String newLine = "\n\n";

    return Theme(
      data: ThemeData.light(),
      child: SimpleDialog(
        contentPadding: EdgeInsets.all(0),
        children: <Widget>[
          Container(
            color: Colors.red,
            padding: EdgeInsets.all(16),
            child: Text(
              "User End License Agreement",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
                color: Colors.white,
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(16),
            child: RichText(
              text: TextSpan(
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                ),
                children: [
                  TextSpan(
                    text: tab + "In order to assist you, there are many suggestions throughout the app."
                  ),
                  TextSpan(
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                    ),
                    text: newLine + tab + "But it's your responsibility\nto stay safe.",
                  ),
                  TextSpan(
                    text: newLine + tab + "We are not liable for any harm that you may cause yourself or others."
                  ),
                  TextSpan(
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                    ),
                    text: newLine + tab + "Follow our suggestions\nat your own risk.",
                  ),
                ]
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(16),
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
                /*
                HoldDetector(
                    onHold: _incrementCounter,
                    holdTimeout: Duration(milliseconds: 200),
                    enableHapticFeedback: true,
                    child: RaisedButton(
                      child: Text("I Agree"),
                      onPressed: _incrementCounter,
                  ),
                ),
                */
                RaisedButton(
                  onPressed: ()async{
                    await OnBoarding.givePermission();
                    Navigator.of(context).pop();
                    OnBoarding.discoverBasicFeatures();
                  },
                  child: Text("I Agree"),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}