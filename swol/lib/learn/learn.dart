//flutter
import 'package:flutter/material.dart';

//plugin

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:swol/learn/body.dart';
import 'package:swol/learn/cardTable.dart';
import 'package:swol/learn/expandableTile.dart';

import 'package:flutter_banner_swiper/flutter_banner_swiper.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:simple_coverflow/simple_coverflow.dart';
import 'package:swipe_stack/swipe_stack.dart';
import 'package:swol/learn/reusableWidgets.dart';

//build
class LearnExcercise extends StatefulWidget {
  LearnExcercise({
    @required this.navSpread,
  });

  final ValueNotifier navSpread;

  @override
  _LearnExcerciseState createState() => _LearnExcerciseState();
}

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
              thisExpanded: DefinitionBody(),
            ),
            new ExpandableTile(
              autoScrollController: autoScrollController,
              index: 2,
              isOpen: trainingIsOpen,
              headerIcon: FontAwesomeIcons.dumbbell, 
              size: 18,
              headerText: "Training", 
              thisExpanded: new TrainingBody(),
            ),
            new ExpandableTile(
              autoScrollController: autoScrollController,
              index: 3,
              isOpen: precautionIsOpen,
              headerIcon: Icons.warning, 
              headerText: "Precautions", 
              thisExpanded: new PrecautionsBody(),
            ),
            new ExpandableTile(
              autoScrollController: autoScrollController,
              index: 4,
              isOpen: oneRepMaxIsOpen,
              headerIcon: FontAwesomeIcons.trophy, 
              size: 20,
              headerText: "1 Rep Max", 
              /*
              Hitting a new personal record is a rush and a good way to track your progress. 
              But doing a one rep max (1RM) puts you at a high risk for injury.

              So 1RM formulas were created to help you get a rough idea of what your 1RM should be, 
              based on any other set, without putting you at a high risk for injury.
              
              However, there are some downsides

              - Your estimated 1RM gets less precise as you increase reps and/or the weight you are lifting
              - The formulas can only give you an estimated 1RM if you plug in a set with less than 35 reps
              - There are multiple 1RM formulas that give slightly different results, but no clear indicator of when to use which
	
	            We tried to fix all of this in "The Experiment"
              */
              thisExpanded: OneRepMaxBody(),
            ),
            new ExpandableTile(
              autoScrollController: autoScrollController,
              index: 5,
              isOpen: experimentIsOpen,
              headerIcon: FontAwesomeIcons.flask, 
              headerText: "Experiment", 
              /*
              We suspect that one rep max formulas can be helpful for more than just tracking your progress. 
              Based on our limited experience and experimentation we believe

              1. The ABILITY of a set of muscles is the maximum amount of weight they can lift at all rep range targets (below 35)
              2. The ABILITY of a set of muscles can therefore be represented by a formula (one of the one rep max formulas)
              3. Additionally, the ABILITY of a set of muscles does not just depend on how strong those muscles are, but also on how much of them you can voluntarily activate
              4. Furthermore, because you need different amounts of control over your entire nervous system for different exercises, different ABILITY formulas will be used for different exercises
              5. We believe that what ABILITY formula each exercise uses, indicates to what extent you can voluntarily activate your muscles due to your overall level of nervous system control
              6. So as you continue to train, the ABILITY formulas that each exercise uses should change to reflect an overall increase in the control you have over your entire nervous system

              If we make these assumptions, for each exercise, 
              we can use the 1RM formulas to give you a goal to work towards for your next set by using 
              [1] your previous set 
              [2] your desired exertion level 
              [3] your prefered or suggested ability formula 
              [4] and your rep target. 
              As new sets are recorded we can also switch to a formula 
              that more accurately reflects the results of your last recorded set. 
              
              We believe this will help you improve as fast as possible, 
              regardless of what type of training you are using, 
              without getting injured. 

              Below is a chart of all the Ability Formulas 
              (previously known as 1 rep max formulas) 
              and what level of limitation they imply. 
              */
              thisExpanded: Column(
                children: <Widget>[
                  IntroductionBody(),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                    child: FunctionCardTable(
                      context: context,
                    ),
                  ),
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
              /*
              Here are some topics that you can look into, to help you get even more out of your workouts

              - How do you focus at each stage of movement to get the most out of each exercise?
                  1. Concentric Stage (positive reps): where your muscle contracts and shortens
                  2. Isometric Stage (holds): where your muscle contracts, and neither shortens or lengthens
                  3. Eccentric Stage (negative reps): where your muscle contracts and lengthens

              - How does each energy system work and how can use your knowledge of each to your advantage?
                  1. Anaerobic System
                  2. Glycolytic System
                  3. Aerobic System
              */
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