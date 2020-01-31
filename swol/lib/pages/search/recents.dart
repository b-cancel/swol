import 'package:flutter/material.dart';
import 'package:swol/pages/search/searchesData.dart';

class NoRecentSearches extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text("No recent searches"));
  }
}

class RecentsOrResultsHeader extends StatelessWidget {
  const RecentsOrResultsHeader({
    Key key,
    @required this.showRecentsSearches,
    @required this.resultCount,
  }) : super(key: key);

  final bool showRecentsSearches;
  final int resultCount;

  @override
  Widget build(BuildContext context) {
    return Container(
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
              (showRecentsSearches) ? "Recent searches" : "Excercises",
            ),
            (showRecentsSearches) ? Container()
            : Text(
              resultCount.toString() + " Found",
            ),
          ],
        ),
      ),
    );
  }
}

class RecentSearches extends StatelessWidget {
  RecentSearches({
    @required this.updateState,
    @required this.search,
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
    Animation<double> animation,
    {String passedTerm}
  ){
    //one of my own defaults
    Duration removeDuration = Duration(milliseconds: 300);

    //make sure we have a valid search term
    String searchTerm;
    if(passedTerm != null) searchTerm = passedTerm;
    else{
      if(SearchesData.getRecentSearches().length == 0){
        searchTerm = "";
      }
      else searchTerm = SearchesData.getRecentSearches()[index];
    }

    //build our widget given that search term
    return SizeTransition(
      sizeFactor: new Tween<double>(
        begin: 0,
        end: 1, 
      ).animate(animation), 
      child: ListTile(
        contentPadding: EdgeInsets.only(left: 16),
        dense: true,
        onTap: (){
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
            onTap: (){
              //NOTE: this should allow other deletions to complete
              //and therefore letting us confirm lock our or not
              WidgetsBinding.instance.addPostFrameCallback((_){
                if(removalLocked.value == false){
                  //lock removal
                  removalLocked.value = true;

                  //make removal
                  AnimatedList.of(context).removeItem(
                    index,
                    (context, animation){
                      return buildSearch(
                        context, 
                        index, 
                        animation,
                        passedTerm: searchTerm,
                      );
                    },
                    duration: removeDuration,
                  );

                  //remove the contact
                  SearchesData.removeFromSearchesAtIndex(index);

                  //NOTE: using a listener doesn't work for some reason
                  Future.delayed(removeDuration, (){
                    //cover edge case
                    if(SearchesData.getRecentSearches().length == 0){
                      updateState();
                    }

                    //unlock removal
                    removalLocked.value = false;
                  });
                }
              });
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        AnimatedList(
          shrinkWrap: true,
          physics: ClampingScrollPhysics(),
          reverse: true,
          initialItemCount: SearchesData.getRecentSearches().length,
          itemBuilder: (context, index, animation){
            return buildSearch(context, index, animation);
          },
        ),
        FlatButton(
          padding: EdgeInsets.all(0),
          onPressed: (){
            SearchesData.removeAllSearches();
            updateState();
          },
          child: Text(
            "Clear search history",
            style: TextStyle(
              color: Theme.of(context).accentColor,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        )
      ],
    );
  }
}