//flutter
import 'package:flutter/material.dart';
import 'package:swol/excerciseAddition/popUps/bodies/littleBodies.dart';
import 'package:swol/excerciseAddition/popUps/bodies/nameBody.dart';
import 'package:swol/shared/widgets/complex/learnPopUp/ourInformationPopUp.dart';

//widget
class HeaderWithInfo extends StatelessWidget {
  const HeaderWithInfo({
    Key key,
    @required this.header,
    @required this.title,
    @required this.subtitle,
    @required this.body,
    this.subtle: false,
  }) : super(key: key);

  final String header;
  final String title;
  final String subtitle;
  final Widget body;
  final bool subtle;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          header,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        Transform.translate(
          offset: Offset(12, 0),
          child: IconButton(
            onPressed: (){
              infoPopUpFunction(
                context,
                title: title,
                subtitle: subtitle,
                body: body,
              );
            },
            icon: Icon(Icons.info),
            color: subtle ? Theme.of(context).primaryColor :  Theme.of(context).accentColor,
          ),
        )
      ],
    );
  }
}

//-------------------------shortcuts-------------------------
class NameHeaderWithInfo extends StatelessWidget {
  NameHeaderWithInfo({
    this.subtle: false,
  });

  final bool subtle;

  @override
  Widget build(BuildContext context) {
    return HeaderWithInfo(
      header: "Name",
      title: "Excercise Name",
      subtitle: "Choose a unique name",
      body: ExcerciseNamePopUpBody(),
      subtle: subtle,
    );
  }
}

class NotesHeaderWithInfo extends StatelessWidget {
  NotesHeaderWithInfo({
    this.subtle: false,
  });

  final bool subtle;

  @override
  Widget build(BuildContext context) {
    return HeaderWithInfo(
      header: "Notes",
      title: "Excercise Note",
      subtitle: "Details",
      body: ExcerciseNotePopUpBody(),
      subtle: subtle,
    );
  }
}

class ReferenceLinkHeaderWithInfo extends StatelessWidget {
  ReferenceLinkHeaderWithInfo({
    this.subtle: false,
  });

  final bool subtle;

  @override
  Widget build(BuildContext context) {
    return HeaderWithInfo(
      header: "Reference Link",
      title: "Reference Link",
      subtitle: "Copy then Paste",
      body: ReferenceLinkPopUpBody(),
      subtle: subtle,
    );
  }
}