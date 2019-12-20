import 'package:flutter/material.dart';
import 'package:swol/learn/shared.dart';

class ResearchBody extends StatelessWidget {
  const ResearchBody({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SectionDescription(
          child: Text(
            "Here are some topics that you can look into, to help you get even more out of your workouts",
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16.0,
          ),
          child: Column(
            children: <Widget>[
              ResearchCard(
                title: "How do you focus at each stage of movement to get the most out of each exercise?", 
                items: [
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "Concentric Stage (positive reps): ",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text: "where your muscle contracts and shortens",
                        ),
                      ]
                    ),
                  ),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "Isometric Stage (holds): ",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text: " where your muscle contracts, and neither shortens or lengthens",
                        ),
                      ]
                    ),
                  ),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "Eccentric Stage (negative reps): ",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text: "where your muscle contracts and lengthens",
                        ),
                      ]
                    ),
                  ),
                ],
              ),
              ResearchCard(
                title: "How does each energy system work? How can you use your knowledge of each to improve your workouts?", 
                items: [
                  Text("Anaerobic System"),
                  Text("Glycolytic System"),
                  Text("Aerobic System"),
                ],
              ),
            ],
          ),
        )
      ],
    );
  }
}

class ResearchCard extends StatelessWidget {
  const ResearchCard({
    Key key,
    @required this.title,
    @required this.items,
  }) : super(key: key);

  final String title;
  final List<Widget> items;

  @override
  Widget build(BuildContext context) {
    List<Widget> listItems = new List<Widget>();
    for(int i = 0; i < items.length; i++){
      listItems.add(
        ListItem(
          circleColor: Theme.of(context).accentColor,
          circleText: (i + 1).toString(),
          circleTextSize: 18,
          content: items[i],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(
        bottom: 16.0,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(25),
        child: Container(
          child: Container(
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: <Widget>[
                Container(
                  color: Theme.of(context).accentColor,
                  padding: EdgeInsets.all(16),
                  child: Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
                Container(
                  color: Theme.of(context).cardColor,
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.symmetric(
                    horizontal: 16,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(
                      top: 16.0,
                    ),
                    child: Column(
                      children: listItems,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}