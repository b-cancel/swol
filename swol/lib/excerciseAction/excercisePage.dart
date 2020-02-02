//flutter
import 'package:flutter/material.dart';

//plugin
import 'package:page_transition/page_transition.dart';

//internal: excercise
import 'package:swol/shared/widgets/simple/heros/title.dart';
import 'package:swol/shared/widgets/simple/backButton.dart';
import 'package:swol/shared/structs/anExcercise.dart';

//internal
import 'package:swol/excerciseAction/tabs/verticalTabs.dart';
import 'package:swol/pages/notes/excerciseNotes.dart';
import 'package:swol/main.dart';

//widgets
class ExcercisePage extends StatefulWidget {
  ExcercisePage({
    @required this.excercise,
  });

  final AnExcercise excercise;

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
        duration: Duration(milliseconds: 300),
        child: ExcerciseNotes(
          excercise: widget.excercise,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async{
        //may have to unfocus
        FocusScope.of(context).unfocus();
        //animate the header
        App.navSpread.value = false;
        //can still pop
        return true; 
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).primaryColorDark,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight),
          child: Container(
            width: MediaQuery.of(context).size.width,
            color: Colors.transparent,
            child: SafeArea(
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Expanded(
                    child: Stack(
                      alignment: Alignment.center,
                      children: <Widget>[
                        Positioned(
                          left: 0,
                          bottom: 0,
                          top: 0,
                          right: 0,
                          child: ExcerciseTitleHero(
                            inAppBar: true,
                            excercise: widget.excercise,
                            onTap: () => toNotes(context),
                          ),
                        ),
                        Positioned(
                          left: 0,
                          top: 0,
                          bottom: 0,
                          child: BackFromExcercise(
                            excercise: widget.excercise,
                          ),
                        ),
                        Positioned(
                          right: 0,
                          top: 0,
                          bottom: 0,
                          child: Padding(
                            padding: EdgeInsets.all(8),
                            child: OutlineButton.icon(
                              highlightedBorderColor: Theme.of(context).accentColor,
                              onPressed: (){
                                toNotes(context);
                              },
                              icon: Icon(Icons.edit),
                              label: Text("Notes"),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        body: VerticalTabs(
          excercise: widget.excercise,
          maxHeight: MediaQuery.of(context).size.height,
          statusBarHeight: MediaQuery.of(context).padding.top,
        ),
      ),
    );
  }
}