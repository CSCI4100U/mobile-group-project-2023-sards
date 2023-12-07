String firstFewWords(String bigSentence){

  int startIndex = 0;
  late int indexOfSpace;

  for(int i = 0; i < 3; i++){
    indexOfSpace = bigSentence.indexOf(' ', startIndex);
    if(indexOfSpace == -1){     //-1 is when character is not found
      return bigSentence;
    }
    startIndex = indexOfSpace + 1;
  }

  return bigSentence.substring(0, indexOfSpace);
}