import 'package:flutter/material.dart';

//title: "Reference Link",
//subtitle: "Copy and paste",
class ReferenceLinkPopUp extends StatelessWidget {
  const ReferenceLinkPopUp({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: 32,
        right: 32,
        bottom: 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            alignment: Alignment.centerLeft,
            child: Text(
              "It's helpful to have a resource at hand\n",
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            child: Text(
              "Link a video or image of the proper form, or anything else that might help",
            ),
          ),
        ],
      ),
    );
  }
}

//title: "Excercise Note",
//subtitle: "Details",
class ExcerciseNotePopUpBody extends StatelessWidget {
  const ExcerciseNotePopUpBody({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: 32,
        right: 32,
        bottom: 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            alignment: Alignment.centerLeft,
            child: Text(
              "A space for any extra details",
            ),
          ),
        ],
      ),
    );
  }
}