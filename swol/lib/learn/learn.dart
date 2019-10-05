//flutter
import 'package:flutter/material.dart';

//plugin
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

//build
class LearnExcercise extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        automaticallyImplyLeading: false,
        primary: true,
        title: Row(
          children: <Widget>[
            Icon(FontAwesomeIcons.bookOpen),
            Padding(
              padding: const EdgeInsets.only(
                left: 16.0,
              ),
              child: Text("Learn"),
            ),
          ],
        ), 
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.close),
            onPressed: (){
              Navigator.of(context).pop();
            },
          )
        ], 
      ),
      body: new ListView(
        children: [

        ],
      ),
    );
  }
}