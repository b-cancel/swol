import 'package:flutter/material.dart';

class DoneButton extends StatelessWidget {
  const DoneButton({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OutlineButton(
      highlightedBorderColor: Theme.of(context).accentColor,
      onPressed: (){
        print("do thing");
      },
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: "3 Sets",
              style: TextStyle(
                fontWeight: FontWeight.w900,
              ),
            ),
            TextSpan(
              text: " Complete",
              style: TextStyle(
              ),
            ),
          ],
        ),
      ),
    );
  }
}