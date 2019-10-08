//flutter
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

//plugin
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:folding_cell/folding_cell.dart';
import 'package:swol/learn/foldingCard.dart';

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
  Map<GlobalKey<SimpleFoldingCellState>, bool> cellKeysToOpen;
  final introductionCellKey = GlobalKey<SimpleFoldingCellState>();
  final definitionsCellKey = GlobalKey<SimpleFoldingCellState>();
  final trainingCellKey = GlobalKey<SimpleFoldingCellState>();
  final precautionsCellKey = GlobalKey<SimpleFoldingCellState>();
  final oneRepMaxCellKey = GlobalKey<SimpleFoldingCellState>();
  final experimentCellKey = GlobalKey<SimpleFoldingCellState>();
  final futureResearchCellKey = GlobalKey<SimpleFoldingCellState>();

  @override
  void initState() { 
    //super init
    super.initState();
    
    //create list of keys
    cellKeysToOpen = {
      introductionCellKey: false,
      definitionsCellKey: false,
      trainingCellKey: false,
      precautionsCellKey: false,
      oneRepMaxCellKey: false,
      experimentCellKey: false,
      futureResearchCellKey: false,
    };
  }

  //NOTE: assumes that open is only called IF its close
  openSection(GlobalKey<SimpleFoldingCellState> thisCellKey){
    //open ourselves
    thisCellKey.currentState.toggleFold();
    cellKeysToOpen[thisCellKey] = true;

    //close others
    List<GlobalKey<SimpleFoldingCellState>> cellKeys = cellKeysToOpen.keys;
    for(int i = 0; i < cellKeys.length; i++){
      GlobalKey<SimpleFoldingCellState> cellKey = cellKeys[i];
      //others
      if(cellKey != thisCellKey){
        //that are open (will only ever be one)
        //TODO: given the above CAN optimize
        if(cellKeysToOpen[cellKey]){
          cellKey.currentState.toggleFold();
          cellKeysToOpen[cellKey] = false;
        }
      }
    }
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
              Icon(FontAwesomeIcons.bookOpen),
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
        body: new ListView(
          children: [
            SimpleFoldingCell(
              unfoldCell: true,
              skipAnimation: false, //TODO: maybe we should do this?
              padding: EdgeInsets.all(16),
              animationDuration: Duration(milliseconds: 300),
              borderRadius: 24,
              //-----
              frontWidget: buildFrontWidget(
                "Introduction", 
                (){},
              ),
              innerTopWidget: buildInnerTopWidget(),
              innerBottomWidget: buildInnerBottomWidget(
                (){},
              ),
              cellSize: Size(MediaQuery.of(context).size.width, 125),
            ),
            IntroductionHeader(),
            IntroductionBody(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Wrap(
                spacing: 16,
                runSpacing: 16,
                children: <Widget>[
                  Icon(Icons.description),
                  Icon(Icons.chrome_reader_mode),
                  Icon(Icons.warning),
                  Icon(FontAwesomeIcons.lightbulb),
                  Icon(FontAwesomeIcons.solidLightbulb),
                  Icon(FontAwesomeIcons.rocket),
                  Icon(FontAwesomeIcons.userAstronaut),
                  Icon(FontAwesomeIcons.book),
                  Icon(FontAwesomeIcons.bookDead),
                  Icon(FontAwesomeIcons.bookmark),
                  Icon(FontAwesomeIcons.solidBookmark),
                  Icon(FontAwesomeIcons.dumbbell),
                  Icon(FontAwesomeIcons.weight),
                  Icon(FontAwesomeIcons.weightHanging),
                  Icon(FontAwesomeIcons.skullCrossbones),
                  Icon(FontAwesomeIcons.skull),
                  Icon(FontAwesomeIcons.trophy),
                  Icon(FontAwesomeIcons.award),
                  Icon(FontAwesomeIcons.medal),
                  Icon(FontAwesomeIcons.flask),
                  Icon(FontAwesomeIcons.searchPlus),
                  Icon(FontAwesomeIcons.researchgate),
                  Icon(FontAwesomeIcons.search),
                  Icon(FontAwesomeIcons.graduationCap),
                  Icon(FontAwesomeIcons.userGraduate),
                  Icon(FontAwesomeIcons.chalkboard),
                  Icon(FontAwesomeIcons.chalkboardTeacher),
                  Icon(FontAwesomeIcons.school),
                  Icon(FontAwesomeIcons.leanpub),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class IntroductionHeader extends StatelessWidget {
  const IntroductionHeader({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        right: 16,
      ),
      child: Container(
        padding: EdgeInsets.only(
          top: 8,
        ),
        width: MediaQuery.of(context).size.width,
        alignment: Alignment.centerLeft,
        child: Container(
          padding: EdgeInsets.only(
            left: 16,
          ),
          child: FractionallySizedBox(
            widthFactor: .50,
            child: FittedBox(
              fit: BoxFit.contain,
              child: Text(
                "Introduction",
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
        ),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              width: 1,
              color: Colors.grey,
            )
          )
        ),
      ),
    );
  }
}

class IntroductionBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String tab = "\t\t\t\t\t";
    String newLine = "\n";
    TextStyle defaultStyle = TextStyle(
      fontSize: 16,
    );

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      child: Column(
        children: <Widget>[
          RichText(
            text: TextSpan(
              style: defaultStyle,
              children: [
                TextSpan(
                  text: tab + "Swol is an app that helps "
                ),
                TextSpan(
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                  ),
                  text: "\thelps beginners get into weightlifting as quick as possible.\t"
                ),
                TextSpan(
                  text: " It does not focus on tracking progress; it focuses on creating a habit. "
                  +" What matters is that you do the best that you can now; the results will come on their own." + newLine,
                ),
              ]
            ),
          ),
          RichText(
            text: TextSpan(
              style: defaultStyle,
              children: [
                TextSpan(
                  text: tab + "In order to help you, "
                ),
                TextSpan(
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                  ),
                  text: "\twe have many suggestions\t"
                ),
                TextSpan(
                  text: " but it's your responsibility to stay safe. "
                  +"We are not liable for any harm that you may cause yourself or others. "
                ),
                TextSpan(
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                  ),
                  text: "\tFollow our suggestions at your own risk.\t" + newLine,
                ),
              ]
            ),
          ),
          RichText(
            text: TextSpan(
              style: defaultStyle,
              children: [
                TextSpan(
                  text: tab + "Additionally, be aware that "
                ),
                TextSpan(
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                  ),
                  text: "\tpart of our app is experimental.\t"
                ),
                TextSpan(
                  text: " We suspect that one rep max formulas can be used to give users a new goal to work towards after each set,"
                  +" but this has not been proven yet." + newLine,
                ),
              ]
            ),
          ),
          RichText(
            text: TextSpan(
              style: defaultStyle,
              children: [
                TextSpan(
                  text: tab + "Below are some suggestions to get you started. "
                ),
                TextSpan(
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                  ),
                  text: "\tEnjoy Pumping Iron!\t" + newLine,
                ),
              ]
            ),
          ),
        ],
      ),
    );
  }
}