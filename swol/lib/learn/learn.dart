//flutter
import 'package:flutter/material.dart';

//plugin
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:expandable/expandable.dart';

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
  List<ExpandableController> allControllers;
  ExpandableController definitionCtrl = ExpandableController(
    initialExpanded: false,
  );
  ExpandableController trainingCtrl = ExpandableController(
    initialExpanded: false,
  );
  ExpandableController precautionsCtrl = ExpandableController(
    initialExpanded: false,
  );
  ExpandableController oneRepMaxCtrl = ExpandableController(
    initialExpanded: false,
  );
  ExpandableController experimentCtrl = ExpandableController(
    initialExpanded: false,
  );
  ExpandableController researchCtrl = ExpandableController(
    initialExpanded: false,
  );

  closeOthers(ExpandableController ctrl){
    for(int i = 0; i < allControllers.length; i++){
      ExpandableController thisCtrl = allControllers[i];
      if(thisCtrl != ctrl){
        print(i.toString() + " -> 1");
        if(thisCtrl.expanded){
          print("closed");
          thisCtrl.expanded = false;
        }
      }
      else print(i.toString() + " -> 0");
    }
  }

  @override
  void initState() {
    //super init
    super.initState();

    //make controller list
    allControllers = new List<ExpandableController>();
    allControllers.addAll([
      definitionCtrl,
      trainingCtrl,
      precautionsCtrl,
      oneRepMaxCtrl,
      experimentCtrl,
      researchCtrl,
    ]);
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
            )
          ], 
        ),
        body: new ListView(
          children: [
            new InfoSection(
              headerIcon: FontAwesomeIcons.solidLightbulb, 
              headerText: "Introduction", 
              permanentlyOpen: true,
              thisExpanded: IntroductionBody(),
            ),
            new InfoSection(
              expandableController: definitionCtrl,
              headerIcon: Icons.chrome_reader_mode, 
              headerText: "Definitions", 
              thisExpanded: Text("info"),
              closeOthers: closeOthers,
            ),
            new InfoSection(
              expandableController: trainingCtrl,
              headerIcon: FontAwesomeIcons.dumbbell, 
              size: 18,
              headerText: "Training", 
              thisExpanded: Text("info"),
              closeOthers: closeOthers,
            ),
            new InfoSection(
              expandableController: precautionsCtrl,
              headerIcon: Icons.warning, 
              headerText: "Precautions", 
              thisExpanded: Text("info"),
              closeOthers: closeOthers,
            ),
            new InfoSection(
              expandableController: oneRepMaxCtrl,
              headerIcon: FontAwesomeIcons.trophy, 
              size: 20,
              headerText: "1 Rep Max", 
              thisExpanded: Text("info"),
              closeOthers: closeOthers,
            ),
            new InfoSection(
              expandableController: experimentCtrl,
              headerIcon: FontAwesomeIcons.flask, 
              headerText: "Experiment", 
              thisExpanded: Text("info"),
              closeOthers: closeOthers,
            ),
            new InfoSection(
              expandableController: researchCtrl,
              headerIcon: FontAwesomeIcons.book, 
              headerText: "Research", 
              thisExpanded: Text("info"),
              closeOthers: closeOthers,
            ),
          ],
        ),
      ),
    );
  }
}

class InfoSection extends StatelessWidget {
  const InfoSection({
    Key key,
    @required this.headerIcon,
    @required this.headerText,
    @required this.thisExpanded,
    //optional
    this.expandableController,
    this.closeOthers,
    this.permanentlyOpen: false,
    this.size,
  }) : super(key: key);

  final IconData headerIcon;
  final String headerText;
  final Widget thisExpanded;
  //optional
  final ExpandableController expandableController;
  final Function closeOthers;
  final bool permanentlyOpen;
  final double size;

  @override
  Widget build(BuildContext context) {
    ExpandableController actualExpandableController;
    if(expandableController == null){
      actualExpandableController = ExpandableController(
        initialExpanded: permanentlyOpen,
      );
    }
    else{
      actualExpandableController = expandableController;
    }

    actualExpandableController.addListener((){
      closeOthers(actualExpandableController);
    });

    return ExpandableNotifier(
      initialExpanded: permanentlyOpen,
      child: ScrollOnExpand(
        child: Card(
          color: Theme.of(context).primaryColor,
          margin: EdgeInsets.all(8),
          child: ExpandablePanel(
            controller: actualExpandableController,
            //basic booleans
            tapHeaderToExpand: (permanentlyOpen == false),
            tapBodyToCollapse: false,
            hasIcon: (permanentlyOpen == false),
            //other
            header: Container(
              padding: EdgeInsets.all(16),
              child: Row(
                children: <Widget>[
                  Container(
                    alignment: Alignment.centerLeft,
                    width: 22 + 8.0,
                    child: Icon(
                      headerIcon,
                      size: (size == null) ? 24 : size,
                    ),
                  ),
                  Text(
                    headerText,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            /*
            collapsed: Text(
              "collapsed", 
              softWrap: true, 
              maxLines: 2, 
              overflow: TextOverflow.ellipsis,
            ),
            */
            expanded: Container(
              color: Theme.of(context).cardColor,
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.all(
                16,
              ),
              child: thisExpanded,
            ),
          ),
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
      padding: EdgeInsets.only(
        top: 4,
        bottom: 4,
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
                  text: "\tEnjoy Pumping Iron!\t",
                ),
              ]
            ),
          ),
        ],
      ),
    );
  }
}