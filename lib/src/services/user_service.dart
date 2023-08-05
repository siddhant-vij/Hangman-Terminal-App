import 'dart:convert';
import 'dart:io';
import 'package:crypto/crypto.dart';

class UserService {
  final String filePath;

  UserService(this.filePath) {
    _ensureFileExists();
  }

  void _ensureFileExists() {
    final file = File(filePath);
    if (!file.existsSync()) {
      file.createSync();
    }
  }

  String _hashPassword(String password) {
    final bytes = utf8.encode(password);
    return sha256.convert(bytes).toString();
  }

  bool userExists(String username) {
    final file = File(filePath);
    final lines = file.readAsLinesSync();
    return lines.any((line) => line.split(',')[0] == username);
  }

  void signUp(String username, String password) {
    if (userExists(username)) {
      print('\x1B[2J\x1B[0;0H');
      print('Username already exists. Please choose another one or login.');
      return;
    }
    final file = File(filePath);
    final hashedPassword = _hashPassword(password);
    file.writeAsStringSync('$username,$hashedPassword\n',
        mode: FileMode.append);
    print('\x1B[2J\x1B[0;0H');
    print('User created successfully.');
  }

  bool login(String username) {
    if (!userExists(username)) {
      print('\x1B[2J\x1B[0;0H');
      print('User does not exist. Please create an account first.');
      return false;
    }
    stdout.write('Password: ');
    stdin.echoMode = false;
    final password = stdin.readLineSync();
    stdin.echoMode = true;
    final file = File(filePath);
    final lines = file.readAsLinesSync();
    final hashedPassword = _hashPassword(password!);
    for (final line in lines) {
      final parts = line.split(',');
      if (parts[0] == username && parts[1].trim() == hashedPassword) {
        print('\x1B[2J\x1B[0;0H');
        print('Login successful!');
        return true;
      }
    }
    print('\x1B[2J\x1B[0;0H');
    print('Invalid password.');
    return false;
  }

  void resetPassword(String username, String newPassword) {
    if (!userExists(username)) {
      print('\x1B[2J\x1B[0;0H');
      print('User does not exist. Cannot reset the password.');
      return;
    }
    final file = File(filePath);
    final lines = file.readAsLinesSync();
    final newLines = lines.map((line) {
      final parts = line.split(',');
      if (parts[0] == username) {
        final hashedPassword = _hashPassword(newPassword);
        return '$username,$hashedPassword';
      }
      return line;
    }).join('\n');
    file.writeAsStringSync(newLines);
    print('\x1B[2J\x1B[0;0H');
    print('Password has been reset successfully.');
  }

  void addPlayer(String username, String playerName) {
    _ensureFileExists();
    final file = File(filePath);
    final lines = file.readAsLinesSync();
    final newLines = lines.map((line) {
      final parts = line.split(',');
      if (parts[0] == username) {
        final players = parts.sublist(2);
        players.removeWhere((player) => player.isEmpty);
        players.add(playerName);
        return '$username,${parts[1]},${players.join(',')}';
      }
      return line;
    }).join('\n');
    file.writeAsStringSync(newLines);
    print('Player added successfully.');
  }



  List<String> getPlayers(String username) {
    _ensureFileExists();
    final file = File(filePath);
    final lines = file.readAsLinesSync();
    for (final line in lines) {
      final parts = line.split(',');
      if (parts[0] == username) {
        return parts.sublist(2);
      }
    }
    return [];
  }
}
