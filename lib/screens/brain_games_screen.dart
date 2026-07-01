import 'dart:async';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nes_ui/nes_ui.dart';
import '../themes/app_theme.dart';
import '../widgets/ambient_background.dart';
import '../widgets/glass_card.dart';

class BrainGamesScreen extends StatefulWidget {
  const BrainGamesScreen({super.key});

  @override
  State<BrainGamesScreen> createState() => _BrainGamesScreenState();
}

class _BrainGamesScreenState extends State<BrainGamesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgLight,
      body: AmbientBackground(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
                child: Row(
                  children: [
                    Text('BRAIN GAMES', style: headingStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xfff7d51d).withValues(alpha: 0.2),
                        border: Border.all(color: const Color(0xfff7d51d), width: 1),
                      ),
                      child: Text('TRAIN MIND', style: bodyStyle(color: const Color(0xfff7d51d), fontSize: 8, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ),
              
              // Games List
              Expanded(
                child: ListView(
                  padding: EdgeInsets.fromLTRB(20, 8, 20, 100 + MediaQuery.of(context).padding.bottom),
                  physics: const BouncingScrollPhysics(),
                  children: [
                    _buildGameCard(title: 'Memory Match', subtitle: 'Find matching pairs', icon: CupertinoIcons.square_grid_2x2, color: const Color(0xff92cc41), onTap: () => _navigateToGame(const MemoryMatchGame())),
                    const SizedBox(height: 8),
                    _buildGameCard(title: 'Color Reaction', subtitle: 'Test your reflexes', icon: CupertinoIcons.paintbrush, color: accent, onTap: () => _navigateToGame(const ColorReactionGame())),
                    const SizedBox(height: 8),
                    _buildGameCard(title: 'Word Scramble', subtitle: 'Unscramble the letters', icon: CupertinoIcons.textformat_abc, color: const Color(0xff92cc41), onTap: () => _navigateToGame(const WordScrambleGame())),
                    const SizedBox(height: 8),
                    _buildGameCard(title: 'Math Challenge', subtitle: 'Quick mental math', icon: CupertinoIcons.sum, color: const Color(0xfff7d51d), onTap: () => _navigateToGame(const MathChallengeGame())),
                    const SizedBox(height: 8),
                    _buildGameCard(title: 'Simon Says', subtitle: 'Repeat the pattern', icon: CupertinoIcons.play_circle_fill, color: primary, onTap: () => _navigateToGame(const SimonSaysGame())),
                    const SizedBox(height: 8),
                    _buildGameCard(title: 'Tic Tac Toe', subtitle: 'Classic strategy game', icon: CupertinoIcons.xmark, color: const Color(0xffe76e55), onTap: () => _navigateToGame(const TicTacToeGame())),
                    const SizedBox(height: 8),
                    _buildGameCard(title: 'Bubble Pop', subtitle: 'Tap targets quickly', icon: CupertinoIcons.circle_grid_3x3, color: const Color(0xff92cc41), onTap: () => _navigateToGame(const BubblePopGame())),
                    const SizedBox(height: 8),
                    _buildGameCard(title: 'Typing Speed', subtitle: 'Type words fast', icon: CupertinoIcons.keyboard, color: const Color(0xff209cee), onTap: () => _navigateToGame(const TypingSpeedGame())),
                    const SizedBox(height: 8),
                    _buildGameCard(title: 'Puzzle Slide', subtitle: 'Arrange numbers 1-15', icon: CupertinoIcons.square_grid_2x2, color: const Color(0xfff7d51d), onTap: () => _navigateToGame(const PuzzleSlideGame())),
                    const SizedBox(height: 8),
                    _buildGameCard(title: 'Number Memory', subtitle: 'Remember the sequence', icon: CupertinoIcons.eye_fill, color: const Color(0xffe76e55), onTap: () => _navigateToGame(const NumberMemoryGame())),
                    const SizedBox(height: 8),
                    _buildGameCard(title: 'Color Catch', subtitle: 'Catch falling colors', icon: CupertinoIcons.arrow_down_circle_fill, color: primary, onTap: () => _navigateToGame(const ColorCatchGame())),
                    const SizedBox(height: 8),
                    _buildGameCard(title: 'Word Chain', subtitle: 'Connect the words', icon: CupertinoIcons.link, color: const Color(0xff92cc41), onTap: () => _navigateToGame(const WordChainGame())),
                    const SizedBox(height: 8),
                    _buildGameCard(title: 'Rapid Tap', subtitle: 'Tap as fast as you can', icon: CupertinoIcons.hand_raised_fill, color: accent, onTap: () => _navigateToGame(const RapidTapGame())),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToGame(Widget game) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => game),
    );
  }

  Widget _buildGameCard({required String title, required String subtitle, required IconData icon, required Color color, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: glassCard(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: color,
                border: Border.all(color: Colors.white, width: 1),
              ),
              child: Icon(icon, color: Colors.white, size: 22),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: bodyStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 2),
                  Text(subtitle, style: bodyStyle(fontSize: 8, color: textMid)),
                ],
              ),
            ),
            Icon(CupertinoIcons.chevron_right, color: textMid, size: 14),
          ],
        ),
      ),
    );
  }
}

// ================= MEMORY MATCH GAME (NES style) =================
class MemoryMatchGame extends StatefulWidget {
  const MemoryMatchGame({super.key});

  @override
  State<MemoryMatchGame> createState() => _MemoryMatchGameState();
}

class _MemoryMatchGameState extends State<MemoryMatchGame> {
  List<String> _symbols = [];
  List<bool> _revealed = [];
  List<bool> _matched = [];
  int? _firstSelected;
  int _moves = 0;
  int _matches = 0;
  bool _gameComplete = false;

  @override
  void initState() {
    super.initState();
    _initGame();
  }

  void _initGame() {
    final emojis = ['🌙', '⭐', '🌊', '🔥', '🌸', '🎵', '💫', '🦋'];
    _symbols = [...emojis, ...emojis]..shuffle();
    _revealed = List.filled(16, false);
    _matched = List.filled(16, false);
    _firstSelected = null;
    _moves = 0;
    _matches = 0;
    _gameComplete = false;
  }

  void _onTileTap(int index) {
    if (_revealed[index] || _matched[index] || _gameComplete) return;

    setState(() {
      _revealed[index] = true;

      if (_firstSelected == null) {
        _firstSelected = index;
      } else {
        _moves++;
        if (_symbols[_firstSelected!] == _symbols[index]) {
          _matched[_firstSelected!] = true;
          _matched[index] = true;
          _matches++;
          if (_matches == 8) _gameComplete = true;
        } else {
          final first = _firstSelected!;
          Future.delayed(const Duration(milliseconds: 500), () {
            if (mounted) {
              setState(() {
                _revealed[first] = false;
                _revealed[index] = false;
              });
            }
          });
        }
        _firstSelected = null;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgLight,
      body: AmbientBackground(
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
                child: Row(
                  children: [
                    NesButton(type: NesButtonType.normal, onPressed: () => Navigator.of(context).pop(), child: const Icon(CupertinoIcons.chevron_left, color: Colors.black, size: 20)),
                    const SizedBox(width: 8),
                    Text('MEMORY MATCH', style: headingStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                    const Spacer(),
                    Text('Moves: $_moves', style: bodyStyle(fontSize: 8, color: textMid)),
                  ],
                ),
              ),
              if (_gameComplete)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: glassCard(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(CupertinoIcons.star_fill, color: Color(0xfff7d51d), size: 20),
                        const SizedBox(width: 8),
                        Text('Completed in $_moves moves!', style: bodyStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ),
              const SizedBox(height: 12),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4, mainAxisSpacing: 8, crossAxisSpacing: 8),
                    itemCount: 16,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () => _onTileTap(index),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          decoration: BoxDecoration(
                            color: _matched[index] ? const Color(0xff92cc41).withValues(alpha: 0.3) : _revealed[index] ? surface : primary.withValues(alpha: 0.2),
                            border: Border.all(color: _matched[index] ? const Color(0xff92cc41) : _revealed[index] ? Colors.white24 : Colors.white10, width: 2),
                          ),
                          child: Center(
                            child: _revealed[index] || _matched[index]
                                ? Text(_symbols[index], style: const TextStyle(fontSize: 24))
                                : Icon(CupertinoIcons.question, color: textMid, size: 20),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              if (_gameComplete)
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: NesButton(type: NesButtonType.primary, onPressed: () => setState(() => _initGame()), child: const Text('PLAY AGAIN')),
                ),
              const SizedBox(height: 60),
            ],
          ),
        ),
      ),
    );
  }
}

// ================= COLOR REACTION GAME (NES style) =================
class ColorReactionGame extends StatefulWidget {
  const ColorReactionGame({super.key});

  @override
  State<ColorReactionGame> createState() => _ColorReactionGameState();
}

class _ColorReactionGameState extends State<ColorReactionGame> {
  Color _backgroundColor = const Color(0xff808080);
  String _text = 'Tap when GREEN';
  bool _waiting = false;
  bool _started = false;
  DateTime? _startTime;
  int _bestTime = 999;
  int _attempts = 0;

  void _startGame() {
    setState(() {
      _backgroundColor = accent;
      _text = 'Wait for green...';
      _waiting = true;
      _started = false;
    });
    
    final random = Random();
    final delay = 1500 + random.nextInt(3000);
    
    Future.delayed(Duration(milliseconds: delay), () {
      if (mounted && _waiting) {
        setState(() {
          _backgroundColor = const Color(0xff92cc41);
          _text = 'TAP NOW!';
          _started = true;
          _startTime = DateTime.now();
        });
      }
    });
  }

  void _onTap() {
    if (!_waiting) {
      _startGame();
      return;
    }
    
    if (_started && _startTime != null) {
      final reactionTime = DateTime.now().difference(_startTime!).inMilliseconds;
      setState(() {
        _backgroundColor = const Color(0xff808080);
        _waiting = false;
        _started = false;
        _attempts++;
        if (reactionTime < _bestTime) {
          _bestTime = reactionTime;
          _text = 'New Best: ${reactionTime}ms!';
        } else {
          _text = 'Reaction: ${reactionTime}ms';
        }
      });
    } else if (_waiting && !_started) {
      setState(() {
        _backgroundColor = const Color(0xfff7d51d);
        _text = 'Too early! Tap to retry';
        _waiting = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _onTap,
      child: Scaffold(
        backgroundColor: _backgroundColor,
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
                child: Row(
                  children: [
                    NesButton(type: NesButtonType.normal, onPressed: () => Navigator.of(context).pop(), child: const Icon(CupertinoIcons.chevron_left, color: Colors.black, size: 20)),
                    const SizedBox(width: 8),
                    Text('COLOR REACTION', style: headingStyle(fontSize: 14, fontWeight: FontWeight.bold, color: const Color(0xffffffff))),
                    const Spacer(),
                    if (_bestTime < 999) Text('Best: ${_bestTime}ms', style: bodyStyle(fontSize: 8, color: const Color(0xffffffff), fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              const Spacer(),
              Column(
                children: [
                  Text(_text, style: headingStyle(fontSize: 18, fontWeight: FontWeight.bold, color: const Color(0xffffffff)), textAlign: TextAlign.center),
                  const SizedBox(height: 16),
                  Text('Attempts: $_attempts', style: bodyStyle(fontSize: 10, color: const Color(0xffffffff).withValues(alpha: 0.7))),
                ],
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}

// ================= WORD SCRAMBLE GAME (NES style) =================
class WordScrambleGame extends StatefulWidget {
  const WordScrambleGame({super.key});

  @override
  State<WordScrambleGame> createState() => _WordScrambleGameState();
}

class _WordScrambleGameState extends State<WordScrambleGame> {
  final List<String> _words = ['SLEEP', 'DREAM', 'NIGHT', 'MOON', 'STAR', 'WAVE', 'CALM', 'REST'];
  String _currentWord = '';
  String _scrambled = '';
  int _score = 0;
  String _feedback = '';
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nextWord();
  }

  void _nextWord() {
    _currentWord = _words[Random().nextInt(_words.length)];
    final chars = _currentWord.split('')..shuffle();
    _scrambled = chars.join();
    while (_scrambled == _currentWord) {
      chars.shuffle();
      _scrambled = chars.join();
    }
    _feedback = '';
    _controller.clear();
  }

  void _checkAnswer() {
    final answer = _controller.text.toUpperCase().trim();
    setState(() {
      if (answer == _currentWord) {
        _score += 10;
        _feedback = 'CORRECT!';
        Future.delayed(const Duration(seconds: 1), () {
          if (mounted) setState(() => _nextWord());
        });
      } else {
        _feedback = 'TRY AGAIN!';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgLight,
      body: AmbientBackground(
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
                child: Row(
                  children: [
                    NesButton(type: NesButtonType.normal, onPressed: () => Navigator.of(context).pop(), child: const Icon(CupertinoIcons.chevron_left, color: Colors.black, size: 20)),
                    const SizedBox(width: 8),
                    Text('WORD SCRAMBLE', style: headingStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                    const Spacer(),
                    Text('Score: $_score', style: bodyStyle(fontSize: 10, color: const Color(0xff92cc41), fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              const SizedBox(height: 60),
              Text('Unscramble the word:', style: bodyStyle(fontSize: 10, color: textMid)),
              const SizedBox(height: 16),
              Text(_scrambled, style: headingStyle(fontSize: 28, fontWeight: FontWeight.bold)),
              const SizedBox(height: 32),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: TextField(
                  controller: _controller,
                  decoration: const InputDecoration(labelText: 'Type your answer'),
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 14),
                  onSubmitted: (_) => _checkAnswer(),
                ),
              ),
              const SizedBox(height: 16),
              if (_feedback.isNotEmpty)
                Text(_feedback, style: bodyStyle(color: _feedback == 'CORRECT!' ? const Color(0xff92cc41) : accent, fontSize: 12, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              NesButton(type: NesButtonType.primary, onPressed: _checkAnswer, child: const Text('SUBMIT')),
            ],
          ),
        ),
      ),
    );
  }
}

// ================= MATH CHALLENGE GAME (NES style) =================
class MathChallengeGame extends StatefulWidget {
  const MathChallengeGame({super.key});

  @override
  State<MathChallengeGame> createState() => _MathChallengeGameState();
}

class _MathChallengeGameState extends State<MathChallengeGame> {
  int _num1 = 0;
  int _num2 = 0;
  String _operator = '+';
  int _correctAnswer = 0;
  List<int> _options = [];
  int _score = 0;
  int _streak = 0;
  String _feedback = '';

  @override
  void initState() {
    super.initState();
    _generateProblem();
  }

  void _generateProblem() {
    final random = Random();
    final operators = ['+', '-', '×'];
    _operator = operators[random.nextInt(operators.length)];
    
    switch (_operator) {
      case '+':
        _num1 = random.nextInt(20) + 1;
        _num2 = random.nextInt(20) + 1;
        _correctAnswer = _num1 + _num2;
        break;
      case '-':
        _num1 = random.nextInt(20) + 10;
        _num2 = random.nextInt(_num1);
        _correctAnswer = _num1 - _num2;
        break;
      case '×':
        _num1 = random.nextInt(10) + 1;
        _num2 = random.nextInt(10) + 1;
        _correctAnswer = _num1 * _num2;
        break;
    }
    
    _options = [_correctAnswer];
    while (_options.length < 4) {
      final wrong = _correctAnswer + random.nextInt(10) - 5;
      if (wrong != _correctAnswer && !_options.contains(wrong) && wrong >= 0) {
        _options.add(wrong);
      }
    }
    _options.shuffle();
    _feedback = '';
  }

  void _checkAnswer(int answer) {
    setState(() {
      if (answer == _correctAnswer) {
        _score += 10 + _streak * 2;
        _streak++;
        _feedback = _streak >= 3 ? '🔥 $_streak Streak!' : 'CORRECT!';
      } else {
        _streak = 0;
        _feedback = 'Wrong! Answer: $_correctAnswer';
      }
      Future.delayed(const Duration(milliseconds: 800), () {
        if (mounted) _generateProblem();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgLight,
      body: AmbientBackground(
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
                child: Row(
                  children: [
                    NesButton(type: NesButtonType.normal, onPressed: () => Navigator.of(context).pop(), child: const Icon(CupertinoIcons.chevron_left, color: Colors.black, size: 20)),
                    const SizedBox(width: 8),
                    Text('MATH CHALLENGE', style: headingStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                    const Spacer(),
                    Text('Score: $_score', style: bodyStyle(fontSize: 10, color: const Color(0xfff7d51d), fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              const SizedBox(height: 60),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('$_num1', style: headingStyle(fontSize: 32, fontWeight: FontWeight.bold)),
                  Padding(padding: const EdgeInsets.symmetric(horizontal: 12), child: Text(_operator, style: headingStyle(fontSize: 28, fontWeight: FontWeight.bold, color: primary))),
                  Text('$_num2', style: headingStyle(fontSize: 32, fontWeight: FontWeight.bold)),
                  Padding(padding: const EdgeInsets.symmetric(horizontal: 12), child: Text('=', style: headingStyle(fontSize: 28, fontWeight: FontWeight.bold, color: textMid))),
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(color: surface, border: Border.all(color: Colors.white10, width: 2)),
                    child: Center(child: Text('?', style: headingStyle(fontSize: 24, fontWeight: FontWeight.bold, color: textMid))),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              if (_feedback.isNotEmpty)
                Text(_feedback, style: bodyStyle(color: _feedback.contains('Correct') || _feedback.contains('Streak') ? const Color(0xff92cc41) : accent, fontSize: 12, fontWeight: FontWeight.bold)),
              const SizedBox(height: 24),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: _options.map((opt) => GestureDetector(
                  onTap: () => _checkAnswer(opt),
                  child: Container(
                    width: 70,
                    height: 50,
                    decoration: BoxDecoration(color: surface, border: Border.all(color: Colors.white10, width: 2)),
                    child: Center(child: Text('$opt', style: headingStyle(fontSize: 18, fontWeight: FontWeight.bold))),
                  ),
                )).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ================= SIMON SAYS GAME (NES style) =================
class SimonSaysGame extends StatefulWidget {
  const SimonSaysGame({super.key});

  @override
  State<SimonSaysGame> createState() => _SimonSaysGameState();
}

class _SimonSaysGameState extends State<SimonSaysGame> {
  final List<Color> _colors = [accent, primary, const Color(0xff92cc41), const Color(0xfff7d51d)];
  List<int> _sequence = [];
  List<int> _userInput = [];
  int _level = 0;
  bool _showingSequence = false;
  int? _activeColor;
  String _feedback = '';
  bool _gameOver = false;

  @override
  void initState() {
    super.initState();
    _startGame();
  }

  void _startGame() {
    _sequence = [];
    _level = 0;
    _gameOver = false;
    _nextRound();
  }

  void _nextRound() {
    _level++;
    _userInput = [];
    _sequence.add(Random().nextInt(4));
    _showSequence();
  }

  void _showSequence() {
    _showingSequence = true;
    _feedback = 'Watch carefully!';
    
    for (int i = 0; i < _sequence.length; i++) {
      Future.delayed(Duration(milliseconds: 600 * (i + 1)), () {
        if (mounted) {
          setState(() => _activeColor = _sequence[i]);
          Future.delayed(const Duration(milliseconds: 400), () {
            if (mounted) setState(() => _activeColor = null);
          });
        }
      });
    }
    
    Future.delayed(Duration(milliseconds: 600 * (_sequence.length + 1)), () {
      if (mounted) setState(() { _showingSequence = false; _feedback = 'Your turn!'; });
    });
  }

  void _onColorTap(int index) {
    if (_showingSequence || _gameOver) return;
    
    setState(() {
      _activeColor = index;
      Future.delayed(const Duration(milliseconds: 200), () {
        if (mounted) setState(() => _activeColor = null);
      });
    });
    
    _userInput.add(index);
    
    if (_userInput.last != _sequence[_userInput.length - 1]) {
      setState(() { _gameOver = true; _feedback = 'Game Over! Level: $_level'; });
      return;
    }
    
    if (_userInput.length == _sequence.length) {
      setState(() => _feedback = 'Correct!');
      Future.delayed(const Duration(milliseconds: 800), () {
        if (mounted) _nextRound();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgLight,
      body: AmbientBackground(
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
                child: Row(
                  children: [
                    NesButton(type: NesButtonType.normal, onPressed: () => Navigator.of(context).pop(), child: const Icon(CupertinoIcons.chevron_left, color: Colors.black, size: 20)),
                    const SizedBox(width: 8),
                    Text('SIMON SAYS', style: headingStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                    const Spacer(),
                    Text('Level: $_level', style: bodyStyle(fontSize: 10, color: primary, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              const Spacer(),
              Text(_feedback, style: bodyStyle(fontSize: 12, fontWeight: FontWeight.bold)),
              const SizedBox(height: 32),
              SizedBox(
                width: 220,
                height: 220,
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, mainAxisSpacing: 8, crossAxisSpacing: 8),
                  itemCount: 4,
                  itemBuilder: (context, index) {
                    final isActive = _activeColor == index;
                    return GestureDetector(
                      onTap: () => _onColorTap(index),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 150),
                        decoration: BoxDecoration(
                          color: isActive ? _colors[index] : _colors[index].withValues(alpha: 0.3),
                          border: Border.all(color: isActive ? Colors.white : Colors.white24, width: isActive ? 3 : 1),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const Spacer(),
              if (_gameOver)
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: NesButton(type: NesButtonType.primary, onPressed: () => setState(() => _startGame()), child: const Text('PLAY AGAIN')),
                ),
              const SizedBox(height: 60),
            ],
          ),
        ),
      ),
    );
  }
}

// ================= TIC TAC TOE GAME (NES style) =================
class TicTacToeGame extends StatefulWidget {
  const TicTacToeGame({super.key});

  @override
  State<TicTacToeGame> createState() => _TicTacToeGameState();
}

class _TicTacToeGameState extends State<TicTacToeGame> {
  List<String> _board = List.filled(9, '');
  bool _isXTurn = true;
  String _winner = '';
  bool _isDraw = false;

  void _onTap(int index) {
    if (_board[index] != '' || _winner != '' || _isDraw) return;
    
    setState(() {
      _board[index] = _isXTurn ? 'X' : 'O';
      _isXTurn = !_isXTurn;
      _checkWinner();
    });
  }

  void _checkWinner() {
    const winPatterns = [
      [0, 1, 2], [3, 4, 5], [6, 7, 8],
      [0, 3, 6], [1, 4, 7], [2, 5, 8],
      [0, 4, 8], [2, 4, 6],
    ];
    
    for (final pattern in winPatterns) {
      if (_board[pattern[0]] != '' && _board[pattern[0]] == _board[pattern[1]] && _board[pattern[0]] == _board[pattern[2]]) {
        setState(() => _winner = _board[pattern[0]]);
        return;
      }
    }
    
    if (!_board.contains('')) setState(() => _isDraw = true);
  }

  void _reset() {
    setState(() {
      _board = List.filled(9, '');
      _isXTurn = true;
      _winner = '';
      _isDraw = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgLight,
      body: AmbientBackground(
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
                child: Row(
                  children: [
                    NesButton(type: NesButtonType.normal, onPressed: () => Navigator.of(context).pop(), child: const Icon(CupertinoIcons.chevron_left, color: Colors.black, size: 20)),
                    const SizedBox(width: 8),
                    Text('TIC TAC TOE', style: headingStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                    const Spacer(),
                    Icon(_isXTurn ? CupertinoIcons.xmark : CupertinoIcons.circle, color: primary, size: 20),
                  ],
                ),
              ),
              const Spacer(),
              if (_winner.isNotEmpty)
                Text('$_winner Wins!', style: headingStyle(fontSize: 20, fontWeight: FontWeight.bold, color: const Color(0xff92cc41)))
              else if (_isDraw)
                Text('Draw!', style: headingStyle(fontSize: 20, fontWeight: FontWeight.bold, color: const Color(0xfff7d51d)))
              else
                Text('${_isXTurn ? "X" : "O"} Turn', style: bodyStyle(fontSize: 12, color: textMid)),
              const SizedBox(height: 24),
              SizedBox(
                width: 240,
                height: 240,
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, mainAxisSpacing: 6, crossAxisSpacing: 6),
                  itemCount: 9,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () => _onTap(index),
                      child: Container(
                        decoration: BoxDecoration(color: surface, border: Border.all(color: Colors.white10, width: 2)),
                        child: Center(
                          child: Text(_board[index], style: headingStyle(fontSize: 28, fontWeight: FontWeight.bold, color: _board[index] == 'X' ? primary : accent)),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.all(20),
                child: NesButton(type: NesButtonType.primary, onPressed: _reset, child: const Text('NEW GAME')),
              ),
              const SizedBox(height: 60),
            ],
          ),
        ),
      ),
    );
  }
}

// ================= BUBBLE POP GAME (NES style) =================
class BubblePopGame extends StatefulWidget {
  const BubblePopGame({super.key});

  @override
  State<BubblePopGame> createState() => _BubblePopGameState();
}

class _BubblePopGameState extends State<BubblePopGame> {
  List<_Bubble> _bubbles = [];
  int _score = 0;
  int _timeLeft = 30;
  Timer? _timer;
  Timer? _spawnTimer;
  bool _gameStarted = false;

  @override
  void initState() {
    super.initState();
  }

  void _startGame() {
    setState(() { _score = 0; _timeLeft = 30; _bubbles = []; _gameStarted = true; });
    
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _timeLeft--;
        for (final b in _bubbles) { b.life--; }
        _bubbles.removeWhere((b) => b.life <= 0);
        if (_timeLeft <= 0) _endGame();
      });
    });
    
    _spawnTimer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      if (mounted) setState(() { _bubbles.add(_Bubble.random()); });
    });
  }

  void _endGame() {
    _timer?.cancel();
    _spawnTimer?.cancel();
    setState(() => _gameStarted = false);
  }

  void _popBubble(_Bubble bubble) {
    setState(() { _bubbles.remove(bubble); _score += bubble.points; });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _spawnTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgLight,
      body: AmbientBackground(
        child: SafeArea(
          child: Stack(
            children: [
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
                    child: Row(
                      children: [
                        NesButton(type: NesButtonType.normal, onPressed: () => Navigator.of(context).pop(), child: const Icon(CupertinoIcons.chevron_left, color: Colors.black, size: 20)),
                        const SizedBox(width: 8),
                        Text('BUBBLE POP', style: headingStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                        const Spacer(),
                        Text('$_score pts', style: bodyStyle(fontSize: 10, color: primary, fontWeight: FontWeight.bold)),
                        const SizedBox(width: 12),
                        Text('$_timeLeft s', style: bodyStyle(fontSize: 10, color: _timeLeft < 10 ? accent : Colors.white, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                  if (!_gameStarted)
                    Expanded(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (_score > 0) Text('Score: $_score', style: headingStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 20),
                            NesButton(type: NesButtonType.primary, onPressed: _startGame, child: const Text('START GAME')),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
              if (_gameStarted)
                ...List.generate(_bubbles.length, (index) {
                  final bubble = _bubbles[index];
                  return Positioned(
                    left: bubble.x - bubble.radius,
                    top: bubble.y - bubble.radius,
                    child: GestureDetector(
                      onTap: () => _popBubble(bubble),
                      child: Container(
                        width: bubble.radius * 2,
                        height: bubble.radius * 2,
                        decoration: BoxDecoration(
                          color: bubble.color,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: Center(child: Text('${bubble.points}', style: bodyStyle(fontSize: 10, fontWeight: FontWeight.bold))),
                      ),
                    ),
                  );
                }),
            ],
          ),
        ),
      ),
    );
  }
}

class _Bubble {
  double x;
  double y;
  double radius;
  Color color;
  int points;
  int life;

  _Bubble({required this.x, required this.y, required this.radius, required this.color, required this.points, required this.life});

  factory _Bubble.random() {
    final random = Random();
    final colors = [primary, accent, const Color(0xff92cc41), const Color(0xfff7d51d), const Color(0xff9badb7)];
    return _Bubble(
      x: random.nextDouble() * 300 + 40,
      y: random.nextDouble() * 400 + 80,
      radius: 18 + random.nextDouble() * 16,
      color: colors[random.nextInt(colors.length)],
      points: random.nextInt(3) + 1,
      life: 4,
    );
  }
}

// ================= TYPING SPEED GAME (NES style) =================
class TypingSpeedGame extends StatefulWidget {
  const TypingSpeedGame({super.key});

  @override
  State<TypingSpeedGame> createState() => _TypingSpeedGameState();
}

class _TypingSpeedGameState extends State<TypingSpeedGame> {
  final List<String> _words = ['sleep', 'dream', 'night', 'moon', 'star', 'peace', 'rest', 'calm', 'wave', 'zen', 'nap', 'bed', 'pillow', 'blanket'];
  String _currentWord = '';
  int _score = 0;
  int _timeLeft = 30;
  Timer? _timer;
  bool _started = false;
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nextWord();
  }

  void _startGame() {
    setState(() { _score = 0; _timeLeft = 30; _started = true; });
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _timeLeft--;
        if (_timeLeft <= 0) { _timer?.cancel(); _started = false; }
      });
    });
  }

  void _nextWord() {
    _currentWord = _words[Random().nextInt(_words.length)];
    _controller.clear();
  }

  void _checkInput(String value) {
    if (!_started) return;
    setState(() {
      if (value == _currentWord) { _score += _currentWord.length * 2; _nextWord(); }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgLight,
      body: AmbientBackground(
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
                child: Row(
                  children: [
                    NesButton(type: NesButtonType.normal, onPressed: () => Navigator.of(context).pop(), child: const Icon(CupertinoIcons.chevron_left, color: Colors.black, size: 20)),
                    const SizedBox(width: 8),
                    Text('TYPING SPEED', style: headingStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                    const Spacer(),
                    Text('$_score pts', style: bodyStyle(fontSize: 10, color: primary, fontWeight: FontWeight.bold)),
                    const SizedBox(width: 12),
                    Text('$_timeLeft s', style: bodyStyle(fontSize: 10, color: _timeLeft < 10 ? accent : Colors.white)),
                  ],
                ),
              ),
              const Spacer(),
              if (!_started)
                NesButton(type: NesButtonType.primary, onPressed: _startGame, child: const Text('START'))
              else ...[
                Text('Type this word:', style: bodyStyle(fontSize: 10, color: textMid)),
                const SizedBox(height: 16),
                Text(_currentWord, style: headingStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                const SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: TextField(
                    controller: _controller,
                    onChanged: _checkInput,
                    decoration: const InputDecoration(labelText: 'Start typing...', border: InputBorder.none),
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 18),
                    autofocus: true,
                  ),
                ),
              ],
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}

// ================= PUZZLE SLIDE GAME (NES style) =================
class PuzzleSlideGame extends StatefulWidget {
  const PuzzleSlideGame({super.key});

  @override
  State<PuzzleSlideGame> createState() => _PuzzleSlideGameState();
}

class _PuzzleSlideGameState extends State<PuzzleSlideGame> {
  List<int> _tiles = [];
  int _moves = 0;
  bool _solved = false;

  @override
  void initState() {
    super.initState();
    _initPuzzle();
  }

  void _initPuzzle() {
    _tiles = List.generate(15, (i) => i + 1)..add(0);
    _moves = 0;
    _solved = false;
    
    final random = Random();
    for (int i = 0; i < 200; i++) {
      final emptyIndex = _tiles.indexOf(0);
      final validMoves = _getValidMoves(emptyIndex);
      final randomMove = validMoves[random.nextInt(validMoves.length)];
      _swapTiles(emptyIndex, randomMove);
    }
  }

  List<int> _getValidMoves(int emptyIndex) {
    final moves = <int>[];
    final row = emptyIndex ~/ 4;
    final col = emptyIndex % 4;
    if (row > 0) moves.add(emptyIndex - 4);
    if (row < 3) moves.add(emptyIndex + 4);
    if (col > 0) moves.add(emptyIndex - 1);
    if (col < 3) moves.add(emptyIndex + 1);
    return moves;
  }

  void _swapTiles(int a, int b) {
    final temp = _tiles[a];
    _tiles[a] = _tiles[b];
    _tiles[b] = temp;
  }

  void _onTileTap(int index) {
    if (_solved) return;
    final emptyIndex = _tiles.indexOf(0);
    final validMoves = _getValidMoves(emptyIndex);
    if (validMoves.contains(index)) {
      setState(() { _swapTiles(emptyIndex, index); _moves++; _checkSolved(); });
    }
  }

  void _checkSolved() {
    for (int i = 0; i < 15; i++) {
      if (_tiles[i] != i + 1) return;
    }
    setState(() => _solved = true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgLight,
      body: AmbientBackground(
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
                child: Row(
                  children: [
                    NesButton(type: NesButtonType.normal, onPressed: () => Navigator.of(context).pop(), child: const Icon(CupertinoIcons.chevron_left, color: Colors.black, size: 20)),
                    const SizedBox(width: 8),
                    Text('PUZZLE SLIDE', style: headingStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                    const Spacer(),
                    Text('$_moves moves', style: bodyStyle(fontSize: 10, color: const Color(0xfff7d51d), fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              const Spacer(),
              if (_solved)
                Padding(padding: const EdgeInsets.only(bottom: 16), child: Text('Solved in $_moves moves!', style: headingStyle(fontSize: 14, fontWeight: FontWeight.bold, color: const Color(0xff92cc41)))),
              SizedBox(
                width: 240,
                height: 240,
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4, mainAxisSpacing: 3, crossAxisSpacing: 3),
                  itemCount: 16,
                  itemBuilder: (context, index) {
                    final value = _tiles[index];
                    if (value == 0) return const SizedBox();
                    return GestureDetector(
                      onTap: () => _onTileTap(index),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 150),
                        decoration: BoxDecoration(color: primary, border: Border.all(color: Colors.white, width: 1)),
                        child: Center(child: Text('$value', style: headingStyle(fontSize: 18, fontWeight: FontWeight.bold))),
                      ),
                    );
                  },
                ),
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.all(20),
                child: NesButton(type: NesButtonType.primary, onPressed: () => setState(() => _initPuzzle()), child: const Text('NEW PUZZLE')),
              ),
              const SizedBox(height: 60),
            ],
          ),
        ),
      ),
    );
  }
}

// ================= NUMBER MEMORY GAME (NES style) =================
class NumberMemoryGame extends StatefulWidget {
  const NumberMemoryGame({super.key});

  @override
  State<NumberMemoryGame> createState() => _NumberMemoryGameState();
}

class _NumberMemoryGameState extends State<NumberMemoryGame> {
  List<int> _sequence = [];
  int _level = 0;
  bool _showingSequence = false;
  List<int> _userInput = [];
  String _feedback = '';
  bool _gameOver = false;

  @override
  void initState() {
    super.initState();
    _nextLevel();
  }

  void _nextLevel() {
    _level++;
    _sequence = List.generate(_level + 2, (_) => Random().nextInt(9) + 1);
    _userInput = [];
    _showingSequence = true;
    _feedback = 'Memorize the numbers!';
    
    Future.delayed(Duration(milliseconds: 800 * _sequence.length), () {
      if (mounted) setState(() => _showingSequence = false);
    });
  }

  void _onNumberTap(int num) {
    if (_showingSequence || _gameOver) return;
    
    _userInput.add(num);
    final idx = _userInput.length - 1;
    
    if (_userInput[idx] != _sequence[idx]) {
      setState(() { _gameOver = true; _feedback = 'Game Over! Level: $_level'; });
      return;
    }
    
    if (_userInput.length == _sequence.length) {
      setState(() => _feedback = 'Correct!');
      Future.delayed(const Duration(milliseconds: 800), () {
        if (mounted) _nextLevel();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgLight,
      body: AmbientBackground(
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
                child: Row(
                  children: [
                    NesButton(type: NesButtonType.normal, onPressed: () => Navigator.of(context).pop(), child: const Icon(CupertinoIcons.chevron_left, color: Colors.black, size: 20)),
                    const SizedBox(width: 8),
                    Text('NUMBER MEMORY', style: headingStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                    const Spacer(),
                    Text('Level: $_level', style: bodyStyle(fontSize: 10, color: accent, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              const Spacer(),
              Text(_feedback, style: bodyStyle(fontSize: 12, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              if (_showingSequence)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: _sequence.map((n) => Padding(
                    padding: const EdgeInsets.all(3),
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(color: primary, border: Border.all(color: Colors.white, width: 1)),
                      child: Center(child: Text('$n', style: headingStyle(fontSize: 18, fontWeight: FontWeight.bold))),
                    ),
                  )).toList(),
                )
              else
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: List.generate(9, (i) => GestureDetector(
                    onTap: () => _onNumberTap(i + 1),
                    child: Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(color: surface, border: Border.all(color: Colors.white10, width: 2)),
                      child: Center(child: Text('${i + 1}', style: headingStyle(fontSize: 20, fontWeight: FontWeight.bold))),
                    ),
                  )),
                ),
              const Spacer(),
              if (_gameOver)
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: NesButton(type: NesButtonType.primary, onPressed: () => setState(() { _level = 0; _gameOver = false; _nextLevel(); }), child: const Text('PLAY AGAIN')),
                ),
              const SizedBox(height: 60),
            ],
          ),
        ),
      ),
    );
  }
}

// ================= COLOR CATCH GAME (NES style) =================
class ColorCatchGame extends StatefulWidget {
  const ColorCatchGame({super.key});

  @override
  State<ColorCatchGame> createState() => _ColorCatchGameState();
}

class _ColorCatchGameState extends State<ColorCatchGame> {
  final List<Color> _colors = [accent, primary, const Color(0xff92cc41), const Color(0xfff7d51d)];
  int _targetColor = 0;
  double _ballX = 150;
  double _ballY = 0;
  int _score = 0;
  int _timeLeft = 30;
  Timer? _timer;
  Timer? _gameTimer;
  bool _started = false;

  @override
  void initState() {
    super.initState();
  }

  void _startGame() {
    setState(() { _score = 0; _timeLeft = 30; _started = true; _targetColor = Random().nextInt(4); });
    
    _timer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
      if (mounted) setState(() {
        _ballY += 8;
        if (_ballY > 600) { _ballY = 0; _ballX = Random().nextDouble() * 300 + 20; _targetColor = Random().nextInt(4); }
      });
    });
    
    _gameTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() { _timeLeft--; if (_timeLeft <= 0) _endGame(); });
    });
  }

  void _endGame() {
    _timer?.cancel(); _gameTimer?.cancel();
    setState(() => _started = false);
  }

  void _catchBall(int colorIndex) {
    if (!_started) return;
    setState(() {
      if (colorIndex == _targetColor) { _score += 10; _ballY = 0; _ballX = Random().nextDouble() * 300 + 20; _targetColor = Random().nextInt(4); }
      else { _score = (_score - 5).clamp(0, 9999); }
    });
  }

  @override
  void dispose() { _timer?.cancel(); _gameTimer?.cancel(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgLight,
      body: AmbientBackground(
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
                child: Row(
                  children: [
                    NesButton(type: NesButtonType.normal, onPressed: () => Navigator.of(context).pop(), child: const Icon(CupertinoIcons.chevron_left, color: Colors.black, size: 20)),
                    const SizedBox(width: 8),
                    Text('COLOR CATCH', style: headingStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                    const Spacer(),
                    Text('$_score pts', style: bodyStyle(fontSize: 10, color: primary, fontWeight: FontWeight.bold)),
                    const SizedBox(width: 12),
                    Text('$_timeLeft s', style: bodyStyle(fontSize: 10, color: _timeLeft < 10 ? accent : Colors.white)),
                  ],
                ),
              ),
              if (_started) ...[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text('Catch the ${_colors[_targetColor].toString().split('.').last} ball!', style: bodyStyle(fontSize: 10, color: _colors[_targetColor], fontWeight: FontWeight.bold)),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: Stack(
                    children: [
                      Positioned(
                        left: _ballX,
                        top: _ballY,
                        child: Container(width: 36, height: 36, decoration: BoxDecoration(color: _colors[_targetColor], border: Border.all(color: Colors.white, width: 2))),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(4, (i) => GestureDetector(
                      onTap: () => _catchBall(i),
                      child: Container(width: 60, height: 60, decoration: BoxDecoration(color: _colors[i], border: Border.all(color: Colors.white, width: 2))),
                    )),
                  ),
                ),
              ] else ...[
                const Spacer(),
                if (_score > 0) Text('Final Score: $_score', style: headingStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 20),
                NesButton(type: NesButtonType.primary, onPressed: _startGame, child: const Text('START GAME')),
                const Spacer(),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

// ================= WORD CHAIN GAME (NES style) =================
class WordChainGame extends StatefulWidget {
  const WordChainGame({super.key});

  @override
  State<WordChainGame> createState() => _WordChainGameState();
}

class _WordChainGameState extends State<WordChainGame> {
  final List<String> _words = ['sleep', 'peace', 'earth', 'heart', 'tiger', 'river', 'night', 'light', 'think', 'knife', 'elf', 'fly', 'yellow', 'wall'];
  String _currentWord = '';
  List<String> _chain = [];
  final TextEditingController _controller = TextEditingController();
  String _feedback = '';
  int _score = 0;

  @override
  void initState() {
    super.initState();
    _currentWord = _words[Random().nextInt(_words.length)];
    _chain = [_currentWord];
  }

  void _submitWord() {
    final word = _controller.text.toLowerCase().trim();
    if (word.isEmpty) return;
    
    if (word[0] != _currentWord[_currentWord.length - 1]) {
      setState(() => _feedback = 'Must start with "${_currentWord[_currentWord.length - 1]}"');
      return;
    }
    
    if (_chain.contains(word)) {
      setState(() => _feedback = 'Already used!');
      return;
    }
    
    setState(() { _chain.add(word); _currentWord = word; _score += word.length; _feedback = ''; _controller.clear(); });
  }

  @override
  void dispose() { _controller.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgLight,
      body: AmbientBackground(
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
                child: Row(
                  children: [
                    NesButton(type: NesButtonType.normal, onPressed: () => Navigator.of(context).pop(), child: const Icon(CupertinoIcons.chevron_left, color: Colors.black, size: 20)),
                    const SizedBox(width: 8),
                    Text('WORD CHAIN', style: headingStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                    const Spacer(),
                    Text('Score: $_score', style: bodyStyle(fontSize: 10, color: const Color(0xff92cc41), fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Text('Last letter: ${_currentWord[_currentWord.length - 1].toUpperCase()}', style: bodyStyle(fontSize: 12, color: const Color(0xfff7d51d), fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Text('Current word:', style: bodyStyle(fontSize: 8, color: textMid)),
              Text(_currentWord.toUpperCase(), style: headingStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              if (_feedback.isNotEmpty) Text(_feedback, style: bodyStyle(color: accent, fontSize: 10, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: TextField(
                  controller: _controller,
                  onSubmitted: (_) => _submitWord(),
                  decoration: const InputDecoration(labelText: 'Enter a word...', border: InputBorder.none),
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 14),
                ),
              ),
              const SizedBox(height: 10),
              NesButton(type: NesButtonType.primary, onPressed: _submitWord, child: const Text('SUBMIT')),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  itemCount: _chain.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Text('${_chain.length - index}. ${_chain[_chain.length - 1 - index]}', style: bodyStyle(fontSize: 10, color: index == 0 ? Colors.white : textMid, fontWeight: index == 0 ? FontWeight.bold : FontWeight.normal)),
                    );
                  },
                ),
              ),
              const SizedBox(height: 60),
            ],
          ),
        ),
      ),
    );
  }
}

// ================= RAPID TAP GAME (NES style) =================
class RapidTapGame extends StatefulWidget {
  const RapidTapGame({super.key});

  @override
  State<RapidTapGame> createState() => _RapidTapGameState();
}

class _RapidTapGameState extends State<RapidTapGame> {
  int _taps = 0;
  int _timeLeft = 10;
  bool _started = false;
  Timer? _timer;

  void _startGame() {
    setState(() { _taps = 0; _timeLeft = 10; _started = true; });
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() { _timeLeft--; if (_timeLeft <= 0) { _timer?.cancel(); _started = false; } });
    });
  }

  void _onTap() {
    if (!_started) return;
    setState(() => _taps++);
  }

  @override
  void dispose() { _timer?.cancel(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _onTap,
      child: Scaffold(
        backgroundColor: bgLight,
        body: AmbientBackground(
          child: SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
                  child: Row(
                    children: [
                      NesButton(type: NesButtonType.normal, onPressed: () => Navigator.of(context).pop(), child: const Icon(CupertinoIcons.chevron_left, color: Colors.black, size: 20)),
                      const SizedBox(width: 8),
                      Text('RAPID TAP', style: headingStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                      const Spacer(),
                      if (_started) Text('$_timeLeft s', style: bodyStyle(fontSize: 10, color: accent, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                const Spacer(),
                if (!_started && _taps == 0)
                  NesButton(type: NesButtonType.primary, onPressed: _startGame, child: const Text('START'))
                else ...[
                  Text('$_taps', style: headingStyle(fontSize: 48, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text(_started ? 'TAP ANYWHERE!' : 'Taps/sec: ${(_taps / 10).toStringAsFixed(1)}', style: bodyStyle(fontSize: 10, color: textMid)),
                  if (!_started) ...[
                    const SizedBox(height: 24),
                    NesButton(type: NesButtonType.primary, onPressed: () { setState(() { _taps = 0; }); _startGame(); }, child: const Text('PLAY AGAIN')),
                  ],
                ],
                const Spacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
