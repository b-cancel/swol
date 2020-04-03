//dart
import 'dart:ui';

//flutter
import 'package:flutter/material.dart';

//plugin
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:swol/action/page.dart';

//internal: learn
import 'package:swol/pages/learn/expandableTile/expandableTile.dart';
import 'package:swol/pages/learn/sections/definitions/body.dart';
import 'package:swol/pages/learn/sections/experiment.dart';
import 'package:swol/pages/learn/sections/introduction.dart';
import 'package:swol/pages/learn/sections/oneRepMax.dart';
import 'package:swol/pages/learn/sections/precautions.dart';
import 'package:swol/pages/learn/sections/research.dart';
import 'package:swol/pages/learn/sections/training.dart';
import 'package:swol/main.dart';

//internal: other
import 'package:swol/shared/methods/extensions/sharedPreferences.dart';

//https://pub.dev/packages/expandable
//https://stackoverflow.com/questions/54986328/how-to-make-expandable-card

//NOTE: it seems like it might work to use a solid height
//and simply scroll to top while the widget is opening
//but it doesn't work
//1. jumpTo is jerky, doesnt land in the right spot and we don't know how long its going to take
//2. animateTo doesn't even work at all
//3. scrollToIndex doesnt work with solid heights

//build
class LearnExercise extends StatefulWidget {
  @override
  _LearnExerciseState createState() => _LearnExerciseState();
}

class _LearnExerciseState extends State<LearnExercise> {
  final AutoScrollController autoScrollController = new AutoScrollController();

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
    SharedPrefsExt.setIntroductionShown(true);

    //a section is being opened
    if(isOpen.value){
      //close others
      closeOthers(isOpen);

      //scroll to other
      Future.delayed(
        //TODO: ideally a more fool proof solution (1.5 duration may not cover un-planned delay)
        //we currently just set the variables in "allIsOpens" to false
        //but the animation kind of happens on its own
        //requires seperate set of variables that confirm if it finished its animation
        //add if necessary
        ExercisePage.transitionDuration * 1.5, 
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

  introductionUpdate() => maybeCloseOthers(introductionIsOpen);
  definitionUpdate() => maybeCloseOthers(definitionIsOpen);
  trainingUpdate() => maybeCloseOthers(trainingIsOpen);
  precautionUpdate() => maybeCloseOthers(precautionIsOpen);
  oneRepMaxUpdate() => maybeCloseOthers(oneRepMaxIsOpen);
  experimentUpdate() => maybeCloseOthers(experimentIsOpen);
  researchUpdate() => maybeCloseOthers(researchIsOpen);

  @override
  void initState() {
    //super init
    super.initState();

    introductionIsOpen = new ValueNotifier(
      SharedPrefsExt.getIntroductionShown().value == false,
    );

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
    introductionIsOpen.addListener(introductionUpdate);
    definitionIsOpen.addListener(definitionUpdate);
    trainingIsOpen.addListener(trainingUpdate);
    precautionIsOpen.addListener(precautionUpdate);
    oneRepMaxIsOpen.addListener(oneRepMaxUpdate);
    experimentIsOpen.addListener(experimentUpdate);
    researchIsOpen.addListener(researchUpdate);
  }

  @override
  void dispose() { 
    //remove listeners
    introductionIsOpen.removeListener(introductionUpdate);
    definitionIsOpen.removeListener(definitionUpdate);
    trainingIsOpen.removeListener(trainingUpdate);
    precautionIsOpen.removeListener(precautionUpdate);
    oneRepMaxIsOpen.removeListener(oneRepMaxUpdate);
    experimentIsOpen.removeListener(experimentUpdate);
    researchIsOpen.removeListener(researchUpdate);
    
    //super dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Color theSemiWhite = Colors.white.withOpacity(0.5);

    return WillPopScope(
      onWillPop: ()async{
        App.navSpread.value = false;
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
                App.navSpread.value = false;
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
                headerText: "One Rep Max", 
                expandedChild: OneRepMaxBody(),
              ),
              ExpandableTile(
                autoScrollController: autoScrollController,
                index: 5,
                isOpen: experimentIsOpen,
                headerIcon: FontAwesomeIcons.calculator, 
                headerText: "The SWOL Calculator",
                expandedChild: ExperimentBody(),
              ),
              ExpandableTile(
                autoScrollController: autoScrollController,
                index: 6,
                isOpen: researchIsOpen,
                headerIcon: FontAwesomeIcons.book, 
                headerText: "Further Research",
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