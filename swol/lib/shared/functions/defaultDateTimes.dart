//NOTE: I am fully aware this runs kind of slow
//but it simplifies the code enough to be worth it

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
enum TimeStampType {InProgress, New, Other, Hidden}

class LastTimeStamp{
  static String timeStampTypeToString(TimeStampType timeStampType){
    if(timeStampType == TimeStampType.InProgress) return "In Progress";
    else return timeStampType.toString().substring("TimeStampType.".length);
  }

  static int daysInYear = 365;
  static int lifeSpan = 125;
  static Duration inProgressLifeSpans = lifeSpans(counts: 3);
  static Duration newLifeSpans = lifeSpans(counts: 2);
  static Duration humanLifeSpan = lifeSpans(counts: 1);
  static Duration archivedLifeSpans = lifeSpans(counts: 1);

  static Duration lifeSpans({int counts: 1}){
    return Duration(days: daysInYear * (lifeSpan * counts));
  }

  static TimeStampType returnTimeStampType(DateTime lastTimeStamp){
    if(isHidden(lastTimeStamp)) return TimeStampType.Hidden;
    else{
      if(isInProgress(lastTimeStamp)) return TimeStampType.InProgress;
      else{
        if(isNew(lastTimeStamp)) return TimeStampType.New;
        else return TimeStampType.Other;
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

  static bool isHidden(DateTime lastTimeStamp){
    print("checking if hidden: " + lastTimeStamp.toString());
    if((lastTimeStamp).isBefore(DateTime.now())){
      print("is after so may be hidden but check");
      Duration timeSince = (DateTime.now()).difference(lastTimeStamp);
      print("time since is: " + timeSince.toString());
      return (archivedLifeSpans <= timeSince); 
    }
    else return false;
  }

  //timeSince will ONLY GROW
  //so IF timeSince >= 1 lifespan => archived
  static DateTime hiddenDateTime(){
    return DateTime.now().subtract(
      archivedLifeSpans,
    );
  }
}