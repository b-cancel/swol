//flutter
import 'package:flutter/material.dart';

//plugin
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

//internal
import 'package:swol/learn/body.dart';
import 'package:swol/learn/cardTable.dart';
import 'package:swol/learn/expandableTile.dart';
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
              thisExpanded: OneRepMaxBody(),
            ),
            new ExpandableTile(
              autoScrollController: autoScrollController,
              index: 5,
              isOpen: experimentIsOpen,
              headerIcon: FontAwesomeIcons.flask, 
              headerText: "Experiment",
              thisExpanded: new ExperimentBody(),
            ),
            new ExpandableTile(
              autoScrollController: autoScrollController,
              index: 6,
              isOpen: researchIsOpen,
              headerIcon: FontAwesomeIcons.book, 
              headerText: "Research",
              thisExpanded: new ResearchBody(),
            ),
          ],
        ),
      ),
    );
  }
}

class ResearchBody extends StatelessWidget {
  const ResearchBody({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SectionDescription(
          child: Text(
            "Here are some topics that you can look into, to help you get even more out of your workouts",
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16.0,
          ),
          child: Column(
            children: <Widget>[
              ResearchCard(
                title: "How do you focus at each stage of movement to get the most out of each exercise?", 
                items: [
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "Concentric Stage (positive reps): ",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text: "where your muscle contracts and shortens",
                        ),
                      ]
                    ),
                  ),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "Isometric Stage (holds): ",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text: " where your muscle contracts, and neither shortens or lengthens",
                        ),
                      ]
                    ),
                  ),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "Eccentric Stage (negative reps): ",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text: "where your muscle contracts and lengthens",
                        ),
                      ]
                    ),
                  ),
                ],
              ),
              ResearchCard(
                title: "How does each energy system work and how can use your knowledge of each to your advantage?", 
                items: [
                  Text("Anaerobic System"),
                  Text("Glycolytic System"),
                  Text("Aerobic System"),
                ],
              ),
            ],
          ),
        )
      ],
    );
  }
}

class ResearchCard extends StatelessWidget {
  const ResearchCard({
    Key key,
    @required this.title,
    @required this.items,
  }) : super(key: key);

  final String title;
  final List<Widget> items;

  @override
  Widget build(BuildContext context) {
    List<Widget> listItems = new List<Widget>();
    for(int i = 0; i < items.length; i++){
      listItems.add(
        ListItem(
          circleColor: Theme.of(context).accentColor,
          circleText: (i + 1).toString(),
          circleTextSize: 18,
          content: items[i],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(
        bottom: 16.0,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(25),
        child: Container(
          child: Container(
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: <Widget>[
                Container(
                  color: Theme.of(context).accentColor,
                  padding: EdgeInsets.all(16),
                  child: Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
                Container(
                  color: Theme.of(context).cardColor,
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.symmetric(
                    horizontal: 16,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(
                      top: 16.0,
                    ),
                    child: Column(
                      children: listItems,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}