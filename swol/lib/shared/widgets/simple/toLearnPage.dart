//flutter
import 'package:flutter/material.dart';

//plugin
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:page_transition/page_transition.dart';

//internal
import 'package:swol/pages/learn/page.dart';
import 'package:swol/main.dart';

//we don't need to do anything complex to get to the main page
//all we have to do is pass to this widget the ammount of time we have to pop
//every page should react accordingly to its pop

//in the case of the add excercise page 
//the pop OF THIS TYPE should cause settings to be saved for reloading later

//the simply navigate to the learn page
class SuggestToLearnPage extends StatelessWidget {
  goToLearn(){
    BuildContext rootContext = GrabSystemPrefs.rootContext;
    if(Navigator.canPop(rootContext)){
      //pop with the animation
      Navigator.pop(rootContext);

      //let the user see the animation
      Future.delayed(Duration(milliseconds: 300),(){
        goToLearn();
      });
    }
    else{
      App.navSpread.value = true;
      Navigator.push(
        rootContext, 
        PageTransition(
          type: PageTransitionType.rightToLeft, 
          child: LearnExcercise(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => goToLearn(),
        child: Container(
          padding: EdgeInsets.only(
            left: 24,
            right: 24,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              RichText(
                text: TextSpan(
                  style: TextStyle(
                    color: Colors.black,
                  ),
                  children: [
                    TextSpan(
                      text: "To Learn More\n",
                    ),
                    TextSpan(
                      text: "Tap Here",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(
                      text: " to visit the ",
                    ),
                    TextSpan(
                      text: "Learn",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(
                      text: " page",
                    ),
                  ]
                ),
              ),
              Icon(
                FontAwesomeIcons.leanpub,
                color: Colors.black,
              ),
            ],
          ),
        ),
      ),
    );
  }
}