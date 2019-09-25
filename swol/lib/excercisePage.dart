import 'package:flutter/material.dart';
import 'package:swol/utils/data.dart';

//plugins mod
import 'package:swol/pluginMod/verticalTabs.dart';

class ExcercisePage extends StatelessWidget {
  ExcercisePage({
    @required this.excerciseID,
  });

  final int excerciseID;

  areyouSurePopUp(BuildContext context){
    showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Theme(
          data: ThemeData.light(),
          child: AlertDialog(
            title: Text("Delete Excercise?"),
            contentPadding: EdgeInsets.all(0),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Text(
                    "Deleting is unreversible but\n\n"
                    + "If you want to get it out of the way"
                    + " without losing your data you can \"Archive\" it below.",
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    bottom: 8,
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 8,
                    ),
                    child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      FlatButton(
                        onPressed: (){
                          //archive it or get it out of the way
                          //but placing it 200 years in the future
                          //NO LESS
                          //because we want to make sure for duration of life
                          //that is archived and life is at most 100 years
                          updateExcercise(
                            excerciseID, 
                            lastTimeStamp: DateTime.now().add(Duration(days: 365 * 2)),
                          );

                          //get rid of this pop up
                          Navigator.of(context).pop();

                          //go back to our list
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          "Archive",
                          style: TextStyle(
                            color: Colors.blue,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(),
                      ),
                      FlatButton(
                        onPressed: (){
                          //get rid of this pop up
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          "Cancel",
                          style: TextStyle(
                            color: Theme.of(context).primaryColorDark,
                          ),
                        ),
                      ),
                      RaisedButton(
                        color: Colors.red,
                        onPressed: (){
                          //get rid of the item
                          deleteExcercise(excerciseID);

                          //get rid of this pop up
                          Navigator.of(context).pop();

                          //go back to our list
                          Navigator.pop(context);
                        },
                        child: Text(
                          "Delete",
                          style: TextStyle(
                            color: Theme.of(context).primaryColorDark,
                          ),
                        ),
                      ),
                    ],
              ),
                  ),
                ),
              ],
            ),
          ),
        ); 
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(getExcercises().value[excerciseID].name),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: RaisedButton(
              color: Colors.red,
              onPressed: (){
                areyouSurePopUp(context);
              },
              child: Row(
                children: <Widget>[
                  Icon(
                    Icons.delete,
                    color: Theme.of(context).primaryColorDark,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 8.0,
                    ),
                    child: Text(
                      "Delete",
                      style: TextStyle(
                        color: Theme.of(context).primaryColorDark,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      body: VerticalTabs(
        excerciseID: excerciseID,
      ),
    );
  }

  Tab emptyTab() => Tab(child: Text(''));
}