bool isTextValid(String text){
  if(text == "") return false;
  else{
    if(text.length > 0 && text[0] == "0") return false;
    else return true;
  }
}