//flutter
import 'package:flutter/material.dart';

//plugin
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:swol/shared/methods/theme.dart';

//function
showCustomHeaderIconPopUp(
  BuildContext context, //should be light context
  List<Widget> children,
  Widget header, {
  AnimType animationType: AnimType.SCALE,
  bool dismissOnTouchOutside: true,
  bool regularPadding: true,
  bool isDense: false,
  Color headerBackground: Colors.blue,
  Widget clearBtn,
  Widget colorBtn,
}) {
  //unfocus so whatever was focused before doesnt annoying scroll us back
  //for some reason this only happens in addExercise
  //when opening popups for name, notes, link, and recovery time
  //still its annoying and hence must die
  FocusScope.of(context).unfocus(); 

  //set raised button color
  if(colorBtn != null){
    colorBtn = Theme(
      data: Theme.of(context).copyWith(
        buttonTheme: ButtonThemeData(
          textTheme: ButtonTextTheme.primary,
          buttonColor: Theme.of(context).accentColor,
        ),
      ), 
      child: colorBtn,
    );
  }

  //add action buttons if they exist
  bool hasAtleastOneButton = (clearBtn != null || colorBtn != null);
  if(hasAtleastOneButton){
    children.add(
      Padding(
        padding: EdgeInsets.only(
          right: 16.0,
          left: 16,
          top: 16,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(child: Container()),
            clearBtn ?? Container(),
            colorBtn ?? Container(),
          ]
        ),
      ),
    );
  }

  //show pop up
  AwesomeDialog(
    context: context,
    isDense: isDense,
    dismissOnTouchOutside: dismissOnTouchOutside,
    animType: animationType,
    customHeader: FittedBox(
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
    ),
    padding: EdgeInsets.all(0),
    body: Padding(
      padding: EdgeInsets.only(
        bottom: hasAtleastOneButton ? 0 : 8.0,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: children,
      ),
    ),
  ).show();
}

showBasicHeaderIconPopUp(
  BuildContext context, //should be light context
  List<Widget> children,
  DialogType dialogType,
  {
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

  //set raised button color
  if(colorBtn != null){
    colorBtn = Theme(
      data: Theme.of(context).copyWith(
        buttonTheme: ButtonThemeData(
          textTheme: ButtonTextTheme.primary,
          buttonColor: Theme.of(context).accentColor,
        ),
      ), 
      child: colorBtn,
    );
  }

  //add action buttons if they exist
  bool hasAtleastOneButton = (clearBtn != null || colorBtn != null);
  if(hasAtleastOneButton){
    children.add(
      Padding(
        padding: EdgeInsets.only(
          right: 16.0,
          left: 16,
          top: 16,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(child: Container()),
            clearBtn ?? Container(),
            colorBtn ?? Container(),
          ]
        ),
      ),
    );
  }

  //show pop up
  AwesomeDialog(
    context: context,
    isDense: isDense,
    dismissOnTouchOutside: dismissOnTouchOutside,
    headerAnimationLoop: false,
    animType: animationType,
    dialogType: dialogType,
    padding: EdgeInsets.all(0),
    body: Padding(
      padding: EdgeInsets.only(
        bottom: hasAtleastOneButton ? 0 : 8.0,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: children,
      ),
    ),
  ).show();
}