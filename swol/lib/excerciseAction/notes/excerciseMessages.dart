import 'package:flutter/material.dart';

class ConfirmActionMessage extends StatelessWidget {
  const ConfirmActionMessage({
    Key key,
    @required this.buttonColor,
    @required this.iconSpace,
    @required this.icon,
    @required this.actionString,
    @required this.message,
    @required this.actionFunction,
    @required this.navSpread,
  }) : super(key: key);

  final Color buttonColor;
  final double iconSpace;
  final IconData icon;
  final String actionString;
  final Widget message;
  final Function actionFunction;
  final ValueNotifier<bool> navSpread;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData.light(),
      child: AlertDialog(
        titlePadding: EdgeInsets.all(0),
        title: Container(
          padding: EdgeInsets.all(16),
          color: buttonColor,
          child: Row(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(
                  right: iconSpace,
                ),
                child: Icon(
                  icon,
                  color: Colors.white,
                ),
              ),
              Text(
                actionString + " Excercise?",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
        contentPadding: EdgeInsets.all(0),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
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
              "No, Don't " + actionString,
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

              print("before deleting");
              actionFunction();

              //get rid of this pop up
              Navigator.of(context).pop();

              //go back to our excercise page
              Navigator.of(context).pop();

              //go back to our list
              Navigator.of(context).pop();

              //show the changing nav bar
              navSpread.value = false;
            },
            child: Text(
              "Yes, " + actionString,
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
           text: " at the bottom of your list of excercises\n\n",
         ),
         TextSpan(
           text: "If you ",
         ),
         TextSpan(
           text: "want to delete your excercise,\n",
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
            text: " from your list of excercises\n\n",
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