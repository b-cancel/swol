//flutter
import 'package:flutter/material.dart';

//plugins
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:swol/action/page.dart';

//internal
import 'package:swol/shared/widgets/complex/trainingTypeTables/cardTables.dart';

//widgets
class AllTrainingTypes extends StatelessWidget {
  AllTrainingTypes({
    this.highlightField: -1,
    this.sectionWithInitialFocus: 0,
    this.shadowColor: Colors.white,
    this.cardBackground: false,
  });

  final int highlightField;
  //we assume this is between 0 and 2
  final int sectionWithInitialFocus;
  final Color shadowColor;
  final bool cardBackground;

  @override
  Widget build(BuildContext context) {
    List<int> sections = new List<int>();
    for(int i = 0; i < 3; i++){
      //adjust the section being added
      int sectionToAdd = i + sectionWithInitialFocus;

      //add the section (adjust for wrap around above)
      if(sectionToAdd <= 2) sections.add(sectionToAdd);
      else sections.add(sectionToAdd - 3);
    }

    return TrainingTypeSections(
      highlightField: highlightField,
      sections: [sections],
      sectionID: new ValueNotifier(0),
      shadowColor: shadowColor,
      cardBackground: cardBackground,
    );
  }
}

class TrainingTypeSections extends StatefulWidget {
  const TrainingTypeSections({
    Key key,
    @required this.cardBackground,
    @required this.sections,
    @required this.sectionID,
    this.highlightField: -1,
    this.shadowColor: Colors.white,
  }) : super(key: key);

  final bool cardBackground;
  final List<List<int>> sections; 
  final ValueNotifier<int> sectionID;
  final int highlightField;
  final Color shadowColor;

  @override
  _TrainingTypeSectionsState createState() => _TrainingTypeSectionsState();
}

class _TrainingTypeSectionsState extends State<TrainingTypeSections> {
  Widget enduranceCard;
  Widget hypertrophyCard;
  Widget strengthCard;
  List<List<CardTable>> sectionsOfCards;
  List<Widget> carousels;
  var mainCarousel;

  sectionIDToCarouselAction(){
    WidgetsBinding.instance.addPostFrameCallback((_){
      if(mainCarousel == null) sectionIDToCarouselAction();
      else{
        mainCarousel.animateToPage(
          widget.sectionID.value,
          duration: ExercisePage.transitionDuration, 
          curve: Curves.linear,
        );
      }
    });
  }

  double cardHeight;

  @override
  void initState() {
    cardHeight = 256.0; //this is just the height that feels the nicest

    //create all default card
    enduranceCard = CardTable( 
      cardBackground: widget.cardBackground,
      height: cardHeight,
      items: [
        "Endurance",
        "Light",
        "0:15 to 1:00",
        "13+",
        "2 to 4",
        "Muscle Stress",
        "Endurance",
        "Tissue",
      ],
      highlightField: widget.highlightField,
      icon: FontAwesomeIcons.weight,
    );

    hypertrophyCard = CardTable(
      cardBackground: widget.cardBackground,
      height: cardHeight,
      items: [
        "\tHypertrophy",//NOTE: extra space for dumbell
        "Heavy",
        "1:05 to 2:00",
        "7 to 12",
        "3 to 5",
        "Hypertrophy", 
        "Size",
        "Joints & Tissue",
      ],
      highlightField: widget.highlightField,
      icon: FontAwesomeIcons.dumbbell,
    );

    strengthCard = CardTable(
      cardBackground: widget.cardBackground,
      height: cardHeight,
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
          height: cardHeight,
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
      height: cardHeight,
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

  @override
  Widget build(BuildContext context) {
    return Container(
      child: IntrinsicHeight(
        child: Row(
          children: <Widget>[
            Container(
              height: cardHeight, 
              child: CardTable(
                cardBackground: widget.cardBackground,
                height: cardHeight,
                persistent: true,
                items: [
                  "Training",
                  "Weight",
                  "Break",
                  "Rep Goal",
                  "Set Goal",
                  "Goal",
                  "Increase",
                  "Risk To",
                ],
                highlightField: widget.highlightField,
              ),
            ),
            Expanded(
              child: Stack(
                children: <Widget>[
                  mainCarousel,
                  Positioned(
                    top: 0,
                    bottom: 0,
                    child: Container(
                      width: 32, //16 * 2 basically
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
                            widget.shadowColor,
                            widget.shadowColor.withOpacity(0)
                          ],
                        ),
                      ),
                      child: Container(),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}