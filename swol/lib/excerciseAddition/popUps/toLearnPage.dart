//flutter
import 'package:flutter/material.dart';

//plugin
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:swol/learn/learn.dart';

//TODO: actually link up to the learn page

//we don't need to do anything complex to get to the main page
//all we have to do is pass to this widget the ammount of time we have to pop
//every page should react accordingly to its pop

//in the case of the add excercise page 
//the pop OF THIS TYPE should cause settings to be saved for reloading later

//the simply navigate to the learn page
class LearnPageSuggestion extends StatelessWidget {
  const LearnPageSuggestion({
    Key key,
  }) : super(key: key);

  //TODO: wait a little bit between transitions so users know whats up
  goToLearn(BuildContext context){
    if(Navigator.of(context).canPop()){
      Navigator.of(context).pop();
      goToLearn(context);
    }
    else{
      //TODO: properly handle the below
      //navSpread.value = true;
      Navigator.push(
        context, 
        PageTransition(
          type: PageTransitionType.rightToLeft, 
          child: LearnExcercise(
            //TODO: change these
            navSpread: new ValueNotifier(false),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    //TODO: keep poping until we can't pop no mo
    //TODO: then push the learn page

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => goToLearn(context),
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