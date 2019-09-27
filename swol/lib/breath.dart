import 'package:flutter/material.dart';

class Breath extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    print("c: "  + Theme.of(context).scaffoldBackgroundColor.toString());

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