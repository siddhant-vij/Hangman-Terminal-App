class Statistics {
  int gamesPlayed;
  int gamesWon;
  double totalGuesses;
  int totalTime;

  // Constructor
  Statistics({
    this.gamesPlayed = 0,
    this.gamesWon = 0,
    this.totalGuesses = 0.0,
    this.totalTime = 0,
  });

  // Method to update statistics after a game
  void updateStats(bool gameWon, int guesses, int timeTaken) {
    gamesPlayed++;
    if (gameWon) {
      gamesWon++;
    }
    totalGuesses += guesses;
    totalTime += timeTaken;
  }

  // Method to get the average guesses per game
  double getAverageGuesses() {
    if (gamesPlayed > 0) {
      return totalGuesses / gamesPlayed;
    } else {
      return 0.0;
    }
  }

  // Method to reset the statistics
  void resetStats() {
    gamesPlayed = 0;
    gamesWon = 0;
    totalGuesses = 0.0;
    totalTime = 0;
  }
}


class PlayerStatistics {
  final String playerName;
  final int gamesPlayed;
  final int gamesWon;
  final double totalGuesses;
  final int totalTime;

  PlayerStatistics({
    required this.playerName,
    required this.gamesPlayed,
    required this.gamesWon,
    required this.totalGuesses,
    required this.totalTime,
  });
}
