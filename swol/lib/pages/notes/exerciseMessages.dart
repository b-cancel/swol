//flutter
import 'package:flutter/material.dart';

//internal
import 'package:swol/shared/methods/theme.dart';
import 'package:swol/main.dart';

//widget
class ConfirmActionMessage extends StatelessWidget {
  const ConfirmActionMessage({
    Key key,
    @required this.buttonColor,
    @required this.image,
    @required this.iconSpace,
    @required this.icon,
    @required this.actionString,
    @required this.message,
    @required this.actionFunction,
  }) : super(key: key);

  final Color buttonColor;
  final Widget image; 
  final double iconSpace;
  final IconData icon;
  final String actionString;
  final Widget message;
  final Function actionFunction;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: MyTheme.light,
      child: AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(12.0)
          ),
        ),
        contentPadding: EdgeInsets.all(0),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                color: buttonColor,
                borderRadius: new BorderRadius.only(
                  topLeft:  const  Radius.circular(12.0),
                  topRight: const  Radius.circular(12.0),
                ),
              ),
              child: image,
            ),
            Padding(
              padding: const EdgeInsets.only(
                top: 16.0,
              ),
              child: Container(
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(
                  horizontal: 16,
                ),
                child: DefaultTextStyle(
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                    color: Colors.black,
                  ),
                  child: Text(actionString + " Exercise?"),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: message,
            ),
          ],
        ),
        actions: <Widget>[
          FlatButton(
            onPressed: (){
              Navigator.of(context).pop();
            },
            child: Text(
              "Don't " + actionString,
              style: TextStyle(
                color: Theme.of(context).primaryColorDark,
              ),
            ),
          ),
          RaisedButton(
            color: buttonColor,
            onPressed: (){
              //get rid of keyboard that MAY be shown
              FocusScope.of(context).unfocus();

              actionFunction();

              //get rid of this pop up
              Navigator.of(context).pop();

              //go back to our exercise page
              Navigator.of(context).pop();

              //go back to our list
              Navigator.of(context).pop();

              //show the changing nav bar
              App.navSpread.value = false;
            },
            child: Text(
              actionString,
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class HideMessage extends StatelessWidget {
  const HideMessage({
    Key key,
    @required this.theName,
  }) : super(key: key);

  final String theName;

  @override
  Widget build(BuildContext context) {
    return RichText(
     text: TextSpan(
       style: TextStyle(
         color: Colors.black,
       ),
       children: [
         TextSpan(
           text: theName,
           style: TextStyle(
             fontWeight: FontWeight.bold,
           )
         ),
         TextSpan(
           text: " will be ",
         ),
         TextSpan(
           text: "Hidden",
           style: TextStyle(
             fontWeight: FontWeight.bold
           ),
         ),
         TextSpan(
           text: " at the bottom of your list of exercises\n\n",
         ),
         TextSpan(
           text: "If you ",
         ),
         TextSpan(
           text: "want to delete your exercise,\n",
           style: TextStyle(
             fontWeight: FontWeight.bold
           ),
         ),
         TextSpan(
           text: "then you should "
         ),
         TextSpan(
           text: "Delete",
           style: TextStyle(
             fontWeight: FontWeight.bold
           ),
         ),
         TextSpan(
           text: " it instead"
         ),
       ]
     ),
      );
  }
}

class DeleteMessage extends StatelessWidget {
  const DeleteMessage({
    Key key,
    @required this.theName,
  }) : super(key: key);

  final String theName;

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: TextStyle(
          color: Colors.black,
        ),
        children: [
          TextSpan(
            text: theName,
            style: TextStyle(
              fontWeight: FontWeight.bold,
            )
          ),
          TextSpan(
            text: " will be ",
          ),
          TextSpan(
            text: "Permanently Deleted",
            style: TextStyle(
              fontWeight: FontWeight.bold
            ),
          ),
          TextSpan(
            text: " from your list of exercises\n\n",
          ),
          TextSpan(
            text: "If you ",
          ),
          TextSpan(
            text: "don't want to lose your data,\n",
            style: TextStyle(
              fontWeight: FontWeight.bold
            ),
          ),
          TextSpan(
            text: "but you do want to stop it from cycling back up the list, "
          ),
          TextSpan(
            text: "then you should "
          ),
          TextSpan(
            text: "Hide",
            style: TextStyle(
              fontWeight: FontWeight.bold
            ),
          ),
          TextSpan(
            text: " it instead"
          ),
        ]
      ),
    );
  }
}