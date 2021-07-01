import 'package:flutter/material.dart';
import 'package:swol/action/page.dart';
import 'package:swol/shared/methods/theme.dart';
import 'package:swol/shared/widgets/simple/listItem.dart';
import 'package:swol/shared/widgets/simple/ourHeaderIconPopUp.dart';

/*
requestThatYouGoToAppSettings(){
  BuildContext? globalBuildContext = ExercisePage.globalKey.currentContext;
   if (globalBuildContext != null) {
     double textScaleFactor = MediaQuery.of(globalBuildContext).textScaleFactor;
  showCustomHeaderIconPopUp(
       globalBuildContext,
       [
         Text(
           "Manually",
           style: TextStyle(
             fontSize: 24,
           ),
         ),
         Text(
           "Enable Notifications",
           style: TextStyle(
             fontSize: 24,
           ),
         ),
         Text(
           "In App Settings",
           style: TextStyle(
             fontSize: 18,
           ),
         ),
       ],
       [
         Padding(
           padding: EdgeInsets.symmetric(
             horizontal: 16,
           ),
           child: Column(
             mainAxisSize: MainAxisSize.min,
             children: [
               RichText(
                 textScaleFactor: textScaleFactor,
                 text: TextSpan(
                   style: TextStyle(
                     color: Colors.black,
                   ),
                   children: [
                     TextSpan(
                       text: "Since ",
                     ),
                     TextSpan(
                       text: "you manually disabled notifications",
                       style: TextStyle(
                         fontWeight: FontWeight.bold,
                       ),
                     ),
                     TextSpan(
                       text: ", you will need to manually re-enable them.\n\n",
                     ),
                     TextSpan(
                       text: "You can do so, by\n",
                     ),
                   ],
                 ),
               ),
               ListItem(
                 circleText: "1",
                 circleTextColor: Colors.white,
                 circleColor: Colors.blue,
                 content: RichText(
                   textScaleFactor: textScaleFactor,
                   text: TextSpan(
                     style: TextStyle(
                       color: Colors.black,
                     ),
                     children: [
                       TextSpan(
                         text: "Navigating to the ",
                       ),
                       TextSpan(
                         text: "App Info",
                         style: TextStyle(
                           fontWeight: FontWeight.bold,
                         ),
                       ),
                       TextSpan(
                         text: " page, with the button on the bottom right",
                       ),
                     ],
                   ),
                 ),
               ),
               ListItem(
                 circleText: "2",
                 circleTextColor: Colors.white,
                 circleColor: Colors.blue,
                 content: RichText(
                   textScaleFactor: textScaleFactor,
                   text: TextSpan(
                     style: TextStyle(
                       color: Colors.black,
                     ),
                     children: [
                       TextSpan(
                         text: "Scrolling to the ",
                       ),
                       TextSpan(
                         text: "App Settings Section",
                         style: TextStyle(
                           fontWeight: FontWeight.bold,
                         ),
                       ),
                     ],
                   ),
                 ),
               ),
               ListItem(
                 circleText: "3",
                 circleTextColor: Colors.white,
                 circleColor: Colors.blue,
                 content: RichText(
                   textScaleFactor: textScaleFactor,
                   text: TextSpan(
                     style: TextStyle(
                       color: Colors.black,
                     ),
                     children: [
                       TextSpan(
                         text: "Tapping ",
                       ),
                       TextSpan(
                         text: "Notifications",
                         style: TextStyle(
                           fontWeight: FontWeight.bold,
                         ),
                       ),
                     ],
                   ),
                 ),
               ),
               ListItem(
                 circleText: "4",
                 circleTextColor: Colors.white,
                 circleColor: Colors.blue,
                 content: RichText(
                   textScaleFactor: textScaleFactor,
                   text: TextSpan(
                     style: TextStyle(
                       color: Colors.black,
                     ),
                     children: [
                       TextSpan(
                         text: "Turning On ",
                       ),
                       TextSpan(
                         text: "Show notifications",
                         style: TextStyle(
                           fontWeight: FontWeight.bold,
                         ),
                       ),
                     ],
                   ),
                 ),
               ),
               ListItem(
                 circleText: "5",
                 circleTextColor: Colors.white,
                 circleColor: Colors.blue,
                 content: RichText(
                   textScaleFactor: textScaleFactor,
                   text: TextSpan(
                     style: TextStyle(
                       color: Colors.black,
                     ),
                     children: [
                       TextSpan(
                         text: "Making sure all the switches in the ",
                       ),
                       TextSpan(
                         text: "Categories Section",
                         style: TextStyle(
                           fontWeight: FontWeight.bold,
                         ),
                       ),
                       TextSpan(
                         text: " are set to On",
                       ),
                     ],
                   ),
                 ),
               ),
             ],
           ),
         ),
       ],
       Icon(
         Icons.settings,
         color: Colors.white,
       ),
       //animationType: null,
       headerBackground: MyTheme.dark.cardColor,
       dismissOnTouchOutside: automaticallyOpened == false,
       clearBtn: WillPopScope(
         onWillPop: () async {
           //negative action
           onDeny();

           //allow pop
           return true;
         },
         child: TextButton(
           child: new Text("Nevermind"),
           onPressed: () {
             //pop ourselves
             Navigator.of(
               globalBuildContext,
             ).pop();
             //show button if needed
             onDeny();
           },
         ),
       ),
       colorBtn: ElevatedButton(
         onPressed: () {
           openAppSettings();
           //NOTE: that complete WILL run not here
           //but it will run in the widget below
           //when we detect that you have given us permission
           //the pop up will be auto dismissed
           //and onComplete will run
         },
         child: PopOnResumeIfPermissionGranted(
           child: Text("App Info"),
           onComplete: onComplete,
         ),
       ),
     );
}
}
*/