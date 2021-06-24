import 'package:flutter/material.dart';

class ClearButton extends StatelessWidget {
  const ClearButton({
    Key key,
    @required this.ctrl,
  }) : super(key: key);

  final TextEditingController ctrl;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 0,
      top: 0,
      bottom: 0,
      child: Transform.translate(
        offset: Offset(8, 0),
        child: IconButton(
          onPressed: (){
            ctrl.text = "";
          },
          color: Colors.grey, 
          highlightColor: Colors.grey,
          icon: Icon(
            Icons.close,
            color: Colors.grey,
          ),
        ),
      ),
    );
  }
}