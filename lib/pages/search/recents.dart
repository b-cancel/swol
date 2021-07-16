//flutter
import 'package:flutter/material.dart';
import 'package:swol/action/page.dart';

//internal
import 'package:swol/pages/selection/widgets/workoutSection.dart';
import 'package:swol/pages/search/searchesData.dart';
import 'package:swol/shared/widgets/simple/curvedCorner.dart';

class RecentsOrResultsHeader extends StatelessWidget {
  const RecentsOrResultsHeader({
    Key? key,
    required this.showRecentsSearches,
    required this.resultCount,
  }) : super(key: key);

  final bool showRecentsSearches;
  final int resultCount;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          color: Theme.of(context).primaryColorDark,
          padding: EdgeInsets.fromLTRB(16, 32, 16, 8),
          child: DefaultTextStyle(
            style: TextStyle(
              color: Colors.white,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  (showRecentsSearches) ? "Recent searches" : "Exercises",
                ),
                (showRecentsSearches)
                    ? Container()
                    : Text(
                        resultCount.toString() + " Found",
                      ),
              ],
            ),
          ),
        ),
        Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              width: MediaQuery.of(context).size.width,
              child: Transform.translate(
                offset: Offset(0, 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    CurvedCorner(
                      isTop: true,
                      isLeft: true,
                      cornerColor: Theme.of(context).primaryColorDark,
                    ),
                    CurvedCorner(
                      isTop: true,
                      isLeft: false,
                      cornerColor: Theme.of(context).primaryColorDark,
                    ),
                  ],
                ),
              ),
            )),
      ],
    );
  }
}

class RecentSearches extends StatelessWidget {
  RecentSearches({
    required this.updateState,
    required this.search,
  });

  final Function updateState;
  final TextEditingController search;

  //If true clicking the X does nothing on that particular item
  //this is required so weird stuff doesn't happen while a removal is processing
  final ValueNotifier<bool> removalLocked = new ValueNotifier<bool>(false);

  //once search item built
  buildSearch(
    BuildContext context,
    int index,
    Animation<double> animation, {
    String? passedTerm,
  }) {
    //make sure we have a valid search term
    String searchTerm;
    if (passedTerm != null)
      searchTerm = passedTerm;
    else {
      if (SearchesData.getRecentSearches().length == 0) {
        searchTerm = "";
      } else
        searchTerm = SearchesData.getRecentSearches()[index];
    }

    //build our widget given that search term
    return SizeTransition(
      sizeFactor: new Tween<double>(
        begin: 0,
        end: 1,
      ).animate(animation),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Card(
            margin: EdgeInsets.all(0),
            child: ListTile(
              contentPadding: EdgeInsets.only(left: 16),
              dense: true,
              onTap: () {
                search.text = searchTerm;
                SearchesData.addToSearches(searchTerm);
              },
              title: Text(
                searchTerm,
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
              trailing: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    //NOTE: this should allow other deletions to complete
                    //and therefore letting us confirm lock our or not
                    WidgetsBinding.instance?.addPostFrameCallback(
                      (_) {
                        if (removalLocked.value == false) {
                          //lock removal
                          removalLocked.value = true;

                          //make removal
                          AnimatedList.of(context).removeItem(
                            index,
                            (context, animation) {
                              return buildSearch(
                                context,
                                index,
                                animation,
                                passedTerm: searchTerm,
                              );
                            },
                            duration: ExercisePage.transitionDuration,
                          );

                          //remove the contact
                          SearchesData.removeFromSearchesAtIndex(index);

                          //NOTE: using a listener doesn't work for some reason
                          Future.delayed(ExercisePage.transitionDuration, () {
                            //cover edge case
                            if (SearchesData.getRecentSearches().length == 0) {
                              updateState();
                            }

                            //unlock removal
                            removalLocked.value = false;
                          });
                        }
                      },
                    );
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    child: Icon(Icons.close),
                  ),
                ),
              ),
            ),
          ),
          //NOTE: the last divider separate the tile from the clear all button
          ListTileDivider(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Radius cardRadius = Radius.circular(24);
    return Column(
      children: <Widget>[
        ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: cardRadius,
            topRight: cardRadius,
          ),
          child: Container(
            color: Theme.of(context).cardColor,
            child: AnimatedList(
              shrinkWrap: true,
              physics: ClampingScrollPhysics(),
              reverse: true,
              initialItemCount: SearchesData.getRecentSearches().length,
              itemBuilder: (context, index, animation) {
                return buildSearch(context, index, animation);
              },
            ),
          ),
        ),
        ClipRRect(
          borderRadius: BorderRadius.only(
            bottomLeft: cardRadius,
            bottomRight: cardRadius,
          ),
          child: Container(
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
            ),
            child: TextButton(
              //materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              //padding: EdgeInsets.all(0),
              onPressed: () {
                SearchesData.removeAllSearches();
                updateState();
              },
              child: Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 6,
                ),
                child: Text(
                  "Clear Search History",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
