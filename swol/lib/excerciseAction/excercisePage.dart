import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:swol/excercise/excerciseData.dart';
import 'package:swol/excerciseAction/excerciseNotes.dart';
import 'package:swol/excerciseAction/tabs/verticalTabs.dart';

class ExcercisePage extends StatefulWidget {
  ExcercisePage({
    @required this.excerciseID,
    @required this.navSpread,
  });

  final int excerciseID;
  final ValueNotifier<bool> navSpread;

  @override
  _ExcercisePageState createState() => _ExcercisePageState();
}

class _ExcercisePageState extends State<ExcercisePage> {
  toNotes(BuildContext context){
    Navigator.push(
      context, 
      PageTransition(
        type: PageTransitionType.rightToLeft, 
        child: ExcerciseNotes(
          excerciseID: widget.excerciseID,
          navSpread: widget.navSpread,
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
    String name = ExcerciseData.getExcercises().value[widget.excerciseID].name;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const BackButtonIcon(),
          color: Theme.of(context).iconTheme.color,
          tooltip: MaterialLocalizations.of(context).backButtonTooltip,
          onPressed: () {
            widget.navSpread.value = false;
            Navigator.of(context).pop();
          },
        ),
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
                      name,
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
        excerciseID: widget.excerciseID,
      ),
    );
  }
}