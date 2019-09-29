//flutter
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

//plugin
import 'package:url_launcher/url_launcher.dart';

//internal
import 'package:swol/sharedWidgets/buttonSpacer.dart';

class ReferenceLinkBox extends StatefulWidget {
  const ReferenceLinkBox({
    Key key,
    @required this.editOneAtAtTime,
    @required this.url,
  }) : super(key: key);

  //params
  final bool editOneAtAtTime;
  final ValueNotifier<String> url;

  @override
  _ReferenceLinkBoxState createState() => _ReferenceLinkBoxState();
}

class _ReferenceLinkBoxState extends State<ReferenceLinkBox> {
  ValueNotifier<bool> isEditing = new ValueNotifier(false);

  @override
  void initState() { 
    super.initState();
    
    //reload on certain ocassion
    isEditing.addListener((){
      setState(() {});
    });
  }

  //NOTE: clearing or pasting a link finalizes an edit
  @override
  Widget build(BuildContext context) {
    Widget editButton = FlatButton(
      color: Theme.of(context).accentColor,
      padding: EdgeInsets.all(0),
      onPressed: (){
        isEditing.value = true;
      },
      child: Icon(
        Icons.edit,
        color: Theme.of(context).primaryColorDark,
      ),
    );

    Widget pasteButton = FlatButton(
      color: Theme.of(context).accentColor,
      padding: EdgeInsets.all(0),
      onPressed: (){
        Clipboard.getData('text/plain').then((clipboardContent) {
          if(clipboardContent?.text != null){
            widget.url.value = clipboardContent.text;
          }
          else{
            final snackBar = SnackBar(
              content: Text("Nothing In Clipboard"),
            );

            // Find the Scaffold in the widget tree and use it to show a SnackBar.
            Scaffold.of(context).showSnackBar(snackBar);
          }

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

    Widget confirmAndClearButton;
    if(widget.url.value == ""){
      confirmAndClearButton = Container();
    }
    else{
      Widget clearButton = Expanded(
        child: FlatButton(
          padding: EdgeInsets.all(0),
          color: Theme.of(context).scaffoldBackgroundColor,
          onPressed: (){
            widget.url.value = "";
            isEditing.value = false;
          },
          child: Container(
            padding: EdgeInsets.all(0),
            child: (widget.url.value == "") 
            ? Container()
            : Icon(Icons.close),
          )
        ),
      );

      bool twoButtons = (widget.editOneAtAtTime);

      //If we are doing the edit one at a time thing we also want to provide an aprove change button
      Widget confirmButton = (twoButtons == false) ? Container()
      : Expanded(
        child: FlatButton(
          padding: EdgeInsets.all(0),
          color: Theme.of(context).scaffoldBackgroundColor,
          onPressed: (){
            isEditing.value = false;
          },
          child: Container(
            padding: EdgeInsets.all(0),
            child: (widget.url.value == "") 
            ? Container()
            : Icon(Icons.check),
          )
        ),
      );

      confirmAndClearButton = IntrinsicWidth(
        child: Container(
          color: Theme.of(context).scaffoldBackgroundColor,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              confirmButton,
              (twoButtons == false) ? Container() 
              : ButtonSpacer(),
              clearButton,
            ],
          ),
        ),
      );
    }

    //NOTE: only show the edit buttons sometimes
    bool showEditButtons;
    if(widget.editOneAtAtTime == false) showEditButtons = true;
    else{
      if(isEditing.value) showEditButtons = true;
      else showEditButtons = false;
    }

    return ClipRRect(
      borderRadius: new BorderRadius.all(
        Radius.circular(16.0),
      ), //instrinc height below
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            (widget.editOneAtAtTime && isEditing.value == false) ? editButton : Container(),
            (showEditButtons) ? confirmAndClearButton : Container(),
            Expanded(
              child: FlatButton(
                color: Theme.of(context).backgroundColor,
                padding: EdgeInsets.all(0),
                onPressed: ()async{
                  if (await canLaunch(widget.url.value)) {
                    await launch(widget.url.value);
                  } else {
                    final snackBar = SnackBar(
                      content: Text("Could Not Launch URL"),
                    );

                    // Find the Scaffold in the widget tree and use it to show a SnackBar.
                    Scaffold.of(context).showSnackBar(snackBar);
                  }
                },
                child: Container(
                  padding: EdgeInsets.all(8),
                  child: Text(
                    (widget.url.value == "") ? 'Tap Paste to add the link' : widget.url.value,
                    style: TextStyle(
                      color: (widget.url.value == "") ? Colors.grey : Colors.white,
                    ),
                    overflow: TextOverflow.clip,
                  ),
                ),
              ),
            ),
            (showEditButtons) ? pasteButton : Container(),
          ],
        ),
      ),
    );
  }
}