//flutter
import 'package:flutter/material.dart';

//standard UI
//used by 1. name when only 1 is editable at a time to tell users then need a name (should barely ever happen)
//used by 2. one rep max chip (chips stacking no big deal)
//used by 3. used by reference link to tell the user the link navigation didnt work
openSnackBar(
  BuildContext context, 
  String message, 
  Color color, 
  IconData icon,
  {
    bool dismissBeforeShow: true,
    bool quickDismissBeforeShow: false,
    bool dismissible: true,
    bool showForever: false,
  }
){
  //dismiss if desired
  if(dismissBeforeShow){
    Scaffold.of(context).hideCurrentSnackBar();
  }
  else if(quickDismissBeforeShow){
    Scaffold.of(context).removeCurrentSnackBar();
  }

  //main content
  Widget content = Row(
    children:[
      Padding(
        padding: const EdgeInsets.only(
          right: 8.0,
        ),
        child: Icon(
          icon,
          size: 24.0,
          color: color,
        ),
      ),
      Text(
        message,
        style: TextStyle(
          color: Colors.white,
        ),
      ),
    ]
  );

  //show snackbar
  Scaffold.of(context).showSnackBar(
    SnackBar(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      behavior: SnackBarBehavior.floating,
      //show "forever" if needed
      duration: showForever ? Duration(hours: 1) : Duration(seconds: 4),
      content: dismissible 
      //if its dismissible also make it possible to dismiss on tap
      ? GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: (){
          Scaffold.of(context).hideCurrentSnackBar();
        },
        child: content,
      ) 
      //make it undissmisible if needed
      : GestureDetector(
        behavior: HitTestBehavior.opaque,
        onVerticalDragStart: (_){},
        child: content,
      ),
    ),
  );
}