//flutter
import 'package:flutter/material.dart';

//internal
import 'package:swol/shared/widgets/simple/listItem.dart';
import 'package:swol/learn/description.dart';

//widget
class ResearchBody extends StatelessWidget {
  const ResearchBody({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SectionDescription(
          children: [
            TextSpan(
              text: "Here are some topics that you can look into, to help you ",
            ),
            TextSpan(
              text: "get even more out of your workouts",
              style: TextStyle(
                fontWeight: FontWeight.w900,
              )
            ),
          ],
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
                      style: TextStyle(
                        fontSize: 16,
                      ),
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
                      style: TextStyle(
                        fontSize: 16,
                      ),
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
                      style: TextStyle(
                        fontSize: 16,
                      ),
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
                  Text(
                    "Anaerobic System",
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    "Glycolytic System",
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    "Aerobic System",
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ],
                lessBottomPadding: true,
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
    this.lessBottomPadding: false,
  }) : super(key: key);

  final String title;
  final List<Widget> items;
  final bool lessBottomPadding;

  @override
  Widget build(BuildContext context) {
    List<Widget> listItems = new List<Widget>();
    for(int i = 0; i < items.length; i++){
      listItems.add(
        ListItem(
          circleColor: Theme.of(context).accentColor,
          circleText: (i + 1).toString(),
          content: items[i],
        ),
      );
    }

    return Padding(
      padding: EdgeInsets.only(
        bottom: lessBottomPadding ? 8 : 16.0,
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
                      fontSize: 16,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
                Container(
                  color: Theme.of(context).scaffoldBackgroundColor,
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