//dropdown
//TODO: holding it long enough to bring up the screen butnot long enough to select
//TODO: fix that the above breaks everything
import 'package:bot_toast/bot_toast.dart';
import 'package:direct_select_flutter/direct_select_item.dart';
import 'package:direct_select_flutter/direct_select_list.dart';
import 'package:flutter/material.dart';
import 'package:swol/other/functions/helper.dart';

class EasyFunctionDropDown extends StatefulWidget {
  EasyFunctionDropDown({
    @required this.functionString,
    @required this.functionIndex,
  });

  final ValueNotifier<String> functionString;
  final ValueNotifier<int> functionIndex;

  @override
  _EasyFunctionDropDownState createState() => _EasyFunctionDropDownState();
}

class _EasyFunctionDropDownState extends State<EasyFunctionDropDown> {
  @override
  Widget build(BuildContext context) {
    Widget directSelectList = DirectSelectList<String>(
      values: Functions.functions,
      defaultItemIndex: widget.functionIndex.value,
      itemBuilder: (String value){
        return DirectSelectItem<String>(
          itemHeight: 56,
          value: value,
          itemBuilder: (context, value) {
            return GestureDetector(
              onTap: (){
                setState(() {
                  widget.functionString.value = value;
                  widget.functionIndex.value = Functions.functionToIndex[value];
                });
              },
              child: Text(value),
            );
          },
        );
      },
      focusedItemDecoration: BoxDecoration(
        border: BorderDirectional(
          bottom: BorderSide(width: 1, color: Colors.black12),
          top: BorderSide(width: 1, color: Colors.black12),
        ),
      ),
      onItemSelectedListener: (item, index, context) {
        setState(() {
          widget.functionString.value = item;
          widget.functionIndex.value = index;
        });
      },
    );

    return Stack(
      children: <Widget>[
        Card(
          color: Theme.of(context).primaryColor,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(left: 12),
                  child: directSelectList,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(right: 8),
                child: Icon(
                  Icons.unfold_more,
                  color: Colors.white,
                ),
              )
            ],
          ),
        ),
        Positioned.fill(
          child: FittedBox(
            fit: BoxFit.fill,
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: (){
                BotToast.showAttachedWidget(
                  targetContext: context,
                  preferDirection: PreferDirection.topCenter,
                  attachedBuilder: (_) => Card(
                    color: Theme.of(context).primaryColor,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("Hold, Drag, and Let Go To Select")
                    ),
                  ),
                  duration: Duration(seconds: 2),
                  onlyOne: true,
                );

                /*
                BotToast.showText(
                  text:"Hold, Drag, and Let Go\nTo Select",
                  clickClose: true,
                  crossPage: false,
                  onlyOne: true,
                );
                */
              },
              child: FittedBox(
                fit: BoxFit.fill,
                child: Container(
                  height: 1,
                  width: 1,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}