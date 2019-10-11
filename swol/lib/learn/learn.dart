//flutter
import 'package:flutter/material.dart';

//plugin
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:expandable/expandable.dart';
import 'package:swol/learn/body.dart';
import 'package:swol/learn/expandableTile.dart';
import 'package:swol/learn/section.dart';

//build
class LearnExcercise extends StatefulWidget {
  LearnExcercise({
    @required this.navSpread,
  });

  final ValueNotifier navSpread;

  @override
  _LearnExcerciseState createState() => _LearnExcerciseState();
}

/*
//Scrollable.ensureVisible(dataKey.currentContext),






final scrollController = ScrollController();

// ...
ListView(controller: scrollController // ...
);
// ...
scrollController.animateTo(height, duration: Duration(milliseconds: 678), 
  curve: Curves.ease);
*/

class _LearnExcerciseState extends State<LearnExcercise> {
  /*
  List<ExpandableController> allControllers;
  ExpandableController introductionCtrl = ExpandableController(
    initialExpanded: true, //NOTE: always starts open
  );
  ExpandableController definitionCtrl = ExpandableController(
    initialExpanded: false,
  );
  ExpandableController trainingCtrl = ExpandableController(
    initialExpanded: false,
  );
  ExpandableController precautionsCtrl = ExpandableController(
    initialExpanded: false,
  );
  ExpandableController oneRepMaxCtrl = ExpandableController(
    initialExpanded: false,
  );
  ExpandableController experimentCtrl = ExpandableController(
    initialExpanded: false,
  );
  ExpandableController researchCtrl = ExpandableController(
    initialExpanded: false,
  );
  */

/*
  closeOthers(ExpandableController ctrl){
    print("-------------------------");
    for(int i = 0; i < allControllers.length; i++){
      ExpandableController thisCtrl = allControllers[i];
      if(thisCtrl != ctrl){
        print(i.toString() + " -> 1");
        if(thisCtrl.expanded){
          print("closed");
          thisCtrl.expanded = false;
        }
      }
      else print(i.toString() + " -> 0");
    }
  }
  */

  @override
  void initState() {
    //super init
    super.initState();

    /*
    //make controller list
    allControllers = new List<ExpandableController>();
    allControllers.addAll([
      introductionCtrl,
      definitionCtrl,
      trainingCtrl,
      precautionsCtrl,
      oneRepMaxCtrl,
      experimentCtrl,
      researchCtrl,
    ]);
    */
  }

  ValueNotifier<bool> introductionIsOpen = new ValueNotifier(true);
  ValueNotifier<bool> definitionsAreOpen = new ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: ()async{
        widget.navSpread.value = false;
        return true; //can still pop
      },
      child: new Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          automaticallyImplyLeading: false,
          primary: true,
          title: Row(
            children: <Widget>[
              Icon(FontAwesomeIcons.leanpub),
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
                widget.navSpread.value = false;
                Navigator.of(context).pop();
              },
            )
          ], 
        ),
        body: new CustomScrollView(
          physics: ClampingScrollPhysics(),
          shrinkWrap: true,
          slivers: [
            new ExpandableTile(
              isOpen: introductionIsOpen,
              headerIcon: FontAwesomeIcons.solidLightbulb, 
              headerText: "Introduction", 
              thisExpanded: IntroductionBody(),
            ),
            new ExpandableTile(
              isOpen: definitionsAreOpen,
              headerIcon: Icons.chrome_reader_mode, 
              headerText: "Definitions", 
              thisExpanded: Column(
                children: <Widget>[
                  IntroductionBody(),
                  IntroductionBody(),
                  IntroductionBody(),
                  IntroductionBody(),
                  IntroductionBody(),
                  IntroductionBody(),
                  IntroductionBody(),
                ],
              ),
            ),
            new ExpandableTile(
              isOpen: new ValueNotifier(false),
              headerIcon: FontAwesomeIcons.dumbbell, 
              size: 18,
              headerText: "Training", 
              thisExpanded: Column(
                children: <Widget>[
                  IntroductionBody(),
                  IntroductionBody(),
                  IntroductionBody(),
                  IntroductionBody(),
                  IntroductionBody(),
                  IntroductionBody(),
                  IntroductionBody(),
                ],
              ),
            ),
            new ExpandableTile(
              isOpen: new ValueNotifier(false),
              headerIcon: Icons.warning, 
              headerText: "Precautions", 
              thisExpanded: Column(
                children: <Widget>[
                  IntroductionBody(),
                  IntroductionBody(),
                  IntroductionBody(),
                  IntroductionBody(),
                  IntroductionBody(),
                  IntroductionBody(),
                  IntroductionBody(),
                ],
              ),
            ),
            new ExpandableTile(
              isOpen: new ValueNotifier(false),
              headerIcon: FontAwesomeIcons.trophy, 
              size: 20,
              headerText: "1 Rep Max", 
              thisExpanded: Column(
                children: <Widget>[
                  IntroductionBody(),
                  IntroductionBody(),
                  IntroductionBody(),
                  IntroductionBody(),
                  IntroductionBody(),
                  IntroductionBody(),
                  IntroductionBody(),
                ],
              ),
            ),
            new ExpandableTile(
              isOpen: new ValueNotifier(false),
              headerIcon: FontAwesomeIcons.flask, 
              headerText: "Experiment", 
              thisExpanded: Column(
                children: <Widget>[
                  IntroductionBody(),
                  IntroductionBody(),
                  IntroductionBody(),
                  IntroductionBody(),
                  IntroductionBody(),
                  IntroductionBody(),
                  IntroductionBody(),
                ],
              ),
            ),
            new ExpandableTile(
              isOpen: new ValueNotifier(false),
              headerIcon: FontAwesomeIcons.book, 
              headerText: "Research", 
              thisExpanded: Column(
                children: <Widget>[
                  IntroductionBody(),
                  IntroductionBody(),
                  IntroductionBody(),
                  IntroductionBody(),
                  IntroductionBody(),
                  IntroductionBody(),
                  IntroductionBody(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
