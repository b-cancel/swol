/*
//actual card data
    Widget actualCard = Container(
      padding: EdgeInsets.symmetric(
        horizontal: 24,
        vertical: 16,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.only(
          topRight: cardRadius,
          bottomRight: cardRadius,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "Record Set",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 48,
            ),
          ),
          OutlineTextField(
            weight: weight,
          ),
          OutlineTextField(
            weight: reps,
            isWeight: false,
          ),
        ],
      ),
    );
*/



/*
    //build
    return Container(
      height: spaceToRedistribute,
      width: MediaQuery.of(context).size.width,
      //child: actualCard,
      
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Container(
            color: Theme.of(context).cardColor,
            height: heightBigSmall[1] - 8,
            width: MediaQuery.of(context).size.width,
          ),
          Container(
            height: 16,
            //color: Colors.red,
            width: MediaQuery.of(context).size.width,
            alignment: Alignment.center,
            child: OverflowBox(
              alignment: Alignment.center,
              //NOTE: we are working from the center of our space
              //the largest box we can have at that point without overflowing from up top
              //is going to be double the size of the smaller portion
              //this works but then whatever we fit into it we also need to account for atleast a 16 pixel padding on top and bottom
              maxHeight: heightBigSmall[1] * 2,
              minHeight: 0,
              child: Container(
                height: heightBigSmall[1] * 2,
                child: Padding(
                  padding: EdgeInsets.only(
                    top: 16,
                  ),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxHeight: heightBigSmall[1] * 2 - 16,
                      ),
                      child: actualCard,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Container(
            height: heightBigSmall[0] - 8,
            width: MediaQuery.of(context).size.width,
          ),
        ],
      ),
      
    );
    */

/*
class OutlineTextField extends StatelessWidget {
  const OutlineTextField({
    Key key,
    @required this.weight,
    this.isWeight: true,
  }) : super(key: key);

  final int weight;
  final bool isWeight;

  @override
  Widget build(BuildContext context) {
    double fontSize = 72;
    double difference = 24;
    double difference2 = 16;

    return Container(
      padding: EdgeInsets.only(
        top: 8,
      ),
      child: IntrinsicHeight(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              decoration: new BoxDecoration(
                border: new Border.all(
                  color: Theme.of(context).primaryColorDark, 
                  width: 4.0,
                ),
                borderRadius: new BorderRadius.circular(6.0),
              ),
              padding: EdgeInsets.all(4),
              child: Text(
                isWeight ? "9____" : "8___",
                style: TextStyle(
                  fontSize: fontSize + (isWeight ? difference2 : 0),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(
                left: 8
              ),
              //color: Colors.red,
              child: isWeight 
              ? Container(
                alignment: Alignment.bottomLeft,
                padding: EdgeInsets.only(
                  bottom: 8,
                  right: 16,
                ),
                child: Icon(
                  FontAwesomeIcons.dumbbell,
                  size: fontSize - difference,
                ),
              )
              : DefaultTextStyle(
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
                child: DefaultTextStyle(
                  style: TextStyle(
                    fontSize: fontSize - difference * 2,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text("successfully"),
                      Text("completed"),
                      Text("lifts"),
                    ],
                  ),
                ),
              )
            ),
          ],
        ),
      ),
    );
  }
}
*/