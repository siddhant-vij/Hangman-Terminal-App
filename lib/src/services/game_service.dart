import 'dart:io';
import 'dart:math';

import 'package:hangman_terminal_app/src/models/game.dart';
import 'package:hangman_terminal_app/src/models/player.dart';
import 'package:hangman_terminal_app/src/models/word.dart';
import 'package:hangman_terminal_app/src/services/word_service.dart';
import 'package:hangman_terminal_app/src/services/user_service.dart';
import 'package:hangman_terminal_app/src/services/statistics_service.dart';

class GameService {
  WordService wordService;
  final UserService userService;
  final StatisticsService statisticsService;
  GameService(String filePath, String userFilePath, String csvFilePath)
      : wordService = WordService(filePath),
        userService = UserService(userFilePath),
        statisticsService = StatisticsService(csvFilePath);

  void signUpAndLogin() {
    while (true) {
      print('\n\nWelcome to Hangman Terminal Game!');
      print('1. Login');
      print('2. Create Account');
      print('3. Reset Password');
      print('4. Exit');
      stdout.write('Choose an option: ');
      final choice = stdin.readLineSync();
      print('\x1B[2J\x1B[0;0H');
      switch (choice) {
        case '1':
          _login();
          break;
        case '2':
          _signUp();
          break;
        case '3':
          _resetPassword();
          break;
        case '4':
          print('Exiting the game...');
          exit(0);
        default:
          print('Invalid choice. Please try again.');
          break;
      }
    }
  }

  void _login() {
    print('\x1B[2J\x1B[0;0H');
    print('----- Login -----');
    stdout.write('Username: ');
    final username = stdin.readLineSync();
    if (username != null && userService.login(username)) {
      mainMenu(username);
    }
  }

  void _signUp() {
    print('\x1B[2J\x1B[0;0H');
    print('----- Create Account -----');
    stdout.write('Username: ');
    final username = stdin.readLineSync();
    if (username != null) {
      if (userService.userExists(username)) {
        print('\x1B[2J\x1B[0;0H');
        print(
            'Username already exists. Please log in or choose another username.');
        return;
      }
      stdout.write('Password: ');
      stdin.echoMode = false;
      final password = stdin.readLineSync();
      stdin.echoMode = true;
      if (password != null) {
        userService.signUp(username, password);
      }
    }
  }

  void _resetPassword() {
    print('\x1B[2J\x1B[0;0H');
    print('----- Reset Password -----');
    stdout.write('Username: ');
    final username = stdin.readLineSync();
    if (userService.userExists(username!)) {
      stdout.write('New Password: ');
      stdin.echoMode = false;
      final newPassword = stdin.readLineSync();
      stdin.echoMode = true;
      if (newPassword != null) {
        userService.resetPassword(username, newPassword);
      }
    } else {
      print('\x1B[2J\x1B[0;0H');
      print('User does not exist.');
    }
  }

  void mainMenu(String username) {
    print('\nWelcome to the Hangman Terminal Game!');
    print('1. Play Game');
    print('2. View Leaderboard');
    print('3. Exit');

    final choice = int.parse(stdin.readLineSync()?.trim() ?? '');
    switch (choice) {
      case 1:
        runGame(username);
        break;
      case 2:
        displayLeaderboard();
        break;
      case 3:
        print('Exiting the game...');
        exit(0);
      default:
        print('Invalid choice, please try again.');
        mainMenu(username);
    }
  }

  void runGame(String username) {
    List<String> playerNames = userService.getPlayers(username);
    String? name;

    print('\x1B[2J\x1B[0;0H');

    if (playerNames.isNotEmpty) {
      print('Choose a player name or create a new one:');
      for (int i = 0; i < playerNames.length; i++) {
        print('${i + 1}. ${playerNames[i]}');
      }
      print('${playerNames.length + 1}. Create a new player name');
      var choice = int.parse(stdin.readLineSync()?.trim() ?? '');
      if (choice >= 1 && choice <= playerNames.length) {
        name = playerNames[choice - 1];
      } else if (choice == playerNames.length + 1) {
        stdout.write('Enter your player name: ');
        name = stdin.readLineSync()?.trim();
        if (name?.toLowerCase() == 'exit') {
          return;
        }
        while (name!.isEmpty) {
          stdout.write('Invalid name. Please enter a valid name: ');
          name = stdin.readLineSync()?.trim();
          if (name?.toLowerCase() == 'exit') {
            return;
          }
        }
        userService.addPlayer(username, name);
      }
    } else {
      stdout.write('Enter your player name: ');
      name = stdin.readLineSync()?.trim();
      if (name?.toLowerCase() == 'exit') {
        return;
      }
      while (name!.isEmpty) {
        stdout.write('Invalid name. Please enter a valid name: ');
        name = stdin.readLineSync()?.trim();
        if (name?.toLowerCase() == 'exit') {
          return;
        }
      }
      userService.addPlayer(username, name);
    }

    if (name == null || name.toLowerCase() == 'exit') {
      return;
    }

    print('\x1B[2J\x1B[0;0H');
    final player = Player(name);
    // Load existing statistics for this player
    player.statistics = statisticsService.loadStatistics(name);

    do {
      stdout.write('Select difficulty (easy, medium, hard): ');
      var difficulty = stdin.readLineSync()?.trim().toLowerCase();
      if (difficulty?.toLowerCase() == 'exit') {
        return;
      }
      while (!['easy', 'medium', 'hard'].contains(difficulty)) {
        stdout.write(
            'Invalid difficulty. Select difficulty (easy, medium, hard): ');
        difficulty = stdin.readLineSync()?.trim().toLowerCase();
        if (difficulty?.toLowerCase() == 'exit') {
          return;
        }
      }
      print('\x1B[2J\x1B[0;0H');
      final wordText = wordService.getRandomWord(difficulty!);
      final word = Word(wordText);
      final game = Game(player, word, difficulty);
      playGame(game);
      // Save updated statistics for this player
      statisticsService.saveStatistics(player.name, player.statistics);
    } while (wantsToPlayAgain());
  }

  void playGame(Game game) {
    final startTime = DateTime.now(); // Start the timer
    const hintThreshold = 3; // Offer a hint after this many incorrect guesses
    while (!game.isGameOver()) {
      printGameState(game);

      if (game.incorrectGuesses >= hintThreshold && !game.hintUsed) {
        stdout.write(
            'You can ask for a hint or guess the full word. Enter "hint" or your guess: ');
      } else {
        stdout.write('Enter a letter or guess the full word: ');
      }

      final guess = stdin.readLineSync();
      if (guess?.toLowerCase() == 'exit') {
        return;
      }
      if (guess?.toLowerCase() == 'hint' &&
          game.incorrectGuesses >= hintThreshold) {
        if (game.hintUsed) {
          print('Hint already used for this game.');
        } else {
          revealHintLetter(game);
          continue; // Skip the rest of the loop and start the next iteration
        }
      }

      if (guess != null && guess.length == game.word.text.length) {
        if (guess.toLowerCase() == game.word.text) {
          for (int i = 0; i < game.word.text.length; i++) {
            game.word.lettersRevealed[i] = true;
          }
        } else {
          // Increment the incorrect guesses by the number of unrevealed characters
          game.incorrectGuesses +=
              game.word.lettersRevealed.where((b) => !b).length;
          print('\nIncorrect full-word guess.\n');
        }
        continue;
      }

      if (handleGuess(game, guess)) {
        print('\x1B[2J\x1B[0;0H');
      } else {
        print('\n');
      }
    }
    final endTime = DateTime.now(); // Stop the timer
    final timeTaken = endTime
        .difference(startTime)
        .inSeconds; // Calculate time taken in seconds
    game.player.statistics
        .updateStats(game.hasPlayerWon(), game.totalGuesses, timeTaken);
    printEndGameMessage(game);
  }

  bool wantsToPlayAgain() {
    stdout.write('Do you want to play again? (yes/no): ');
    var answer = stdin.readLineSync()?.trim().toLowerCase();
    if (answer?.toLowerCase() == 'exit') {
      return false;
    }
    while (!['yes', 'no'].contains(answer)) {
      stdout.write('Invalid answer. Do you want to play again? (yes/no): ');
      answer = stdin.readLineSync()?.trim().toLowerCase();
      if (answer?.toLowerCase() == 'exit') {
        return false;
      }
    }
    print('\x1B[2J\x1B[0;0H');
    return answer == 'yes';
  }

  bool handleGuess(Game game, String? guess) {
    if (guess == null ||
        guess.length != 1 ||
        !RegExp(r'^[a-zA-Z]$').hasMatch(guess)) {
      print('\nInvalid guess. Please enter a single letter.');
      return false;
    }
    if (game.guessedLetters.contains(guess)) {
      print('\nYou have already guessed that letter.');
      return false;
    }
    game.totalGuesses++;
    game.guessedLetters.add(guess);
    if (!game.word.text.contains(guess)) {
      game.incorrectGuesses++;
    } else {
      for (int i = 0; i < game.word.text.length; i++) {
        if (game.word.text[i] == guess) {
          game.word.lettersRevealed[i] = true;
        }
      }
    }
    return true;
  }

  void printGameState(Game game) {
    print('Word: ${getRevealedWord(game.word)}');
    print('Guessed Letters: ${game.guessedLetters.join(', ')}');
    print('Incorrect Guesses: ${game.incorrectGuesses}');
  }

  String getRevealedWord(Word word) {
    var revealedWord = '';
    for (int i = 0; i < word.text.length; i++) {
      if (word.lettersRevealed[i]) {
        revealedWord += word.text[i];
      } else {
        revealedWord += '_';
      }
    }
    return revealedWord;
  }

  void printEndGameMessage(Game game) {
    if (game.hasPlayerWon()) {
      print('Congratulations! You won!');
      print('The word was ${game.word.text}.');
    } else {
      print('Sorry, you lost. The word was ${game.word.text}.');
    }
  }

  void revealHintLetter(Game game) {
    final random = Random();
    int index;
    do {
      index = random.nextInt(game.word.text.length);
    } while (game.word.lettersRevealed[index]);
    game.word.lettersRevealed[index] = true;
    game.hintUsed = true;
    print('Hint: The letter ${game.word.text[index]} is in the word.\n');
  }

  void displayLeaderboard() {
    final leaderboard = statisticsService.getLeaderboard();
    print('\x1B[2J\x1B[0;0H');

    // Calculate maximum widths for each column
    int maxNameLength = 'Player Name'.length;
    int maxGamesPlayedLength = 'Games Played'.length;
    int maxGamesWonLength = 'Games Won'.length;
    int maxTotalGuessesLength = 'Total Guesses'.length;
    int maxTotalTimeLength = 'Total Time'.length;
    for (final stats in leaderboard) {
      maxNameLength = max(maxNameLength, stats.playerName.length);
      maxGamesPlayedLength =
          max(maxGamesPlayedLength, stats.gamesPlayed.toString().length);
      maxGamesWonLength =
          max(maxGamesWonLength, stats.gamesWon.toString().length);
      maxTotalGuessesLength =
          max(maxTotalGuessesLength, stats.totalGuesses.toString().length);
      maxTotalTimeLength =
          max(maxTotalTimeLength, stats.totalTime.toString().length);
    }

    // Print header
    print(
        'Rank  | Player Name${' ' * (maxNameLength - 'Player Name'.length)} | Games Played${' ' * (maxGamesPlayedLength - 'Games Played'.length)} | Games Won${' ' * (maxGamesWonLength - 'Games Won'.length)} | Total Guesses${' ' * (maxTotalGuessesLength - 'Total Guesses'.length)} | Total Time${' ' * (maxTotalTimeLength - 'Total Time'.length)}');
    print('-' *
        (maxNameLength +
            maxGamesPlayedLength +
            maxGamesWonLength +
            maxTotalGuessesLength +
            maxTotalTimeLength +
            19));

    // Print leaderboard rows
    for (int i = 0; i < leaderboard.length; i++) {
      final playerStats = leaderboard[i];
      print(
          '${(i + 1).toString().padRight(5)}| ${playerStats.playerName.padRight(maxNameLength)} | ${playerStats.gamesPlayed.toString().padRight(maxGamesPlayedLength)} | ${playerStats.gamesWon.toString().padRight(maxGamesWonLength)} | ${playerStats.totalGuesses.toString().padRight(maxTotalGuessesLength)} | ${playerStats.totalTime.toString().padRight(maxTotalTimeLength)}');
    }
  }
}
