//flutter
import 'package:flutter/material.dart';

//internal
import 'package:swol/shared/widgets/complex/trainingTypeTables/trainingTypes.dart';
import 'package:swol/shared/widgets/simple/toLearnPage.dart';
import 'package:swol/shared/widgets/simple/listItem.dart';
import 'package:swol/shared/methods/theme.dart';

//widget
class RecoveryTimePopUpBody extends StatelessWidget {
  const RecoveryTimePopUpBody({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 24.0,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                alignment: Alignment.centerLeft,
                child: Text("To select the appropiate recovery time\n"),
              ),
              ListItem(
                circleColor: Colors.blue,
                circleText: "1",
                circleTextColor: Colors.white,
                content: RichText(
                  textScaleFactor: MediaQuery.of(
                    context,
                  ).textScaleFactor,
                  text: TextSpan(
                      style: TextStyle(
                        color: Colors.black,
                      ),
                      children: [
                        TextSpan(
                          text: "Select the ",
                        ),
                        TextSpan(
                            text: "training type",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            )),
                        TextSpan(text: " you are working towards"),
                      ]),
                ),
              ),
              ListItem(
                circleColor: Colors.blue,
                circleText: "2",
                circleTextColor: Colors.white,
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    RichText(
                      textScaleFactor: MediaQuery.of(
                        context,
                      ).textScaleFactor,
                      text: TextSpan(
                          style: TextStyle(
                            color: Colors.black,
                          ),
                          children: [
                            TextSpan(
                              text: "Select a ",
                            ),
                            TextSpan(
                              text: "larger recovery time ",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(
                                text: "within the training type's range",
                                style: TextStyle(
                                  decoration: TextDecoration.underline,
                                )),
                            TextSpan(
                              text: " if you are working with ",
                            ),
                            TextSpan(
                              text: "larger muscle groups\n",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ]),
                    ),
                    RichText(
                      textScaleFactor: MediaQuery.of(
                        context,
                      ).textScaleFactor,
                      text: TextSpan(
                          style: TextStyle(
                            color: Colors.black,
                          ),
                          children: [
                            TextSpan(
                              text: "Select a ",
                            ),
                            TextSpan(
                              text: "smaller recovery time ",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(
                                text: "within the training type's range",
                                style: TextStyle(
                                  decoration: TextDecoration.underline,
                                )),
                            TextSpan(
                              text: " if you are working with ",
                            ),
                            TextSpan(
                              text: "smaller muscle groups",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ]),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Theme(
          data: MyTheme.dark,
          child: Padding(
            padding: EdgeInsets.symmetric(
              vertical: 8,
            ),
            child: AllTrainingTypes(
              highlightField: 2,
            ),
          ),
        ),
        SuggestToLearnPage(),
      ],
    );
  }
}
