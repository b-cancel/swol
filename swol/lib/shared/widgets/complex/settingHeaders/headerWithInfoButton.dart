//flutter
import 'package:flutter/material.dart';

//internal: pop up bodies
import 'package:swol/shared/widgets/complex/settingHeaders/popUpBodies/recoveryTimeBody.dart';
import 'package:swol/shared/widgets/complex/settingHeaders/popUpBodies/predictionBody.dart';
import 'package:swol/shared/widgets/complex/settingHeaders/popUpBodies/repTargetBody.dart';
import 'package:swol/shared/widgets/complex/settingHeaders/popUpBodies/setTargetBody.dart';
import 'package:swol/shared/widgets/complex/settingHeaders/popUpBodies/littleBodies.dart';
import 'package:swol/shared/widgets/complex/settingHeaders/popUpBodies/nameBody.dart';

//internal: info pop up
import 'package:swol/shared/widgets/complex/settingHeaders/ourInformationPopUp.dart';

//widget
class _HeaderWithInfo extends StatelessWidget {
  const _HeaderWithInfo({
    Key key,
    @required this.header,
    @required this.title,
    @required this.subtitle,
    @required this.body,
    this.isDense: false,
    this.subtle: false,
  }) : super(key: key);

  final String header;
  final String title;
  final String subtitle;
  final Widget body;
  final bool isDense;
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
                isDense: isDense,
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

class NameHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _HeaderWithInfo(
      header: "Name",
      title: "Excercise Name",
      subtitle: "Choose a unique name",
      body: ExcerciseNamePopUpBody(),
    );
  }
}

class NotesHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _HeaderWithInfo(
      header: "Notes",
      title: "Excercise Note",
      subtitle: "Details",
      body: ExcerciseNotePopUpBody(),
    );
  }
}

class ReferenceLinkHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _HeaderWithInfo(
      header: "Reference Link",
      title: "Reference Link",
      subtitle: "Copy then Paste",
      body: ReferenceLinkPopUpBody(),
    );
  }
}

class SetTargetHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _HeaderWithInfo(
      header: "Set Target",
      title: "Set Target",
      subtitle: "Not sure? Keep the default",
      body: SetTargetPopUpBody(),
    );
  }
}

class RecoveryTimeHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _HeaderWithInfo(
      header: "Recovery Time",
      title: "Recovery Time",
      subtitle: "Not sure? Keep the default",
      body: RecoveryTimePopUpBody(),
    );
  }
}

class PredictionFormulaHeader extends StatelessWidget {
  PredictionFormulaHeader({
    this.subtle: false,
  });

  final bool subtle;

  @override
  Widget build(BuildContext context) {
    return _HeaderWithInfo(
      header: "Prediction Formula",
      title: "Prediction Formulas",
      subtitle: "Not sure? Keep the default",
      body: PredictionFormulasPopUpBody(),
      isDense: true,
      subtle: subtle,
    );
  }
}

class RepTargetHeader extends StatelessWidget {
  RepTargetHeader({
    this.subtle: false,
  });

  final bool subtle;

  @override
  Widget build(BuildContext context) {
    return _HeaderWithInfo(
      header: "Rep Target",
      title: "Rep Target",
      subtitle: "Not sure? Keep the default",
      body: RepTargetPopUpBody(),
      subtle: subtle,
    );
  }
}