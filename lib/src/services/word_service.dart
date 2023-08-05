import 'dart:io';
import 'dart:math';

class WordService {
  List<String> easyWords;
  List<String> mediumWords;
  List<String> hardWords;

  WordService(String filePath)
      : easyWords = _loadWords(filePath, 1, 5),
        mediumWords = _loadWords(filePath, 6, 8),
        hardWords = _loadWords(filePath, 9);

  static List<String> _loadWords(String filePath, int minLength,
      [int maxLength = -1]) {
    final lines = File(filePath).readAsLinesSync();
    return lines.where((word) {
      final length = word.length;
      return maxLength == -1
          ? length >= minLength
          : length >= minLength && length <= maxLength;
    }).toList();
  }

  String getRandomWord(String difficulty) {
    final random = Random();
    List<String> words = [];
    switch (difficulty) {
      case 'easy':
        words = easyWords;
        break;
      case 'medium':
        words = mediumWords;
        break;
      case 'hard':
        words = hardWords;
        break;
    }
    final index = random.nextInt(words.length);
    return words[index];
  }
}
