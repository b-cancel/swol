//regular
import 'dart:convert';
import 'dart:io';

import 'package:swol/functions/helper.dart';
import 'package:swol/utils/safeSave.dart';

//local connection

//-------------------------MAIN VARS-------------------------

File _searchesFile;
List<String> searches;

//-------------------------USED EVERYWHERE-------------------------

List<String> getRecentSearches(){
  return searches;
}

//-------------------------USED ONLY ON INIT-------------------------

searchesInit() async{
  if(_searchesFile == null){
    //get what the file reference should be
    _searchesFile = await nameToFileReference("searches");

    //get access to the file
    bool exists = await _searchesFile.exists();

    //read in file data
    String fileData;
    if(exists == false){
      await _searchesFile.create();
      //NOTE: don't use safeSave here because 
      //1. we need this to complete before continuing
      //2. we know this file hasn't been written to before 
      //  - since this is its init function
      await _searchesFile.writeAsString("[]");
    }

    //read in our data
    fileData = await _searchesFile.readAsString();

    //grab the contacts
    searches = (json.decode(fileData) as List<dynamic>).cast<String>();
  }
}

//-------------------------USED TO UPDATE FILE AFTER EVERY CHANGE-------------------------

//should never have to update from anywhere else
_updateSearchesFile()async{
  //save all this in the file
  String newFileData = json.encode(searches);

  //write the data
  safeSave(_searchesFile, newFileData);
}

//-------------------------ADD-------------------------

addToSearches(String newSearch){
  //check if this search is already present
  int matchingIndex = searches.indexOf(newSearch);

  //first time search
  if(matchingIndex == -1){
    searches.add(newSearch);
  }
  else{ //not first time search
    //if this contact is NOT at the end
    //then it might need to be removed and readded at the end
    if(matchingIndex != (searches.length - 1)){
      removeFromSearchesAtIndex(matchingIndex);
      searches.add(newSearch);
    }
  }

  //update save file
  _updateSearchesFile();
}

//-------------------------REMOVE-------------------------

removeFromSearchesAtIndex(int index){
  searches.removeAt(index);
  _updateSearchesFile();
}

removeAllSearches(){
  searches.clear();
  safeSave(_searchesFile, "[]");
}