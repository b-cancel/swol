bool isTextValid(String text){
  if(text.length == 0) return false;
  else{
    if(text[0] == "0") return false;
    else return true;
  }
}