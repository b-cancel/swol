import 'package:flutter/material.dart';

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