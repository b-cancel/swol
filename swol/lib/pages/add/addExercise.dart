//flutter
import 'package:flutter/material.dart';

//plugins
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

//internal: addition
import 'package:swol/pages/add/widgets/matchTrainingTypeTip.dart';
import 'package:swol/pages/add/widgets/reloadingCard.dart';
import 'package:swol/pages/add/widgets/save.dart';
import 'package:swol/shared/methods/theme.dart';

//internal: shared
import 'package:swol/shared/widgets/complex/fields/fields/text/notesField.dart';
import 'package:swol/shared/widgets/complex/fields/fields/linkField/link.dart';
import 'package:swol/shared/widgets/complex/fields/fields/text/nameField.dart';
import 'package:swol/shared/structs/anExercise.dart';

//internal: other
import 'package:swol/pages/selection/widgets/addNewHero.dart';
import 'package:swol/main.dart';
import 'package:swol/shared/widgets/complex/fields/headers/fieldHeader.dart';
import 'package:swol/shared/widgets/complex/trainingTypeTables/trainingTypes.dart';
import 'package:swol/shared/widgets/simple/toLearnPage.dart';

//main widget
class AddExercise extends StatefulWidget {
  AddExercise({
    Key? key,

    //NOTE: 200 ms above the norm so they can see the sweat animation
    required this.longTransitionDuration,
    this.showListDuration: const Duration(milliseconds: 350),
    this.showSaveDuration: const Duration(milliseconds: 350),

    //this delay plays AFTER the page completely shows
    this.delayBetweenListItems: const Duration(milliseconds: 500),
    this.delayBeforeSaveShow: const Duration(milliseconds: 450),
  }) : super(key: key);

  final Duration longTransitionDuration;
  final Duration showListDuration;
  final Duration showSaveDuration;

  //this delay plays AFTER the page completely shows
  final Duration delayBetweenListItems;
  final Duration delayBeforeSaveShow;

  @override
  _AddExerciseState createState() => _AddExerciseState();
}

class _AddExerciseState extends State<AddExercise> {
  final ValueNotifier<bool> showSaveButton = new ValueNotifier(false);

  final ValueNotifier<bool> namePresent = new ValueNotifier(false);

  final ValueNotifier<bool> nameError = new ValueNotifier(false);

  final ValueNotifier<String> name = new ValueNotifier("");

  final ValueNotifier<String> note = new ValueNotifier("");

  final ValueNotifier<String> url = new ValueNotifier("");

  final ValueNotifier<int> functionID = new ValueNotifier(
    AnExercise.defaultFunctionID,
  );

  final ValueNotifier<Duration> recoveryPeriod = new ValueNotifier(
    AnExercise.defaultRecovery,
  );

  final ValueNotifier<int> setTarget = new ValueNotifier(
    AnExercise.defaultSetTarget,
  );

  final ValueNotifier<int> repTarget = new ValueNotifier(
    AnExercise.defaultRepTarget,
  );

  final FocusNode nameFocusNode = FocusNode();

  final FocusNode noteFocusNode = FocusNode();

  //TODO: ***ANNOYING BUT EASY TO AVOID: its possible to navigate away from the page without knowing
  //and lose what you plugged in for your new exercise already
  //so save the state when you back up and restore it when you come back
  //you can navigate away by going to learn more

  //TODO: ***ANNOYING BUT ONLY WHEN ADDING EXERCISE: make BELOW functional, decided to skip since we can't currently do this
  //since we can't make the time picker update this way unless we do some hacks
  //the hack would be simply to have a manual reload that builds a different picker
  //but ONLY if the picker is being set by something else
  //figuring that out is what can suck up my time
  //we wanted to do this so when we INITIALLY update repTarget without touching set target and recovery
  //repTarget also updates setTarget and recovery
  //since those two should be set based on repTarget

  final ValueNotifier<String> updateableTipMessage =
      new ValueNotifier<String>("");
  final ValueNotifier<bool> tipIsShowing = new ValueNotifier<bool>(false);

  final ValueNotifier<int> goalID = new ValueNotifier(1);

  setSelectedValue() {
    //Focus on:
    //Getting Strong  |   4 sets  | 6 reps  | 3:00 minutes of break
    //Getting Big     |   3 sets  | 9 reps  | 2:00 minutes of break
    //Getting Agile   |   2 sets  | 12 reps | 1:00 minute of break
    if (goalID.value == 0) {
      setTarget.value = 4;
      repTarget.value = 6;
      recoveryPeriod.value = Duration(
        minutes: 3,
      );
    } else if (goalID.value == 1) {
      setTarget.value = 3;
      repTarget.value = 9;
      recoveryPeriod.value = Duration(
        minutes: 2,
      );
    } else {
      setTarget.value = 2;
      repTarget.value = 12;
      recoveryPeriod.value = Duration(
        minutes: 1,
      );
    }

    //this won't really be used soon
    functionID.value = 0;
  }

  @override
  void initState() {
    setSelectedValue();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //each section
    List<Widget> sections = [
      ReloadingCard(
        notifier: nameError,
        child: NameField(
          nameToUpdate: name,
          showError: nameError,
          namePresent: namePresent,
          nameFocusNode: nameFocusNode,
          noteFocusNode: noteFocusNode,
          autofocus: false,
        ),
      ),
      NonReloadingCard(
        child: AnimatedBuilder(
          animation: goalID,
          builder: (context, snapshot) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Theme(
                  data: MyTheme.light,
                  child: HeaderWithInfo(
                    header: "Main Focus",
                    title: "Main Focus",
                    subtitle: "we'll help you stay focused",
                    body: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 24,
                          ),
                          child: RichText(
                            textScaleFactor: MediaQuery.of(
                              context,
                            ).textScaleFactor,
                            text: TextSpan(
                              style: TextStyle(
                                color: Colors.black,
                              ),
                              children: [
                                TextSpan(
                                  text:
                                      "by selecting a rep goal, set recovery time, and set goal for you",
                                ),
                              ],
                            ),
                          ),
                        ),
                        Theme(
                          data: MyTheme.dark,
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: 8,
                            ),
                            child: AllTrainingTypes(
                              sectionWithInitialFocus: goalID.value,
                            ),
                          ),
                        ),
                        SuggestToLearnPage(),
                      ],
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(
                      color: Colors.blue,
                      width: 2,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                        child: FocusButton(
                          iconData: FontAwesomeIcons.weight,
                          focus: "Get Agile",
                          trainingType: "Endurance",
                          selectedGoal: goalID,
                          ourGoalIndex: 0,
                        ),
                      ),
                      Expanded(
                        child: FocusButton(
                          iconData: FontAwesomeIcons.dumbbell,
                          focus: "Get Big",
                          trainingType: "Hypertrophy",
                          selectedGoal: goalID,
                          ourGoalIndex: 1,
                        ),
                      ),
                      Expanded(
                        child: FocusButton(
                          iconData: FontAwesomeIcons.weightHanging,
                          focus: "Get Strong",
                          trainingType: "Strength",
                          selectedGoal: goalID,
                          ourGoalIndex: 2,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
      NonReloadingCard(
        child: NotesField(
          noteToUpdate: note,
          noteFocusNode: noteFocusNode,
        ),
      ),
      NonReloadingCard(
        child: LinkField(url: url),
      ),
    ];

    //build
    return WillPopScope(
      onWillPop: () async {
        FocusScope.of(context).unfocus();
        App.navSpread.value = false;
        return true; //can still pop
      },
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight),
          child: Container(
            width: MediaQuery.of(context).size.width,
            color: Colors.transparent,
            child: SafeArea(
              child: Container(
                child: Stack(
                  alignment: Alignment.center,
                  children: <Widget>[
                    Positioned(
                      left: 0,
                      bottom: 0,
                      top: 0,
                      right: 0,
                      child: AddNewHero(
                        inAppBar: true,
                        longTransitionDuration: widget.longTransitionDuration,
                      ),
                    ),
                    Positioned(
                      right: 0,
                      top: 0,
                      bottom: 0,
                      child: Padding(
                        padding: const EdgeInsets.only(
                          right: 8.0,
                        ),
                        child: SaveButton(
                          delay: widget.longTransitionDuration +
                              widget.delayBeforeSaveShow,
                          showSaveButton: showSaveButton,
                          nameFocusNode: nameFocusNode,
                          nameError: nameError,
                          //transition duration
                          showSaveDuration: widget.showSaveDuration,
                          //variables
                          namePresent: namePresent,
                          name: name,
                          url: url,
                          note: note,
                          functionIndex: functionID,
                          repTarget: repTarget,
                          recoveryPeriod: recoveryPeriod,
                          setTarget: setTarget,
                        ),
                      ),
                    ),
                    TipGenerator(
                      tipIsShowing: tipIsShowing,
                      updateableTipMessage: updateableTipMessage,
                      recoveryPeriod: recoveryPeriod,
                      setTarget: setTarget,
                      repTarget: repTarget,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        body: Container(
          color: Theme.of(context).scaffoldBackgroundColor,
          child: AnimationLimiter(
            child: ListView.builder(
              shrinkWrap: true,
              padding: EdgeInsets.symmetric(
                vertical: 16,
              ),
              itemCount: sections.length,
              itemBuilder: (BuildContext context, int index) {
                return AnimationConfiguration.staggeredList(
                  position: index,
                  //500 (page slide in) + 250 (save button show)
                  delay: (widget.delayBetweenListItems),
                  duration: widget.showListDuration,
                  child: SlideAnimation(
                    verticalOffset: 50.0,
                    child: FadeInAnimation(
                      child: sections[index],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class FocusButton extends StatelessWidget {
  const FocusButton({
    required this.iconData,
    required this.focus,
    required this.trainingType,
    required this.selectedGoal,
    required this.ourGoalIndex,
    Key? key,
  }) : super(key: key);

  final IconData iconData;
  final String focus;
  final String trainingType;
  final ValueNotifier<int> selectedGoal;
  final int ourGoalIndex;

  @override
  Widget build(BuildContext context) {
    bool isSelected = selectedGoal.value == ourGoalIndex;
    Color backColor = isSelected ? Colors.blue : Colors.transparent;
    Color foreColor = isSelected ? Colors.white : Colors.white;
    return Material(
      color: backColor,
      borderRadius: BorderRadius.circular(4),
      child: InkWell(
        borderRadius: BorderRadius.circular(4),
        onTap: () {
          selectedGoal.value = ourGoalIndex;
        },
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              Transform.translate(
                offset: Offset(
                  iconData == FontAwesomeIcons.dumbbell ? -3 : 0,
                  0,
                ),
                child: Icon(
                  iconData,
                  color: foreColor,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  top: 8.0,
                ),
                child: Text(
                  focus,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: foreColor,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  top: 4,
                ),
                child: Text(
                  trainingType + "\n" + "Training",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: foreColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
