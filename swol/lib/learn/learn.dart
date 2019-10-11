//flutter
import 'package:flutter/material.dart';

//plugin
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:swol/learn/body.dart';
import 'package:swol/learn/expandableTile.dart';

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
controller.createScrollPosition(physics, context, oldPosition) AND attach

print("positions: " + controller.positions.toString());

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
  GlobalKey listKey = new GlobalKey();
  AutoScrollController autoScrollController = new AutoScrollController();

  //is opens
  List<ValueNotifier<bool>> allIsOpens = new List<ValueNotifier<bool>>();

  ValueNotifier<bool> introductionIsOpen = new ValueNotifier(true);
  ValueNotifier<bool> definitionIsOpen = new ValueNotifier(false);
  ValueNotifier<bool> trainingIsOpen = new ValueNotifier(false);
  ValueNotifier<bool> precautionIsOpen = new ValueNotifier(false);
  ValueNotifier<bool> oneRepMaxIsOpen = new ValueNotifier(false);
  ValueNotifier<bool> experimentIsOpen = new ValueNotifier(false);
  ValueNotifier<bool> researchIsOpen = new ValueNotifier(false);

  maybeCloseOthers(ValueNotifier<bool> notifier){
    if(notifier.value){
      //close others
      closeOthers(notifier);

      //scroll to other
      //autoScrollController.
      Future.delayed(
        Duration(
          //300 to wait for the other sections to close
          //100 as a buffere since processing this takes a tad longer
          milliseconds: 300 + 100,
        ), 
        (){
          RenderBox renderBoxRed = listKey.currentContext.findRenderObject();
          double theHeight  = renderBoxRed.size.height;
          print("size" + theHeight.toString());
          //size721.7142857142857
          
          //scroll to index
          autoScrollController.scrollToIndex(
            allIsOpens.indexOf(notifier), 
            preferPosition: AutoScrollPosition.begin,
          );
        }
      );
    }
  }

  closeOthers(ValueNotifier<bool> passedNotifier){
    for(int i = 0; i < allIsOpens.length; i++){
      ValueNotifier<bool> thisNotifier = allIsOpens[i];
      if(thisNotifier != passedNotifier){
        if(thisNotifier.value){
          thisNotifier.value = false;
        }
      }
    }
  }

  @override
  void initState() {
    //super init
    super.initState();

    //make controller list
    allIsOpens = new List<ValueNotifier<bool>>();
    allIsOpens.addAll([
      introductionIsOpen,
      definitionIsOpen,
      trainingIsOpen,
      precautionIsOpen,
      oneRepMaxIsOpen,
      experimentIsOpen,
      researchIsOpen,
    ]);

    //make listeners
    introductionIsOpen.addListener(() => maybeCloseOthers(introductionIsOpen));
    definitionIsOpen.addListener(() => maybeCloseOthers(definitionIsOpen));
    trainingIsOpen.addListener(() => maybeCloseOthers(trainingIsOpen));
    precautionIsOpen.addListener(() => maybeCloseOthers(precautionIsOpen));
    oneRepMaxIsOpen.addListener(() => maybeCloseOthers(oneRepMaxIsOpen));
    experimentIsOpen.addListener(() => maybeCloseOthers(experimentIsOpen));
    researchIsOpen.addListener(() => maybeCloseOthers(researchIsOpen));
  }

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
            ),
          ], 
        ),
        body: new CustomScrollView(
          key: listKey,
          controller: autoScrollController,
          slivers: [
            new ExpandableTile(
              autoScrollController: autoScrollController,
              index: 0,
              isOpen: introductionIsOpen,
              headerIcon: FontAwesomeIcons.solidLightbulb, 
              headerText: "Introduction", 
              thisExpanded: IntroductionBody(),
            ),
            new ExpandableTile(
              autoScrollController: autoScrollController,
              index: 1,
              isOpen: definitionIsOpen,
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
              autoScrollController: autoScrollController,
              index: 2,
              isOpen: trainingIsOpen,
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
              autoScrollController: autoScrollController,
              index: 3,
              isOpen: precautionIsOpen,
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
              autoScrollController: autoScrollController,
              index: 4,
              isOpen: oneRepMaxIsOpen,
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
              autoScrollController: autoScrollController,
              index: 5,
              isOpen: experimentIsOpen,
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
              autoScrollController: autoScrollController,
              index: 6,
              isOpen: researchIsOpen,
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
