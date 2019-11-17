import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

class ToBreath extends StatelessWidget {
  const ToBreath({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        Navigator.push(
          context, 
          PageTransition(
            type: PageTransitionType.fade, 
            child: Breath(),
          ),
        );
      },
      child: Padding(
        padding: EdgeInsets.all(
          16,
        ),
        child: Container(
          width: 50,
          height: 50,
          child: Hero(
            tag: 'breath',
            child: new Image(
              image: new AssetImage("assets/gifs/breathMod.gif"),
              //lines being slightly distinguishable is ugly
              color: Theme.of(context).accentColor,
            ),
          ),
        ),
      ),
    );
  }
}

class Breath extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: FlatButton(
          onPressed: (){
            Navigator.of(context).pop();
          },
          child: Container(
            padding: EdgeInsets.all(16),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                FittedBox(
                  fit: BoxFit.contain,
                  child: Container(
                    padding: EdgeInsets.only(
                      top: 16,
                    ),
                    child: Text(
                      "Breath With The Shape",
                      style: TextStyle(
                        fontWeight: FontWeight.w100,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(),
                ),
                FittedBox(
                  fit: BoxFit.contain,
                  child: Hero(
                    tag: 'breath',
                    child: new Image(
                      image: new AssetImage("assets/gifs/breathMod.gif"),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}