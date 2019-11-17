//flutter
import 'package:flutter/material.dart';

//internal
import 'package:swol/sharedWidgets/trainingTypes/cardTable.dart';

//plugins
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:carousel_slider/carousel_slider.dart';

class ScrollTrainingTypes extends StatefulWidget {
  const ScrollTrainingTypes({
    Key key,
    this.lightMode: false,
    this.highlightField: -1,
    @required this.sections,
    @required this.sectionID,
  }) : super(key: key);

  final bool lightMode;
  final int highlightField;
  final List<List<int>> sections; 
  final ValueNotifier<int> sectionID;

  @override
  _ScrollTrainingTypesState createState() => _ScrollTrainingTypesState();
}

class _ScrollTrainingTypesState extends State<ScrollTrainingTypes> {
  Widget enduranceCard;
  Widget hypertrophyCard;
  Widget strengthCard;
  List<List<CardTable>> sectionsOfCards;
  List<Widget> carousels;
  var mainCarousel;

  sectionIDToCarouselAction(){
    WidgetsBinding.instance.addPostFrameCallback((_){
      print("in section: " + widget.sectionID.value.toString());
      mainCarousel.animateToPage(
        widget.sectionID.value,
        duration: Duration(milliseconds: 250), 
        curve: Curves.linear,
      );
    });
  }

  @override
  void initState() {
    //create all default card
    enduranceCard = CardTable(
      lightMode: widget.lightMode,
      items: [
        "Endurance ",
        "Light",
        "0:15 to 1:00",
        "13+",
        "2 to 4",
        "Metabolic Stress",
        "Endurance",
        "Connective Tissue",
      ],
      highlightField: widget.highlightField,
      icon: FontAwesomeIcons.weight,
    );

    hypertrophyCard = CardTable(
      lightMode: widget.lightMode,
      items: [
        "\tHypertrophy",//NOTE: extra space for dumbell
        "Heavy",
        "1:05 to 2:00",
        "7 to 12",
        "3 to 5",
        "Hypertrophy", 
        "Size",
        "Joints and Tissue",
      ],
      highlightField: widget.highlightField,
      icon: FontAwesomeIcons.dumbbell,
    );

    strengthCard = CardTable(
      lightMode: widget.lightMode,
      items: [
        "Strength ",
        "Very Heavy",
        "3:00 to 5:00",
        "1 to 6",
        "4 to 6",
        "Tension",
        "Strength",
        "Joints",
      ],
      highlightField: widget.highlightField,
      icon: FontAwesomeIcons.weightHanging,
    );

    //create section
    sectionsOfCards = new List<List<CardTable>>();
    for(int i = 0; i < widget.sections.length; i++){
      List<int> aSection = widget.sections[i];
      List<CardTable> aCardSection = new List<CardTable>();
      for(int s = 0; s < aSection.length; s++){
        int cardType = aSection[s];
        switch(cardType){ //0,1,2
          case 0: aCardSection.add(enduranceCard); break;
          case 1: aCardSection.add(hypertrophyCard); break;
          default: aCardSection.add(strengthCard); break;
        }
      }
      sectionsOfCards.add(aCardSection);
    }

    //create carosels based on that
    carousels = new List<Widget>();
    for(int i = 0; i < sectionsOfCards.length; i++){
      carousels.add(
        CarouselSlider(
          height: 256.0 + (3.0 * 8),
          //so they can compare both
          enableInfiniteScroll: (sectionsOfCards[i].length > 1),
          enlargeCenterPage: true,
          autoPlay: false,
          viewportFraction: .75,
          items: sectionsOfCards[i],
        ),
      );
    }

    //create main carousel
    mainCarousel = CarouselSlider(
      scrollPhysics: NeverScrollableScrollPhysics(),
      height: 256.0 + (3.0 * 8),
      //so they can compare both
      enableInfiniteScroll: (carousels.length > 1),
      enlargeCenterPage: true,
      autoPlay: false,
      viewportFraction: 1.0,
      items: carousels,
    );

    //init call for initial focus
    WidgetsBinding.instance.addPostFrameCallback((_){
      mainCarousel.jumpToPage(widget.sectionID.value);
    });

    //listener for further actions
    widget.sectionID.addListener(sectionIDToCarouselAction);

    //super init
    super.initState();
  }

  @override
  void dispose() {
    //remove listener
    widget.sectionID.removeListener(sectionIDToCarouselAction);

    //super dipose
    super.dispose();
  }

  //TODO: edit below or above ;)
  @override
  Widget build(BuildContext context) {
    List<Widget> types = new List<Widget>();
    return Container(
      color: (widget.lightMode) ? Colors.white : Theme.of(context).primaryColor,
      child: IntrinsicHeight(
        child: Row(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(
                vertical: 0,
              ),
              child: Container(
                height: 256 + (3.0 * 8),
                child: PersistentCardTable(
                  lightMode: widget.lightMode,
                  items: [
                    "Training Type",
                    "Weight Heaviness",
                    "Recovery Time",
                    "Rep Targets",
                    "Set Targets",
                    "Primary Goal",
                    "Increase Muscle",
                    "Risk To",
                  ],
                  highlightField: widget.highlightField,
                ),
              ),
            ),
            Expanded(
              child: Container(
                color: (widget.lightMode) ? Colors.white: Theme.of(context).primaryColor,
                child: Stack(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 16,
                      ),
                      child: mainCarousel,
                    ),
                    Positioned(
                      top: 0,
                      bottom: 0,
                      child: Container(
                        width: 32,
                        decoration: BoxDecoration(
                          // Box decoration takes a gradient
                          gradient: LinearGradient(
                            tileMode: TileMode.clamp,
                            // Where the linear gradient begins and ends
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            // Add one stop for each color. Stops should increase from 0 to 1
                            stops: [0.1,1.0],
                            colors: [
                              (widget.lightMode) ? Colors.white : Theme.of(context).primaryColor,
                              (widget.lightMode) ? Colors.white.withOpacity(0) : Colors.transparent,
                            ],
                          ),
                        ),
                        child: Container(),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//TODO: replace this for the more OP version
//TODO: check why the more OP version needs more space in some circumstances
class ScrollableTrainingTypes extends StatelessWidget {
  const ScrollableTrainingTypes({
    Key key,
    this.lightMode: false,
    this.showStrength: true,
    this.showHypertrophy: true,
    this.showEndurance: true,
    this.highlightField: -1,
    this.sectionWithInitialFocus: 0,
  }) : super(key: key);

  final bool lightMode;
  final bool showStrength;
  final bool showHypertrophy;
  final bool showEndurance;
  final int highlightField;
  final int sectionWithInitialFocus;

  @override
  Widget build(BuildContext context) {
    List<Widget> types = new List<Widget>();

    int activeCount = 0;

    if(showEndurance){
      activeCount++;
      types.add(
        CardTable(
          lightMode: lightMode,
          items: [
            "Endurance ",
            "Light",
            "0:15 to 1:00",
            "13+",
            "2 to 4",
            "Metabolic Stress",
            "Endurance",
            "Connective Tissue",
          ],
          highlightField: highlightField,
          icon: FontAwesomeIcons.weight,
        ),
      );
    }

    if(showHypertrophy){
      activeCount++;
      types.add(
        CardTable(
          lightMode: lightMode,
          items: [
            "\tHypertrophy",//NOTE: extra space for dumbell
            "Heavy",
            "1:05 to 2:00",
            "7 to 12",
            "3 to 5",
            "Hypertrophy", 
            "Size",
            "Joints and Tissue",
          ],
          highlightField: highlightField,
          icon: FontAwesomeIcons.dumbbell,
        ),
      );
    }

    if(showStrength){
      activeCount++;
      types.add(
        CardTable(
          lightMode: lightMode,
          items: [
            "Strength ",
            "Very Heavy",
            "3:00 to 5:00",
            "1 to 6",
            "4 to 6",
            "Tension",
            "Strength",
            "Joints",
          ],
          highlightField: highlightField,
          icon: FontAwesomeIcons.weightHanging,
        ),
      );
    }

    int adjustedStartTraining = sectionWithInitialFocus.clamp(0, types.length - 1);
    if(sectionWithInitialFocus != 0){
      //if length is one it wouldn't have come here
      if(types.length == 2){
        //input 0,1
        //output 1,0

        //switch the two values
        CardTable ct = types.removeAt(0);
        types.add(ct);
      }
      else{ //length is 3
        if(adjustedStartTraining == 2){
          //input 0,1,2
          //output 2,0,1

          //grab values
          CardTable one = types.removeAt(1);
          CardTable zero = types.removeAt(0);

          //add values back
          types.add(zero);
          types.add(one);
        }
        else{
          //input 0,1,2
          //output 1,2,0

          //switch the two values
          CardTable ct = types.removeAt(0);
          types.add(ct);
        }
      }
    }

    return Container(
      color: (lightMode) ? Colors.white : Theme.of(context).primaryColor,
      child: IntrinsicHeight(
        child: Row(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(
                vertical: 16,
              ),
              child: PersistentCardTable(
                lightMode: lightMode,
                items: [
                  "Training Type",
                  "Weight Heaviness",
                  "Recovery Time",
                  "Rep Targets",
                  "Set Targets",
                  "Primary Goal",
                  "Increase Muscle",
                  "Risk To",
                ],
                highlightField: highlightField,
              ),
            ),
            Expanded(
              child: Container(
                color: (lightMode) ? Colors.white: Theme.of(context).primaryColor,
                child: Stack(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 16,
                      ),
                      child: CarouselSlider(
                        height: 256.0,
                        //so they can compare both
                        enableInfiniteScroll: (activeCount > 1),
                        enlargeCenterPage: true,
                        autoPlay: false,
                        viewportFraction: .75,
                        items: types,
                      ),
                    ),
                    Positioned(
                      top: 0,
                      bottom: 0,
                      child: Container(
                        width: 32,
                        decoration: BoxDecoration(
                          // Box decoration takes a gradient
                          gradient: LinearGradient(
                            tileMode: TileMode.clamp,
                            // Where the linear gradient begins and ends
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            // Add one stop for each color. Stops should increase from 0 to 1
                            stops: [0.1,1.0],
                            colors: [
                              (lightMode) ? Colors.white : Theme.of(context).primaryColor,
                              (lightMode) ? Colors.white.withOpacity(0) : Colors.transparent,
                            ],
                          ),
                        ),
                        child: Container(),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}