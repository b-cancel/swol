/*
Our Excercises should be sorted as such
1. in progress
2. new
3. other
4. archived
EPOCH

we could go about using more complicated conditionals
or we could just use "lastTimeStamp"
to sort all of this and take care of all of this

If we sort given time since epoch we will get things in order
4,3,2,1

timeSince = DateTime.now().difference(recordedDateTime);
If timeSince > (1 lifeSpan) => "Archived"
Else
  IF DateTime.now() > recordedDateTime => "Other"
  Else
    IF recordedDateTime.difference(DateTime.now()) > (2 lifespans) => "In Progress"
    Else => "New"

Now that we have the functions for best results we call returnSectionID
that essentially does the above with more checks
*/

class LastTimeStamp{
  static int daysInYear = 365;
  static int lifeSpan = 125;
  static Duration inProgressLifeSpans = lifeSpans(counts: 3);
  static Duration newLifeSpans = lifeSpans(counts: 2);
  static Duration humanLifeSpan = lifeSpans(counts: 1);
  static Duration archivedLifeSpans = lifeSpans(counts: 1);

  static Duration lifeSpans({int counts: 1}){
    return Duration(days: daysInYear * (lifeSpan * counts));
  }

  static int returnSectionID(DateTime lastTimeStamp){
    if(isArchived(lastTimeStamp)) return 4;
    else{
      if(isInProgress(lastTimeStamp)) return 1;
      else{
        if(isNew(lastTimeStamp)) return 2;
        else return 3;
      }
    }
  }

  //-------------------------In Progress-------------------------

  static bool isInProgress(DateTime lastTimeStamp){
    if(DateTime.now().isBefore(lastTimeStamp)){
      Duration timeSince = lastTimeStamp.difference(DateTime.now());
      return (newLifeSpans <= timeSince && timeSince <= inProgressLifeSpans);
    }
    else return false;
  }

  //timeSince will ONLY SHRINK
  //at most 3 life spans (but only for a microsecond)
  //at least 2 life spans
  static DateTime inProgressDateTime(){
    return DateTime.now().add(
      inProgressLifeSpans,
    );
  }

  //-------------------------New-------------------------

  static bool isNew(DateTime lastTimeStamp){
    if(DateTime.now().isBefore(lastTimeStamp)){
      Duration timeSince = lastTimeStamp.difference(DateTime.now());
      //MUST BE (< newLifeSpans) AND NOT (<= newLifeSpans) since the == should be picked up by isInProgress
      return (humanLifeSpan <= timeSince && timeSince < newLifeSpans);
    }
    else return false;
  }

  //timeSince will ONLY SHRINK
  //at most 2 life spans (but only for a microsecond)
  //at least 1 life span
  static DateTime newDateTime(){
    return DateTime.now().add(
      newLifeSpans,
    );
  }

  //-------------------------Archiving-------------------------

  static bool isArchived(DateTime lastTimeStamp){
    if(DateTime.now().isAfter(lastTimeStamp)){
      //TODO check below
      Duration timeSince = DateTime.now().difference(lastTimeStamp);
      return (archivedLifeSpans <= timeSince); 
    }
    else return false;
  }

  //timeSince will ONLY GROW
  //so IF timeSince >= 1 lifespan => archived
  static DateTime archivedDateTime(){
    return DateTime.now().subtract(
      archivedLifeSpans,
    );
  }
}