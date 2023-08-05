# Hangman Terminal Game


Hangman is a classic word-guessing game. The game has two participants. One player thinks of a word, and the other tries to guess it by suggesting letters.

The word to guess is represented by a row of dashes on the screen, representing each letter of the word. If the guessing player suggests a letter which occurs in the word, the game will write it in all its correct positions. If the suggested letter does not occur in the word, the game will draw one element of a hanged man stick figure.

The game is over when:
1. The guessing player completes the word, or guesses the correct word
2. The hangman drawing is complete, which occurs after a certain number of incorrect guesses.

<br>

Here are the user stories for a terminal-based game inspired by Hangman:

### MVP

1. <b>Starting the Game</b>: As a player, I want to be able to start a new game of Hangman so that I can enjoy the challenge.

1. <b>Selecting a Word</b>: As a player, I want the game to randomly select a word from the provided Dictionary.txt so that each game provides a new challenge.

1. <b>Viewing the Game Interface</b>: As a player, I want to see the hangman interface on the terminal so I can keep track of the game's progress.

1. <b>Making a Guess</b>: As a player, I want to guess a letter by typing it into the terminal. If I guess correctly, the letter should be revealed in the word. If I guess incorrectly, a part of the hangman should be drawn.

1. <b>Repeated Guesses</b>: As a player, I want the game to prevent me from guessing the same letter more than once, so that I don't waste my guesses.

1. <b>Tracking Guesses</b>: As a player, I want to see a list of the letters I have already guessed in the terminal, so that I can make informed decisions about future guesses.

1. <b>Ending the Game</b>: As a player, I want the game to end if I've made too many incorrect guesses (i.e., the hangman is fully drawn) or if I've correctly guessed all the letters in the word.

1. <b>Winning or Losing</b>: As a player, I want to see a message when the game ends that tells me whether I've won (guessed the word correctly) or lost (hangman is fully drawn), so I know the outcome of the game.

1. <b>Revealing the Word</b>: As a player, if I lose the game, I want the correct word to be revealed so that I can learn from my incorrect guesses.

1. <b>Restarting the Game</b>: As a player, I want the option to play a new game once the current one ends so I can continue to enjoy the game.

<br>

### Advanced Gameplay and Statistics

1. <b>Difficulty Levels</b>: As a player, I want to be able to select a difficulty level (easy, medium, hard) at the start of the game, so I can choose a level of challenge that suits me.

1. <b>Game Statistics</b>: As a player, I want to see my game statistics (number of games played, number of games won, average guesses per game), so that I can track my progress and improvement.

1. <b>Hint System</b>: As a player, I want to have the option to ask for a hint after a certain number of wrong guesses, so I can get help when I'm stuck.

1. <b>Exiting the Game</b>: As a player, I want to have an option to exit the game whenever I want, so that I can stop playing whenever I want.

1. <b>Option to Guess the Full Word</b>: As a player, I want an option to guess the full word at once, if I think I know it, for an extra risk/reward element.

<br>

### CSV Database Integration and Game Improvements

1. <b>Sign up & Login Flow - 1</b>: As a player, I want to be able to create an account with a username and password so that I can have a personalized experience.

1. <b>Sign up & Login Flow - 2</b>: As a player, I want to be able to log in to my account using my username and password so that I can track my progress and continue playing.

1. <b>Sign up & Login Flow - 3</b>: As a player, I want the system to store my password securely (using hashing) to protect my personal data.

1. <b>Saving Statistics to CSV</b>: As a player, I want my game statistics to be saved in a CSV file each time I complete a game, so my progress is recorded and I can continue to improve.

1. <b>Loading Statistics from CSV</b>: As a player, I want the game to load my past statistics from a CSV file when I start a new game, so I can continue from where I left off.

1. <b>Leaderboard</b>: As a player, I want to see a leaderboard displaying top scores (based on least average guesses or fastest times), so that I can strive to improve my game and reach the top.


<br>
<br>

Note: This is a simple starting point. This implementation covers all the user stories provided above, but it's basic. It uses a an object-oriented approach which makes the code easier to manage and extend. Note that this could be further enhanced with more advanced features, better organization, and better error handling. Here are a certain additions that can be implemented:

- Introducing a time limit for each user input
- Improved gameplay functionality like multiplayer, time limits, game variations, session history
- Detailed statistics with high score alerts
- GUI Implementation
- User profiles & web app functionality
- Stronger Backend development
- Unit tests for the functionalities