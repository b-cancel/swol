import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:swol/learn/cardTable.dart';
import 'package:swol/sharedWidgets/timePicker.dart';

class ChangeRecoveryTimeWidget extends StatelessWidget {
  const ChangeRecoveryTimeWidget({
    Key key,
    @required this.changeDuration,
    @required this.recoveryPeriod,
  }) : super(key: key);

  final Duration changeDuration;
  final ValueNotifier<Duration> recoveryPeriod;

  @override
  Widget build(BuildContext context) {
    //add s? (such a minimal detail)
    int mins = recoveryPeriod.value.inMinutes;
    bool showS = (mins == 1) ? false : true;

    //build
    return IntrinsicWidth(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            color: Colors.red,
            width: MediaQuery.of(context).size.width,
            child: Theme(
              data: ThemeData.dark(),
              child: ScrollTrainingTypes(
                lightMode: true,
                highlightField: 2,
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
                  duration: recoveryPeriod,
                  darkTheme: false,
                ),
                MinsSecsBelowTimePicker(
                  showS: showS,
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

//TODO: pass the different sections of data
//for recovery we have 4 sections
//the widget that modifies that value should set the section that is passed to this widget
//[[0], [1], [1,2], [2]]
//show each array depending on each section
class ScrollTrainingTypes extends StatefulWidget {
  const ScrollTrainingTypes({
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
  _ScrollTrainingTypesState createState() => _ScrollTrainingTypesState();
}

class _ScrollTrainingTypesState extends State<ScrollTrainingTypes> {
  @override
  Widget build(BuildContext context) {
    List<Widget> types = new List<Widget>();

    int activeCount = 0;

    if(widget.showEndurance){
      activeCount++;
      types.add(
        CardTable(
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
        ),
      );
    }

    if(widget.showHypertrophy){
      activeCount++;
      types.add(
        CardTable(
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
        ),
      );
    }

    if(widget.showStrength){
      activeCount++;
      types.add(
        CardTable(
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
        ),
      );
    }

    int adjustedStartTraining = widget.sectionWithInitialFocus.clamp(0, types.length - 1);
    if(widget.sectionWithInitialFocus != 0){
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
                      child: CarouselSlider(
                        height: 256.0 + (3.0 * 8),
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