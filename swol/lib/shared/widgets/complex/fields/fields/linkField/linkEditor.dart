//flutter
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:swol/shared/widgets/simple/conditional.dart';

//plugin
import 'package:url_launcher/url_launcher.dart';

//internal
import 'package:swol/shared/widgets/simple/ourSnackBar.dart';
import 'package:swol/pages/notes/fieldEditButtons.dart';

//widgets
class LinkEditor extends StatefulWidget {
  const LinkEditor({
    Key? key,
    required this.editOneAtATime,
    required this.url,
  }) : super(key: key);

  //params
  final bool editOneAtATime;
  final ValueNotifier<String?> url;

  @override
  _LinkEditorState createState() => _LinkEditorState();
}

class _LinkEditorState extends State<LinkEditor> {
  ValueNotifier<bool> isEditing = new ValueNotifier(false);

  updateState() {
    if (mounted) setState(() {});
  }

  @override
  void initState() {
    super.initState();
    if (widget.editOneAtATime) {
      isEditing.addListener(updateState);
    } else {
      widget.url.addListener(updateState);
    }
  }

  @override
  void dispose() {
    if (widget.editOneAtATime) {
      isEditing.addListener(updateState);
    } else {
      widget.url.addListener(updateState);
    }
    super.dispose();
  }

  showWarning(String message) {
    openSnackBar(
      context,
      Colors.yellow,
      Icons.warning,
      message: message,
    );
  }

  //NOTE: clearing or pasting a link finalizes an edit
  @override
  Widget build(BuildContext context) {
    bool showToEditButton = (widget.editOneAtATime && isEditing.value == false);

    //NOTE: only show the edit buttons sometimes (clear and paste)
    bool showEditButtons;
    if (widget.editOneAtATime == false)
      showEditButtons = true;
    else {
      if (isEditing.value)
        showEditButtons = true;
      else
        showEditButtons = false;
    }

    bool showClearAndConfirmButtons =
        (showEditButtons && widget.url.value != "");
    bool showPasteButton = showEditButtons;

    //ez condition
    bool emptyUrl = (widget.url.value == null || widget.url.value!.length == 0);

    //normal widget
    Widget normalOne = Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        //IF we can only edit one at a time AND we are not editing
        showToEditButton ? EditButton(isEditing: isEditing) : Container(),
        (showClearAndConfirmButtons)
            ? ConfirmOrClear(
                isEditing: isEditing,
                editOneAtATime: widget.editOneAtATime,
                url: widget.url,
              )
            : Container(),
        //-------------------------
        Visibility(
          visible: emptyUrl == false,
          child: LaunchLinkButton(
            url: widget.url,
            showWarning: showWarning,
          ),
        ),
        //-------------------------
        //if we are in the position to edit the field
        showPasteButton
            ? _PasteButton(
                url: widget.url,
                emptyUrl: emptyUrl,
                isEditing: isEditing,
                showWarning: showWarning,
                editingOneAtATime: widget.editOneAtATime,
              )
            : Container(),
      ],
    );

    //build
    return ClipRRect(
      borderRadius: new BorderRadius.all(
        Radius.circular(16.0),
      ), //instrinc height below
      child: IntrinsicHeight(
        child: Conditional(
          condition: widget.editOneAtATime && emptyUrl,
          ifTrue: Container(
            height: 48,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                _PasteButton(
                  url: widget.url,
                  emptyUrl: emptyUrl,
                  isEditing: isEditing,
                  showWarning: showWarning,
                  editingOneAtATime: widget.editOneAtATime,
                ),
              ],
            ),
          ),
          ifFalse: normalOne,
        ),
      ),
    );
  }
}

class EditButton extends StatelessWidget {
  const EditButton({
    Key? key,
    required this.isEditing,
  }) : super(key: key);

  final ValueNotifier<bool> isEditing;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      //padding: EdgeInsets.all(0),
      //TODO: ensure this creates the desired effect
      style: TextButton.styleFrom(
        primary: Theme.of(context).accentColor,
      ),
      onPressed: () {
        isEditing.value = true;
        FocusScope.of(context).unfocus();
      },
      child: Icon(
        Icons.edit,
        color: Theme.of(context).primaryColorDark,
      ),
    );
  }
}

class ConfirmOrClear extends StatelessWidget {
  const ConfirmOrClear({
    Key? key,
    required this.isEditing,
    required this.editOneAtATime,
    required this.url,
  }) : super(key: key);

  final ValueNotifier<bool> isEditing;
  final bool editOneAtATime;
  final ValueNotifier<String?> url;

  @override
  Widget build(BuildContext context) {
    return FieldEditButtons(
      darkButtons: true,
      onPressTop: () {
        isEditing.value = false;
      },
      topIcon: Icons.check,
      showTopButton: editOneAtATime,
      onPressBottom: () {
        url.value = "";
        isEditing.value = false;
      },
      bottomIcon: Icons.close,
    );
  }
}

class LaunchLinkButton extends StatelessWidget {
  LaunchLinkButton({
    required this.url,
    required this.showWarning,
  });

  final ValueNotifier<String?> url;
  final Function showWarning;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: TextButton(
        //padding: EdgeInsets.all(0),
        style: TextButton.styleFrom(
          primary: Theme.of(context).backgroundColor,
        ),
        onPressed: () async {
          if (url.value != null && await canLaunch(url.value!)) {
            //launch the launchable url
            await launch(url.value!);
          } else {
            showWarning("Could Not Open Link");
          }
        },
        child: Container(
          padding: EdgeInsets.all(8),
          child: Text(
            (url.value == null || url.value == "")
                ? 'Tap Paste to add the link'
                : url.value!,
            style: TextStyle(
              color: (url.value == "") ? Colors.grey : Colors.white,
            ),
            overflow: TextOverflow.clip,
          ),
        ),
      ),
    );
  }
}

class _PasteButton extends StatelessWidget {
  const _PasteButton({
    Key? key,
    required this.url,
    required this.emptyUrl,
    required this.isEditing,
    required this.showWarning,
    required this.editingOneAtATime,
  }) : super(key: key);

  final ValueNotifier<String?> url;
  final bool emptyUrl;
  final ValueNotifier<bool> isEditing;
  final Function showWarning;
  final bool editingOneAtATime;

  @override
  Widget build(BuildContext context) {
    Widget button = TextButton(
      //padding: EdgeInsets.all(0),
      style: TextButton.styleFrom(
        primary: Theme.of(context).accentColor,
      ),
      onPressed: () {
        //unfocus from others
        if (editingOneAtATime) {
          FocusScope.of(context).unfocus();
        }

        //clip board operation
        Clipboard.getData('text/plain').then((clipboardContent) {
          if (clipboardContent?.text != null) {
            //pass new url text
            url.value = clipboardContent?.text ?? "";

            //cause reload
            if (editingOneAtATime) {
              isEditing.value = true;
            }
          } else {
            //show clipboard empty
            showWarning("The Clipboard Is Empty");
          }

          //get out of edit mode
          isEditing.value = false;
        });
      },
      child: Text(
        emptyUrl == false ? "Paste" : "Tap Here To Paste A Link",
        style: TextStyle(
          color: Theme.of(context).primaryColorDark,
          fontWeight: FontWeight.bold,
        ),
      ),
    );

    //different
    if (emptyUrl) {
      return Expanded(
        child: button,
      );
    } else {
      return button;
    }
  }
}
