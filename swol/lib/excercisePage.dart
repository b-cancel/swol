import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:swol/excerciseNotes.dart';
import 'package:swol/utils/data.dart';

//plugins mod
import 'package:swol/pluginMod/verticalTabs.dart';

class ExcercisePage extends StatelessWidget {
  ExcercisePage({
    @required this.excerciseID,
  });

  final int excerciseID;

  toNotes(BuildContext context){
    Navigator.push(
      context, 
      PageTransition(
        type: PageTransitionType.rightToLeft, 
        child: ExcerciseNotes(
          excerciseID: excerciseID,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Expanded(
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: (){
                    toNotes(context);
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      getExcercises().value[excerciseID].name,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: OutlineButton.icon(
              highlightedBorderColor: Theme.of(context).accentColor,
              onPressed: (){
                toNotes(context);
              },
              icon: Icon(Icons.edit),
              label: Text("Notes"),
            ),
          ),
        ],
      ),
      body: VerticalTabs(
        excerciseID: excerciseID,
      ),
    );
  }
}