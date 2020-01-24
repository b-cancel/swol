//flutter
import 'package:flutter/material.dart';

//internal
import 'package:swol/shared/widgets/complex/fields/headers/popUpBodies/recoveryTimeBody.dart';
import 'package:swol/shared/widgets/complex/fields/headers/popUpBodies/repTargetBody.dart';
import 'package:swol/shared/widgets/complex/fields/headers/ourInformationPopUp.dart';
import 'package:swol/shared/methods/theme.dart';

//widget
class HeaderWithInfo extends StatelessWidget {
  const HeaderWithInfo({
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
    return Theme(
      data: ThemeData.dark(),
      child: _HeaderWithInfoDark(
        header: header, 
        subtle: subtle,
        onPressed: (){
          infoPopUpFunction(
            //using white context
            //assumed for the users within this class
            context,
            //vars
            title: title,
            subtitle: subtitle,
            body: body,
            isDense: isDense,
          );
        },
      ),
    );
  }
}

class _HeaderWithInfoDark extends StatelessWidget {
  const _HeaderWithInfoDark({
    Key key,
    @required this.header,
    @required this.subtle,
    @required this.onPressed,
  }) : super(key: key);

  final String header;
  final bool subtle;
  final Function onPressed;

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
            onPressed: () => onPressed(),
            icon: Icon(Icons.info),
            color: subtle ? Theme.of(context).primaryColor :  Theme.of(context).accentColor,
          ),
        )
      ],
    );
  }
}

//-------------------------shortcuts-------------------------

class RecoveryTimeHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: MyTheme.light,
      child: HeaderWithInfo(
        header: "Recovery Time",
        title: "Recovery Time",
        subtitle: "Not sure? Keep the default",
        body: RecoveryTimePopUpBody(),
      ),
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
    return Theme(
      data: MyTheme.light,
      child: HeaderWithInfo(
        header: "Rep Target",
        title: "Rep Target",
        subtitle: "Not sure? Keep the default",
        body: RepTargetPopUpBody(),
        subtle: subtle,
      ),
    );
  }
}