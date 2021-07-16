import 'package:flutter/material.dart';
import 'package:swol/shared/widgets/simple/chip.dart';

//widget
class FunctionCardTable extends StatelessWidget {
  FunctionCardTable({
    this.cardBackground: false,
  });

  final bool cardBackground;

  List<Widget> buildFields(BuildContext context, List<String> items) {
    List<Widget> buildFields = [];
    for (int i = 0; i < items.length; i++) {
      buildFields.add(
        MyCustomChip(
          chipString: items[i],
          chipColor: Theme.of(context).accentColor,
          textColor: Colors.white,
          extraPadding: EdgeInsets.symmetric(
            horizontal: 8,
            vertical: 4,
          ),
        ),
      );
    }

    return buildFields;
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(25),
      child: Container(
        color: Theme.of(context).cardColor,
        width: MediaQuery.of(context).size.width,
        child: IntrinsicWidth(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                color: Theme.of(context).primaryColor,
                padding: EdgeInsets.symmetric(
                  vertical: 8.0,
                  horizontal: 16,
                ),
                child: Text(
                  "One Rep Max Formulas",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.all(8),
                color: cardBackground
                    ? Theme.of(context).scaffoldBackgroundColor
                    : Theme.of(context).cardColor,
                child: Padding(
                  padding: EdgeInsets.only(
                    bottom: 8.0,
                  ),
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 6,
                    children: buildFields(
                      context,
                      [
                        "Brzycki",
                        "McGlothin (or Landers)",
                        "Almazan (Our Own)",
                        "Epley (or Baechle)",
                        "O`Conner",
                        "Wathan",
                        "Mayhew",
                        "Lombardi",
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
