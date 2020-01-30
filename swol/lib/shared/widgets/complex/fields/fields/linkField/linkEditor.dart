//flutter
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

//plugin
import 'package:url_launcher/url_launcher.dart';

//internal
import 'package:swol/shared/widgets/simple/ourSnackBar.dart';
import 'package:swol/pages/notes/fieldEditButtons.dart';

//widgets
class LinkEditor extends StatefulWidget {
  const LinkEditor({
    Key key,
    @required this.editOneAtATime,
    @required this.url,
  }) : super(key: key);

  //params
  final bool editOneAtATime;
  final ValueNotifier<String> url;

  @override
  _LinkEditorState createState() => _LinkEditorState();
}

class _LinkEditorState extends State<LinkEditor> {
  ValueNotifier<bool> isEditing = new ValueNotifier(false);

  updateState(){
    if(mounted) setState(() {});
  }

  @override
  void initState() { 
    super.initState();
    isEditing.addListener(updateState);
  }

  @override
  void dispose() { 
    isEditing.removeListener(updateState);
    super.dispose();
  }

  showWarning(String message){
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
    if(widget.editOneAtATime == false) showEditButtons = true;
    else{
      if(isEditing.value) showEditButtons = true;
      else showEditButtons = false;
    }

    bool showClearAndConfirmButtons = (showEditButtons && widget.url.value != "");
    bool showPasteButton = showEditButtons;

    //build
    return ClipRRect(
      borderRadius: new BorderRadius.all(
        Radius.circular(16.0),
      ), //instrinc height below
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            //IF we can only edit one at a time AND we are not editing
            showToEditButton ? EditButton(isEditing: isEditing) : Container(),
            //TODO: add condition description to confirm this never overlaps the above
            (showClearAndConfirmButtons) ? ConfirmOrClear(
              isEditing: isEditing,
              editOneAtATime: widget.editOneAtATime,
              url: widget.url,
            ): Container(),
            //-------------------------
            LaunchLinkButton(
              url: widget.url,
              showWarning: showWarning,
            ),
            //-------------------------
            //if we are in the position to edit the field
            (showPasteButton) ? PasteButton(
              url: widget.url, 
              isEditing: isEditing,
              showWarning: showWarning,
            ) : Container(),
          ],
        ),
      ),
    );
  }
}

class EditButton extends StatelessWidget {
  const EditButton({
    Key key,
    @required this.isEditing,
  }) : super(key: key);

  final ValueNotifier<bool> isEditing;

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      color: Theme.of(context).accentColor,
      padding: EdgeInsets.all(0),
      onPressed: (){
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
    Key key,
    @required this.isEditing,
    @required this.editOneAtATime,
    @required this.url,
  }) : super(key: key);

  final ValueNotifier<bool> isEditing;
  final bool editOneAtATime;
  final ValueNotifier<String> url;

  @override
  Widget build(BuildContext context) {
    return FieldEditButtons(
      darkButtons: true,
      onPressTop: (){
        isEditing.value = false;
      },
      topIcon: Icons.check,
      showTopButton: editOneAtATime,
      onPressBottom: (){
        url.value = "";
        isEditing.value = false;
      },
      bottomIcon: Icons.close,
    );
  }
}

class LaunchLinkButton extends StatelessWidget {
  LaunchLinkButton({
    @required this.url,
    @required this.showWarning,
  });

  final ValueNotifier<String> url;
  final Function showWarning;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: FlatButton(
        color: Theme.of(context).backgroundColor,
        padding: EdgeInsets.all(0),
        onPressed: ()async{
          if (await canLaunch(url.value)) {
            //launch the launchable url
            await launch(url.value);
          } else showWarning("Could Not Launch URL");
        },
        child: Container(
          padding: EdgeInsets.all(8),
          child: Text(
            (url.value == "") ? 'Tap Paste to add the link' : url.value,
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

class PasteButton extends StatelessWidget {
  const PasteButton({
    Key key,
    @required this.url,
    @required this.isEditing,
    @required this.showWarning,
  }) : super(key: key);

  final ValueNotifier<String> url;
  final ValueNotifier<bool> isEditing;
  final Function showWarning;

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      color: Theme.of(context).accentColor,
      padding: EdgeInsets.all(0),
      onPressed: (){
        Clipboard.getData('text/plain').then((clipboardContent) {
          if(clipboardContent?.text != null){
            //pass new url text
            url.value = clipboardContent.text;
          }
          else{
            //show clipboard empty
            showWarning("The Clipboard Is Empty");
          }

          //get out of edit mode
          isEditing.value = false;
        });
      },
      child: Text(
        "Paste",
        style: TextStyle(
          color: Theme.of(context).primaryColorDark,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}