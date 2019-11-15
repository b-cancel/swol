import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:swol/learn/cardTable.dart';
import 'package:swol/sharedWidgets/timePicker.dart';

class ChangeRecoveryTimeWidget extends StatefulWidget {
  ChangeRecoveryTimeWidget({
    Key key,
    @required this.changeDuration,
    @required this.recoveryPeriod,
  }) : super(key: key);

  final Duration changeDuration;
  final ValueNotifier<Duration> recoveryPeriod;

  @override
  _ChangeRecoveryTimeWidgetState createState() => _ChangeRecoveryTimeWidgetState();
}

class _ChangeRecoveryTimeWidgetState extends State<ChangeRecoveryTimeWidget> {
  ValueNotifier<int> sectionID = new ValueNotifier(0);
  ValueNotifier<bool> showS = new ValueNotifier(false);

  recoveryPeriodToSectionID(){
    if(widget.recoveryPeriod.value < Duration(seconds: 15)) sectionID.value = 0; //nothing
    else{
      if(widget.recoveryPeriod.value <= Duration(minutes: 1)) sectionID.value = 1; //endurance
      else{
        if(widget.recoveryPeriod.value <= Duration(minutes: 2)) sectionID.value = 2; //hypertrophy
        else{
          if(widget.recoveryPeriod.value < Duration(minutes: 3)) sectionID.value = 3; //hypertrophy/strength
          else sectionID.value = 4;
        }
      }
    }
  }

  recoveryPeriodToShowS(){
    int mins = widget.recoveryPeriod.value.inMinutes;
    showS.value = ((mins == 1) ? false : true);
  }

  //TODO: uncomment after we are sure the other more important stuff works
  manualSetState(){
    /*
    WidgetsBinding.instance.addPostFrameCallback((_){
      if(mounted){
        setState(() {});
      }
    });
    */
  }

  @override
  void initState() {
    //initial function calls
    recoveryPeriodToSectionID();
    recoveryPeriodToShowS();

    //as the recovery period changes updates should occur
    widget.recoveryPeriod.addListener(recoveryPeriodToSectionID);
    widget.recoveryPeriod.addListener(recoveryPeriodToShowS);

    //when showS changes we should set state (on next frame)
    showS.addListener(manualSetState);

    //super init
    super.initState();
  }

  @override
  void dispose() {
    widget.recoveryPeriod.removeListener(recoveryPeriodToSectionID);
    widget.recoveryPeriod.removeListener(recoveryPeriodToShowS);
    showS.removeListener(manualSetState);

    //super dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IntrinsicWidth(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width,
            child: Theme(
              data: ThemeData.dark(),
              child: ScrollTrainingTypes(
                lightMode: true,
                highlightField: 2,
                //nothing / endurance / hypertrohpy / hypertrophy & strength / strength and above
                sections: [[0], [0], [1], [1,2], [2]],
                sectionID: sectionID,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
            ),
            child: Column(
              children: <Widget>[
                TimePicker(
                  duration: widget.recoveryPeriod,
                  darkTheme: false,
                ),
                //TODO: this widget should take in duration and decide based on that to avoid uneeded reloads elsewhere
                MinsSecsBelowTimePicker(
                  showS: showS.value,
                  darkTheme: false,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

//TODO: finish the carosel in the carosel
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