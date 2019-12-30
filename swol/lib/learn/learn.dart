//flutter
import 'dart:ui';

import 'package:flutter/material.dart';

//plugin
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

//internal
import 'package:swol/learn/expandableTile.dart';
import 'package:swol/learn/sections/definitions.dart';
import 'package:swol/learn/sections/experiment.dart';
import 'package:swol/learn/sections/introduction.dart';
import 'package:swol/learn/sections/oneRepMax.dart';
import 'package:swol/learn/sections/precautions.dart';
import 'package:swol/learn/sections/research.dart';
import 'package:swol/learn/sections/training.dart';
import 'package:swol/utils/onboarding.dart';

//https://pub.dev/packages/expandable
//https://stackoverflow.com/questions/54986328/how-to-make-expandable-card


//build
class LearnExcercise extends StatefulWidget {
  LearnExcercise({
    @required this.navSpread,
    @required this.shownIntroductionVN,
  });

  final ValueNotifier navSpread;
  final ValueNotifier<bool> shownIntroductionVN;

  @override
  _LearnExcerciseState createState() => _LearnExcerciseState();
}

class _LearnExcerciseState extends State<LearnExcercise> {
  GlobalKey listKey = new GlobalKey();
  AutoScrollController autoScrollController = new AutoScrollController();

  //is opens
  List<ValueNotifier<bool>> allIsOpens = new List<ValueNotifier<bool>>();

  //my be automatically open to show the user what this section of the app is about
  ValueNotifier<bool> introductionIsOpen;

  //automatically closed
  ValueNotifier<bool> definitionIsOpen = new ValueNotifier(false);
  ValueNotifier<bool> trainingIsOpen = new ValueNotifier(false);
  ValueNotifier<bool> precautionIsOpen = new ValueNotifier(false);
  ValueNotifier<bool> oneRepMaxIsOpen = new ValueNotifier(false);
  ValueNotifier<bool> experimentIsOpen = new ValueNotifier(false);
  ValueNotifier<bool> researchIsOpen = new ValueNotifier(false);

  maybeCloseOthers(ValueNotifier<bool> isOpen){
    //the user has tapped something
    //so they will have seen how the drop down works

    //update locally
    widget.shownIntroductionVN.value = true;
    //update globally
    OnBoarding.boolSet(StoredBools.IntroductionShown);

    //a section is being opened
    if(isOpen.value){
      //close others
      closeOthers(isOpen);

      //scroll to other
      //autoScrollController.
      Future.delayed(
        Duration(
          //300 to wait for the other sections to close
          //100 as a buffere since processing this takes a tad longer
          milliseconds: 300 + 100,
        ), 
        (){
          //scroll to index
          autoScrollController.scrollToIndex(
            allIsOpens.indexOf(isOpen), 
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

    introductionIsOpen = new ValueNotifier(widget.shownIntroductionVN.value == false);

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
    Color theSemiWhite = Colors.white.withOpacity(0.5);

    return WillPopScope(
      onWillPop: ()async{
        widget.navSpread.value = false;
        return true; //can still pop
      },
      child: new Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
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
        body: DefaultTextStyle(
          style: TextStyle(
            fontSize: 16,
          ),
          child: CustomScrollView(
            key: listKey,
            controller: autoScrollController,
            slivers: [
              ExpandableTile(
                autoScrollController: autoScrollController,
                index: 0,
                isOpen: introductionIsOpen,
                headerIcon: FontAwesomeIcons.solidLightbulb, 
                headerText: "Introduction", 
                expandedChild: IntroductionBody(),
              ),
              ExpandableTile(
                autoScrollController: autoScrollController,
                index: 1,
                isOpen: definitionIsOpen,
                headerIcon: Icons.chrome_reader_mode, 
                headerText: "Definitions", 
                expandedChild: DefinitionBody(),
              ),
              ExpandableTile(
                autoScrollController: autoScrollController,
                index: 2,
                isOpen: trainingIsOpen,
                headerIcon: FontAwesomeIcons.dumbbell, 
                size: 18,
                headerText: "Training", 
                //TODO: fix weird spacing below table... problem may lie in "trainingTypes.dart"
                expandedChild: TrainingBody(),
              ),
              ExpandableTile(
                autoScrollController: autoScrollController,
                index: 3,
                isOpen: precautionIsOpen,
                headerIcon: Icons.warning, 
                headerText: "Precautions",
                expandedChild: PrecautionsBody(),
              ),
              ExpandableTile(
                autoScrollController: autoScrollController,
                index: 4,
                isOpen: oneRepMaxIsOpen,
                headerIcon: FontAwesomeIcons.trophy, 
                size: 20,
                headerText: "1 Rep Max", 
                expandedChild: OneRepMaxBody(),
              ),
              ExpandableTile(
                autoScrollController: autoScrollController,
                index: 5,
                isOpen: experimentIsOpen,
                headerIcon: FontAwesomeIcons.flask, 
                headerText: "Experiment",
                expandedChild: ExperimentBody(),
              ),
              ExpandableTile(
                autoScrollController: autoScrollController,
                index: 6,
                isOpen: researchIsOpen,
                headerIcon: FontAwesomeIcons.book, 
                headerText: "Research",
                expandedChild: ResearchBody(),
                theOnlyException: true,
              ),
              SliverFillRemaining(
                hasScrollBody: false,
                fillOverscroll: false,
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Container(
                      height: 56,
                      //basically fit height
                      width: 406 / (250/56),
                      child: Image(
                        //image dimesions: 250 x 406
                        image: new AssetImage("assets/littleBrain.png"),
                        color: theSemiWhite,
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}