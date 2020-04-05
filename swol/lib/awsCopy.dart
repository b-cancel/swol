/*
showDialog(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return Theme(
        data: MyTheme.light,
        child: AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(12.0)),
            ),
            contentPadding: EdgeInsets.all(0),
            content: Stack(
              overflow: Overflow.visible,
              children: <Widget>[
                Container(
                  height: 250,
                  color: Colors.blue,
                  width: MediaQuery.of(context).size.width,
                ),
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Transform.translate(
                      offset: Offset(0, -28),
                      child: Container(
                        width: 56,
                        height: 56,
                        color: Colors.red.withOpacity(0.5),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            ),
      );
    },
  );
*/