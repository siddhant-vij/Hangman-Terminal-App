import 'dart:io';
import 'package:hangman_terminal_app/src/models/statistics.dart';

class StatisticsService {
  final String filePath;

  StatisticsService(this.filePath);

  // Method to ensure the CSV file exists
  void _ensureFileExists() {
    final file = File(filePath);
    if (!file.existsSync()) {
      file.createSync();
      file.writeAsStringSync(
          'Player Name,Games Played,Games Won,Total Guesses,Total Time\n');
    }
  }

  // Method to load statistics for a given player
  Statistics loadStatistics(String playerName) {
    _ensureFileExists();
    final lines = File(filePath).readAsLinesSync();
    for (final line in lines.skip(1)) {
      final values = line.split(',');
      if (values[0] == playerName) {
        return Statistics(
          gamesPlayed: int.parse(values[1]),
          gamesWon: int.parse(values[2]),
          totalGuesses: double.parse(values[3]),
          totalTime: int.parse(values[4]),
        );
      }
    }
    return Statistics(); // Return default statistics if player not found
  }

  // Method to update or add statistics for a given player
  void saveStatistics(String playerName, Statistics statistics) {
    _ensureFileExists();
    final lines = File(filePath).readAsLinesSync();
    final buffer = StringBuffer();
    buffer.writeln(lines[0]); // Write the header

    bool playerFound = false;

    for (final line in lines.skip(1)) {
      final values = line.split(',');
      if (values[0] == playerName) {
        // Update the statistics for the player
        buffer.writeln(
            '$playerName,${statistics.gamesPlayed},${statistics.gamesWon},${statistics.totalGuesses},${statistics.totalTime}');
        playerFound = true;
      } else {
        buffer.writeln(line); // Write the line unmodified
      }
    }

    if (!playerFound) {
      // Add new player statistics
      buffer.writeln(
          '$playerName,${statistics.gamesPlayed},${statistics.gamesWon},${statistics.totalGuesses},${statistics.totalTime}');
    }

    // Write the updated content to the file
    File(filePath).writeAsStringSync(buffer.toString());
  }

  List<PlayerStatistics> getLeaderboard() {
    _ensureFileExists();
    final file = File(filePath);
    final lines = file.readAsLinesSync();

    // Remove the header line
    lines.removeAt(0);

    final playersStatistics = lines.map((line) {
      final values = line.split(',');
      return PlayerStatistics(
        playerName: values[0],
        gamesPlayed: int.parse(values[1]),
        gamesWon: int.parse(values[2]),
        totalGuesses: double.parse(values[3]),
        totalTime: int.parse(values[4]),
      );
    }).toList();

    // Sort based on a chosen criteria, for example, games won
    playersStatistics.sort((a, b) => b.gamesWon.compareTo(a.gamesWon));

    return playersStatistics;
  }

}

