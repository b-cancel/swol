//flutter
import 'package:flutter/material.dart';

//plugin
import 'package:page_transition/page_transition.dart';

//internal: excercise
import 'package:swol/excercise/excerciseStructure.dart';
import 'package:swol/excercise/excerciseData.dart';

//internal
import 'package:swol/excerciseAction/tabs/verticalTabs.dart';
import 'package:swol/basicFields/excerciseEdit.dart';
import 'package:swol/notes/excerciseNotes.dart';
import 'package:swol/main.dart';

//widgets
class ExcercisePage extends StatefulWidget {
  ExcercisePage({
    @required this.excerciseID,
    @required this.transitionDuration,
  });

  final int excerciseID;
  final Duration transitionDuration;

  @override
  _ExcercisePageState createState() => _ExcercisePageState();
}

class _ExcercisePageState extends State<ExcercisePage> {
  toNotes(BuildContext context){
    //close keyboard if perhaps typing next set
    FocusScope.of(context).unfocus();

    //go to notes
    Navigator.push(
      context, 
      PageTransition(
        type: PageTransitionType.rightToLeft, 
        child: ExcerciseNotes(
          excerciseID: widget.excerciseID,
        ),
      ),
    );
  }

  @override
  void initState() { 
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String name = "";
    Map<int, AnExcercise> indexToExcercises = ExcerciseData.getExcercises().value;
    if(indexToExcercises.containsKey(widget.excerciseID)){
      name = indexToExcercises[widget.excerciseID].name;
    }

    double statusBarHeight = MediaQuery.of(context).padding.top;

    //build
    return WillPopScope(
      onWillPop: ()async{
        //may have to unfocus
        FocusScope.of(context).unfocus();
        //animate the header
        App.navSpread.value = false;
        //can still pop
        return true; 
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).primaryColorDark,
        appBar: AppBar(
          leading: BackFromExcercise(),
          title: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: (){
                //NOTE: taping the name also goes to notes
                //BECAUSE the assumed action the user wants to take 
                //is to change the name
                //and from notes you can change the name
                toNotes(context);
              },
              child: Container(
                width: MediaQuery.of(context).size.width,
                alignment: Alignment.centerLeft,
                child: Text(
                  name,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
            ),
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
          excerciseID: widget.excerciseID,
          maxHeight: MediaQuery.of(context).size.height,
          transitionDuration: widget.transitionDuration,
          statusBarHeight: statusBarHeight,
        ),
      ),
    );
  }
}