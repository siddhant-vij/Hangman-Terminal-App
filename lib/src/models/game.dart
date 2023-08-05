import 'player.dart';
import 'word.dart';

class Game {
  Player player;
  Word word;
  int incorrectGuesses;
  List<String> guessedLetters;
  int totalGuesses = 0;
  String difficulty;
  bool hintUsed;

  // Constructor
  Game(this.player, this.word, this.difficulty)
      : incorrectGuesses = 0,
        guessedLetters = [],
        hintUsed = false;

  // Check if the game is over
  bool isGameOver() {
    return word.isFullyRevealed() || incorrectGuesses >= word.text.length;
  }

  // Check if the player has won
  bool hasPlayerWon() {
    return word.isFullyRevealed();
  }
}
