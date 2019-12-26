//flutter
import 'package:flutter/material.dart';

//internal
import 'package:swol/other/functions/helper.dart';

//plugin
import 'package:direct_select_flutter/direct_select_item.dart';
import 'package:direct_select_flutter/direct_select_list.dart';

//dropdown
//TODO: add explanation of how this works if the user does what is expected and taps
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
            return Text(value);
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

    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
      child: Card(
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
                color: Colors.black38,
              ),
            )
          ],
        ),
      ),
    );
  }
}

class FunctionDropDown extends StatefulWidget {
  FunctionDropDown({
    @required this.functionString,
    @required this.functionIndex,
  });

  final ValueNotifier<String> functionString;
  final ValueNotifier<int> functionIndex;

  @override
  _FunctionDropDownState createState() => _FunctionDropDownState();
}

class _FunctionDropDownState extends State<FunctionDropDown> {
  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: widget.functionString.value,
      icon: Icon(Icons.arrow_drop_down),
      isExpanded: true,
      iconSize: 24,
      elevation: 16,
      onChanged: (String newValue) {
        setState(() {
          widget.functionString.value = newValue;
          widget.functionIndex.value = Functions.functionToIndex[widget.functionString.value];
        });
      },
      items: Functions.functions.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      })
      .toList(),
    );
  }
}