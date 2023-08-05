class Word {
  String text;
  List<bool> lettersRevealed;

  // Constructor
  Word(this.text) : lettersRevealed = List.filled(text.length, false);
  
  // Check if the word is fully revealed
  bool isFullyRevealed() {
    return !lettersRevealed.contains(false);
  }
}
