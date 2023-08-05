import 'package:hangman_terminal_app/src/services/game_service.dart';

void main() {
  final gameService = GameService('lib/assets/dictionary.txt', 'lib/assets/users.csv', 'lib/assets/statistics.csv');
  gameService.signUpAndLogin();
}
