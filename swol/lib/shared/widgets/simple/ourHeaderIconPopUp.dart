//flutter
import 'package:flutter/material.dart';

//plugin
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:swol/awesomeDialog.dart';
import 'package:swol/shared/widgets/simple/popUpAdjustments.dart';

showBasicHeaderIconPopUp(
  BuildContext context, //should be light context
  List<Widget> titles,
  List<Widget> children,
  DialogType dialogType, {
  AnimType animationType: AnimType.SCALE,
  bool dismissOnTouchOutside: true,
  bool isDense: false,
  Widget clearBtn,
  Widget colorBtn,
}) {
  //unfocus so whatever was focused before doesnt annoying scroll us back
  //for some reason this only happens in addExercise
  //when opening popups for name, notes, link, and recovery time
  //still its annoying and hence must die
  FocusScope.of(context).unfocus();

  //show pop up
  MyAwesomeDialog(
    context: context,
    isDense: isDense,
    barrierDismissible: dismissOnTouchOutside,
    headerAnimationLoop: false,
    animType: animationType,
    dialogType: dialogType,
    body: AwesomeBody(
      titles: titles,
      children: children,
      clearBtn: clearBtn,
      colorBtn: colorBtn,
    ),
  ).show();
}

//function
showCustomHeaderIconPopUp(
  BuildContext context, //should be light context
  List<Widget> titles,
  List<Widget> children,
  Widget header, {
  AnimType animationType: AnimType.SCALE,
  bool dismissOnTouchOutside: true,
  bool regularPadding: true,
  bool isDense: false,
  Color headerBackground: Colors.blue,
  bool useRootNavigator: false,
  Widget clearBtn,
  Widget colorBtn,
}) {
  //unfocus so whatever was focused before doesnt annoying scroll us back
  //for some reason this only happens in addExercise
  //when opening popups for name, notes, link, and recovery time
  //still its annoying and hence must die
  FocusScope.of(context).unfocus();

  //show pop up
  MyAwesomeDialog(
    context: context,
    isDense: isDense,
    barrierDismissible: dismissOnTouchOutside,
    useRootNavigator: useRootNavigator,
    animType: animationType,
    customHeader: AwesomeHeader(
      headerBackground: headerBackground,
      regularPadding: regularPadding,
      header: header,
    ),
    body: AwesomeBody(
      titles: titles,
      children: children,
      clearBtn: clearBtn,
      colorBtn: colorBtn,
    ),
  ).show();
}

class AwesomeHeader extends StatelessWidget {
  const AwesomeHeader({
    required this.headerBackground,
    required this.regularPadding,
    required this.header,
    Key? key,
  }) : super(key: key);

  final Color headerBackground;
  final bool regularPadding;
  final Widget header;

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.contain,
      child: Padding(
        padding: EdgeInsets.all(4),
        child: Container(
          decoration: BoxDecoration(
            color: headerBackground,
            shape: BoxShape.circle,
          ),
          //NOTE: 28 is the max
          padding: EdgeInsets.all(
            8.0 + (regularPadding ? 24 : 0),
          ),
          child: Container(
            decoration: BoxDecoration(
              //color: Colors.green,
              shape: BoxShape.circle,
            ),
            width: 128,
            height: 128,
            child: FittedBox(
              fit: BoxFit.fill,
              child: Container(
                decoration: BoxDecoration(
                  //color: Colors.red,
                  shape: BoxShape.circle,
                ),
                child: header,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class AwesomeBody extends StatelessWidget {
  const AwesomeBody({
    Key? key,
    required this.titles,
    required this.children,
    required this.clearBtn,
    required this.colorBtn,
  }) : super(key: key);

  final List<Widget> titles;
  final List<Widget> children;
  final Widget clearBtn;
  final Widget colorBtn;

  @override
  Widget build(BuildContext context) {
    //add action buttons if they exist
    bool hasAtleastOneButton = (clearBtn != null || colorBtn != null);

    //build dat body
    return Padding(
      padding: EdgeInsets.only(
        bottom: hasAtleastOneButton ? 0 : 8.0,
      ),
      child: Column(
        children: <Widget>[
          TitleThatContainsTRBL(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: titles,
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: children,
          ),
          hasAtleastOneButton
              ? BottomButtonsThatResizeTRBL(
                  secondary: clearBtn ?? Container(),
                  primary: colorBtn ?? Container(),
                )
              : Container()
        ],
      ),
    );
  }
}
