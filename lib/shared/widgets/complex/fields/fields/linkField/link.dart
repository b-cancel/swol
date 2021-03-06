//flutter
import 'package:flutter/material.dart';

//internal
import 'package:swol/shared/widgets/complex/fields/fields/linkField/linkEditor.dart';
import 'package:swol/shared/widgets/complex/fields/headers/fieldHeader.dart';
import 'package:swol/shared/methods/theme.dart';

//widgets
class LinkField extends StatelessWidget {
  LinkField({
    this.editOneAtATime: false,
    required this.url,
  });

  final bool editOneAtATime;
  final ValueNotifier<String> url;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Theme(
          data: MyTheme.light,
          child: HeaderWithInfo(
            header: "Reference Link",
            title: "Reference Link",
            subtitle: "Copy then Paste",
            body: _LinkPopUpBody(),
          ),
        ),
        LinkEditor(
          url: url,
          editOneAtATime: editOneAtATime,
        ),
      ],
    );
  }
}

class _LinkPopUpBody extends StatelessWidget {
  const _LinkPopUpBody({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            alignment: Alignment.centerLeft,
            child: Text(
              "It's helpful to have an external resource at hand\n",
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            child: Text(
              "Link a video or image of the proper form, or anything else that might help you exercise safely and correctly",
            ),
          ),
        ],
      ),
    );
  }
}
