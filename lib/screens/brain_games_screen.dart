import 'dart:async';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
                    Text(
                      'Brain Games',
                      style: headingStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        color: textDark,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: Colors.amber.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          const Icon(CupertinoIcons.bolt_fill, color: Colors.amber, size: 14),
                          const SizedBox(width: 4),
                          Text(
                            'Train Mind',
                            style: bodyStyle(color: Colors.amber, fontSize: 11, fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
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
                    _buildGameCard(
                      title: 'Memory Match',
                      subtitle: 'Find matching pairs',
                      icon: CupertinoIcons.square_grid_2x2,
                      color: Colors.purple,
                      onTap: () => _navigateToGame(const MemoryMatchGame()),
                    ),
                    const SizedBox(height: 12),
                    _buildGameCard(
                      title: 'Color Reaction',
                      subtitle: 'Test your reflexes',
                      icon: CupertinoIcons.paintbrush,
                      color: Colors.red,
                      onTap: () => _navigateToGame(const ColorReactionGame()),
                    ),
                    const SizedBox(height: 12),
                    _buildGameCard(
                      title: 'Word Scramble',
                      subtitle: 'Unscramble the letters',
                      icon: CupertinoIcons.textformat_abc,
                      color: Colors.green,
                      onTap: () => _navigateToGame(const WordScrambleGame()),
                    ),
                    const SizedBox(height: 12),
                    _buildGameCard(
                      title: 'Math Challenge',
                      subtitle: 'Quick mental math',
                      icon: CupertinoIcons.sum,
                      color: Colors.orange,
                      onTap: () => _navigateToGame(const MathChallengeGame()),
                    ),
                    const SizedBox(height: 12),
                    _buildGameCard(
                      title: 'Simon Says',
                      subtitle: 'Repeat the pattern',
                      icon: CupertinoIcons.play_circle_fill,
                      color: Colors.teal,
                      onTap: () => _navigateToGame(const SimonSaysGame()),
                    ),
                    const SizedBox(height: 12),
                    _buildGameCard(
                      title: 'Tic Tac Toe',
                      subtitle: 'Classic strategy game',
                      icon: CupertinoIcons.xmark,
                      color: Colors.pink,
                      onTap: () => _navigateToGame(const TicTacToeGame()),
                    ),
                    const SizedBox(height: 12),
                    _buildGameCard(
                      title: 'Bubble Pop',
                      subtitle: 'Tap targets quickly',
                      icon: CupertinoIcons.circle_grid_3x3,
                      color: Colors.cyan,
                      onTap: () => _navigateToGame(const BubblePopGame()),
                    ),
                    const SizedBox(height: 12),
                    _buildGameCard(
                      title: 'Typing Speed',
                      subtitle: 'Type words fast',
                      icon: CupertinoIcons.keyboard,
                      color: Colors.indigo,
                      onTap: () => _navigateToGame(const TypingSpeedGame()),
                    ),
                    const SizedBox(height: 12),
                    _buildGameCard(
                      title: 'Puzzle Slide',
                      subtitle: 'Arrange numbers 1-15',
                      icon: CupertinoIcons.square_grid_2x2,
                      color: Colors.brown,
                      onTap: () => _navigateToGame(const PuzzleSlideGame()),
                    ),
                    const SizedBox(height: 12),
                    _buildGameCard(
                      title: 'Number Memory',
                      subtitle: 'Remember the sequence',
                      icon: CupertinoIcons.eye_fill,
                      color: Colors.deepPurple,
                      onTap: () => _navigateToGame(const NumberMemoryGame()),
                    ),
                    const SizedBox(height: 12),
                    _buildGameCard(
                      title: 'Color Catch',
                      subtitle: 'Catch falling colors',
                      icon: CupertinoIcons.arrow_down_circle_fill,
                      color: Colors.tealAccent,
                      onTap: () => _navigateToGame(const ColorCatchGame()),
                    ),
                    const SizedBox(height: 12),
                    _buildGameCard(
                      title: 'Word Chain',
                      subtitle: 'Connect the words',
                      icon: CupertinoIcons.link,
                      color: Colors.lightBlue,
                      onTap: () => _navigateToGame(const WordChainGame()),
                    ),
                    const SizedBox(height: 12),
                    _buildGameCard(
                      title: 'Rapid Tap',
                      subtitle: 'Tap as fast as you can',
                      icon: CupertinoIcons.hand_raised_fill,
                      color: Colors.redAccent,
                      onTap: () => _navigateToGame(const RapidTapGame()),
                    ),
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
      CupertinoPageRoute(builder: (context) => game),
    );
  }

  Widget _buildGameCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: glassCard(
        padding: const EdgeInsets.all(18),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [color, color.withValues(alpha: 0.7)],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(icon, color: Colors.white, size: 26),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: headingStyle(fontSize: 17, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: bodyStyle(color: textMid, fontSize: 13, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
            Icon(CupertinoIcons.chevron_right, color: textMid, size: 18),
          ],
        ),
      ),
    );
  }
}

// ================= MEMORY MATCH GAME =================
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
                    CupertinoButton(
                      padding: EdgeInsets.zero,
                      minimumSize: const Size(44, 44),
                      onPressed: () => Navigator.of(context).pop(),
                      child: Icon(CupertinoIcons.chevron_left, color: textDark, size: 28),
                    ),
                    Text('Memory Match', style: headingStyle(fontSize: 20, fontWeight: FontWeight.w700)),
                    const Spacer(),
                    Text('Moves: $_moves', style: bodyStyle(color: textMid, fontSize: 14)),
                  ],
                ),
              ),
              if (_gameComplete)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: glassCard(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(CupertinoIcons.star_fill, color: Colors.amber, size: 24),
                        const SizedBox(width: 8),
                        Text('Completed in $_moves moves!', style: headingStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                      ],
                    ),
                  ),
                ),
              const SizedBox(height: 12),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                    ),
                    itemCount: 16,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () => _onTileTap(index),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          decoration: BoxDecoration(
                            color: _matched[index]
                                ? Colors.green.withValues(alpha: 0.3)
                                : _revealed[index]
                                    ? surface
                                    : primary.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: _matched[index]
                                  ? Colors.green
                                  : _revealed[index]
                                      ? Colors.white24
                                      : Colors.white10,
                            ),
                          ),
                          child: Center(
                            child: _revealed[index] || _matched[index]
                                ? Text(
                                    _symbols[index],
                                    style: const TextStyle(fontSize: 28),
                                  )
                                : Icon(CupertinoIcons.question, color: textMid, size: 24),
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
                  child: CupertinoButton(
                    padding: EdgeInsets.zero,
                    onPressed: () => setState(() => _initGame()),
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(colors: [primary, accent]),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Center(
                        child: Text('Play Again', style: bodyStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700)),
                      ),
                    ),
                  ),
                ),
              SizedBox(height: 80 + MediaQuery.of(context).padding.bottom),
            ],
          ),
        ),
      ),
    );
  }
}

// ================= NUMBER SEQUENCE GAME =================
class NumberSequenceGame extends StatefulWidget {
  const NumberSequenceGame({super.key});

  @override
  State<NumberSequenceGame> createState() => _NumberSequenceGameState();
}

class _NumberSequenceGameState extends State<NumberSequenceGame> {
  final List<int> _sequence = [];
  List<int> _options = [];
  int _correctAnswer = 0;
  int _score = 0;
  String _feedback = '';

  @override
  void initState() {
    super.initState();
    _generateSequence();
  }

  void _generateSequence() {
    final random = Random();
    final patternType = random.nextInt(3);
    
    _sequence.clear();
    int start = random.nextInt(5) + 1;
    
    if (patternType == 0) {
      // Addition pattern (+2, +3, etc.)
      final increment = random.nextInt(3) + 2;
      for (int i = 0; i < 4; i++) {
        _sequence.add(start + increment * i);
      }
      _correctAnswer = start + increment * 4;
    } else if (patternType == 1) {
      // Multiplication pattern (x2, x3, etc.)
      final multiplier = random.nextInt(2) + 2;
      int val = start;
      for (int i = 0; i < 4; i++) {
        _sequence.add(val);
        val *= multiplier;
      }
      _correctAnswer = val;
    } else {
      // Square pattern
      for (int i = 1; i <= 4; i++) {
        _sequence.add(i * i + start);
      }
      _correctAnswer = 25 + start;
    }
    
    // Generate options
    _options = [_correctAnswer];
    while (_options.length < 4) {
      final wrong = _correctAnswer + random.nextInt(10) - 5;
      if (wrong != _correctAnswer && !_options.contains(wrong) && wrong > 0) {
        _options.add(wrong);
      }
    }
    _options.shuffle();
    _feedback = '';
  }

  void _checkAnswer(int answer) {
    setState(() {
      if (answer == _correctAnswer) {
        _score += 10;
        _feedback = 'Correct!';
      } else {
        _feedback = 'Wrong! Answer: $_correctAnswer';
      }
      Future.delayed(const Duration(seconds: 1), () {
        if (mounted) _generateSequence();
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
                    CupertinoButton(
                      padding: EdgeInsets.zero,
                      minimumSize: const Size(44, 44),
                      onPressed: () => Navigator.of(context).pop(),
                      child: Icon(CupertinoIcons.chevron_left, color: textDark, size: 28),
                    ),
                    Text('Number Sequence', style: headingStyle(fontSize: 20, fontWeight: FontWeight.w700)),
                    const Spacer(),
                    Text('Score: $_score', style: bodyStyle(color: Colors.amber, fontSize: 14, fontWeight: FontWeight.w700)),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              Text('What comes next?', style: bodyStyle(color: textMid, fontSize: 16)),
              const SizedBox(height: 20),
              Wrap(
                spacing: 12,
                children: _sequence.map((n) => Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white10),
                  ),
                  child: Center(
                    child: Text('$n', style: headingStyle(fontSize: 24, fontWeight: FontWeight.w700)),
                  ),
                )).toList(),
              ),
              const SizedBox(height: 12),
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: primary.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: primary),
                ),
                child: Center(
                  child: Text('?', style: headingStyle(fontSize: 28, fontWeight: FontWeight.w700, color: primary)),
                ),
              ),
              const SizedBox(height: 30),
              if (_feedback.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Text(_feedback, style: bodyStyle(
                    color: _feedback.contains('Correct') ? Colors.green : Colors.red,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  )),
                ),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: _options.map((opt) => GestureDetector(
                  onTap: () => _checkAnswer(opt),
                  child: Container(
                    width: 80,
                    height: 50,
                    decoration: BoxDecoration(
                      color: surface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.white10),
                    ),
                    child: Center(
                      child: Text('$opt', style: headingStyle(fontSize: 20, fontWeight: FontWeight.w600)),
                    ),
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

// ================= COLOR REACTION GAME =================
class ColorReactionGame extends StatefulWidget {
  const ColorReactionGame({super.key});

  @override
  State<ColorReactionGame> createState() => _ColorReactionGameState();
}

class _ColorReactionGameState extends State<ColorReactionGame> {
  Color _backgroundColor = Colors.grey;
  String _text = 'Tap when GREEN';
  bool _waiting = false;
  bool _started = false;
  DateTime? _startTime;
  int _bestTime = 999;
  int _attempts = 0;

  void _startGame() {
    setState(() {
      _backgroundColor = Colors.red;
      _text = 'Wait for green...';
      _waiting = true;
      _started = false;
    });
    
    final random = Random();
    final delay = 1500 + random.nextInt(3000);
    
    Future.delayed(Duration(milliseconds: delay), () {
      if (mounted && _waiting) {
        setState(() {
          _backgroundColor = Colors.green;
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
        _backgroundColor = Colors.grey;
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
        _backgroundColor = Colors.orange;
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
                    CupertinoButton(
                      padding: EdgeInsets.zero,
                      minimumSize: const Size(44, 44),
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Icon(CupertinoIcons.chevron_left, color: Colors.white, size: 28),
                    ),
                    Text('Color Reaction', style: headingStyle(fontSize: 20, fontWeight: FontWeight.w700, color: Colors.white)),
                    const Spacer(),
                    if (_bestTime < 999)
                      Text('Best: ${_bestTime}ms', style: bodyStyle(color: Colors.white, fontSize: 14)),
                  ],
                ),
              ),
              const Spacer(),
              Center(
                child: Column(
                  children: [
                    Text(_text, style: headingStyle(fontSize: 28, fontWeight: FontWeight.w800, color: Colors.white)),
                    const SizedBox(height: 16),
                    Text('Attempts: $_attempts', style: bodyStyle(color: Colors.white70, fontSize: 14)),
                  ],
                ),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}

// ================= WORD SCRAMBLE GAME =================
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
        _feedback = 'Correct!';
        Future.delayed(const Duration(seconds: 1), () {
          if (mounted) {
            setState(() => _nextWord());
          }
        });
      } else {
        _feedback = 'Try again!';
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
                    CupertinoButton(
                      padding: EdgeInsets.zero,
                      minimumSize: const Size(44, 44),
                      onPressed: () => Navigator.of(context).pop(),
                      child: Icon(CupertinoIcons.chevron_left, color: textDark, size: 28),
                    ),
                    Text('Word Scramble', style: headingStyle(fontSize: 20, fontWeight: FontWeight.w700)),
                    const Spacer(),
                    Text('Score: $_score', style: bodyStyle(color: Colors.green, fontSize: 14, fontWeight: FontWeight.w700)),
                  ],
                ),
              ),
              const SizedBox(height: 60),
              Text('Unscramble the word:', style: bodyStyle(color: textMid, fontSize: 16)),
              const SizedBox(height: 20),
              Text(
                _scrambled,
                style: headingStyle(fontSize: 40, fontWeight: FontWeight.w800, color: Colors.white),
              ),
              const SizedBox(height: 40),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: CupertinoTextField(
                  controller: _controller,
                  placeholder: 'Type your answer',
                  placeholderStyle: bodyStyle(color: textMid),
                  style: bodyStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  textAlign: TextAlign.center,
                  decoration: BoxDecoration(
                    color: surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white10),
                  ),
                  padding: const EdgeInsets.all(16),
                  onSubmitted: (_) => _checkAnswer(),
                ),
              ),
              const SizedBox(height: 20),
              if (_feedback.isNotEmpty)
                Text(_feedback, style: bodyStyle(
                  color: _feedback == 'Correct!' ? Colors.green : Colors.red,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                )),
              const SizedBox(height: 20),
              CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed: _checkAnswer,
                child: Container(
                  width: 200,
                  height: 50,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [primary, accent]),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Center(
                    child: Text('Submit', style: bodyStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ================= MATH CHALLENGE GAME =================
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
        _feedback = _streak >= 3 ? '🔥 $_streak Streak!' : 'Correct!';
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
                    CupertinoButton(
                      padding: EdgeInsets.zero,
                      minimumSize: const Size(44, 44),
                      onPressed: () => Navigator.of(context).pop(),
                      child: Icon(CupertinoIcons.chevron_left, color: textDark, size: 28),
                    ),
                    Text('Math Challenge', style: headingStyle(fontSize: 20, fontWeight: FontWeight.w700)),
                    const Spacer(),
                    Text('Score: $_score', style: bodyStyle(color: Colors.orange, fontSize: 14, fontWeight: FontWeight.w700)),
                  ],
                ),
              ),
              const SizedBox(height: 60),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('$_num1', style: headingStyle(fontSize: 48, fontWeight: FontWeight.w800)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(_operator, style: headingStyle(fontSize: 40, fontWeight: FontWeight.w600, color: primary)),
                  ),
                  Text('$_num2', style: headingStyle(fontSize: 48, fontWeight: FontWeight.w800)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text('=', style: headingStyle(fontSize: 40, fontWeight: FontWeight.w600, color: textMid)),
                  ),
                  Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      color: surface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.white10),
                    ),
                    child: Center(
                      child: Text('?', style: headingStyle(fontSize: 32, fontWeight: FontWeight.w700, color: textMid)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),
              if (_feedback.isNotEmpty)
                Text(_feedback, style: bodyStyle(
                  color: _feedback.contains('Correct') || _feedback.contains('Streak') ? Colors.green : Colors.red,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                )),
              const SizedBox(height: 30),
              Wrap(
                spacing: 16,
                runSpacing: 16,
                children: _options.map((opt) => GestureDetector(
                  onTap: () => _checkAnswer(opt),
                  child: Container(
                    width: 80,
                    height: 60,
                    decoration: BoxDecoration(
                      color: surface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.white10),
                    ),
                    child: Center(
                       child: Text('$opt', style: headingStyle(fontSize: 24, fontWeight: FontWeight.w700)),
                    ),
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

// ================= SIMON SAYS GAME =================
class SimonSaysGame extends StatefulWidget {
  const SimonSaysGame({super.key});

  @override
  State<SimonSaysGame> createState() => _SimonSaysGameState();
}

class _SimonSaysGameState extends State<SimonSaysGame> {
  final List<Color> _colors = [Colors.red, Colors.blue, Colors.green, Colors.yellow];
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
      if (mounted) {
        setState(() {
          _showingSequence = false;
          _feedback = 'Your turn!';
        });
      }
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
      setState(() {
        _gameOver = true;
        _feedback = 'Game Over! Level: $_level';
      });
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
                    CupertinoButton(
                      padding: EdgeInsets.zero,
                      minimumSize: const Size(44, 44),
                      onPressed: () => Navigator.of(context).pop(),
                      child: Icon(CupertinoIcons.chevron_left, color: textDark, size: 28),
                    ),
                    Text('Simon Says', style: headingStyle(fontSize: 20, fontWeight: FontWeight.w700)),
                    const Spacer(),
                    Text('Level: $_level', style: bodyStyle(color: Colors.teal, fontSize: 14, fontWeight: FontWeight.w700)),
                  ],
                ),
              ),
              const Spacer(),
              Text(_feedback, style: bodyStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600)),
              const SizedBox(height: 40),
              SizedBox(
                width: 250,
                height: 250,
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                  ),
                  itemCount: 4,
                  itemBuilder: (context, index) {
                    final isActive = _activeColor == index;
                    return GestureDetector(
                      onTap: () => _onColorTap(index),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 150),
                        decoration: BoxDecoration(
                          color: isActive ? _colors[index] : _colors[index].withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isActive ? Colors.white : Colors.white24,
                            width: isActive ? 3 : 1,
                          ),
                          boxShadow: isActive ? [
                            BoxShadow(color: _colors[index], blurRadius: 20, spreadRadius: 5),
                          ] : [],
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
                  child: CupertinoButton(
                    padding: EdgeInsets.zero,
                    onPressed: () => setState(() => _startGame()),
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(colors: [primary, accent]),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Center(
                        child: Text('Play Again', style: bodyStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700)),
                      ),
                    ),
                  ),
                ),
              SizedBox(height: 80 + MediaQuery.of(context).padding.bottom),
            ],
          ),
        ),
      ),
    );
  }
}

// ================= TIC TAC TOE GAME =================
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
      if (_board[pattern[0]] != '' &&
          _board[pattern[0]] == _board[pattern[1]] &&
          _board[pattern[0]] == _board[pattern[2]]) {
        setState(() => _winner = _board[pattern[0]]);
        return;
      }
    }
    
    if (!_board.contains('')) {
      setState(() => _isDraw = true);
    }
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
                    CupertinoButton(
                      padding: EdgeInsets.zero,
                      minimumSize: const Size(44, 44),
                      onPressed: () => Navigator.of(context).pop(),
                      child: Icon(CupertinoIcons.chevron_left, color: textDark, size: 28),
                    ),
                    Text('Tic Tac Toe', style: headingStyle(fontSize: 20, fontWeight: FontWeight.w700)),
                    const Spacer(),
                    Icon(_isXTurn ? CupertinoIcons.xmark : CupertinoIcons.circle, color: primary, size: 24),
                  ],
                ),
              ),
              const Spacer(),
              if (_winner.isNotEmpty)
                Text('$_winner Wins!', style: headingStyle(fontSize: 28, fontWeight: FontWeight.w800, color: Colors.green))
              else if (_isDraw)
                Text('Draw!', style: headingStyle(fontSize: 28, fontWeight: FontWeight.w800, color: Colors.orange))
              else
                Text('${_isXTurn ? "X" : "O"} Turn', style: bodyStyle(color: textMid, fontSize: 18)),
              const SizedBox(height: 30),
              SizedBox(
                width: 280,
                height: 280,
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                  ),
                  itemCount: 9,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () => _onTap(index),
                      child: Container(
                        decoration: BoxDecoration(
                          color: surface,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.white10),
                        ),
                        child: Center(
                          child: Text(
                            _board[index],
                            style: headingStyle(
                              fontSize: 36,
                              fontWeight: FontWeight.w800,
                              color: _board[index] == 'X' ? Colors.cyan : Colors.pink,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.all(20),
                child: CupertinoButton(
                  padding: EdgeInsets.zero,
                  onPressed: _reset,
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [primary, accent]),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Center(
                      child: Text('New Game', style: bodyStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700)),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 80 + MediaQuery.of(context).padding.bottom),
            ],
          ),
        ),
      ),
    );
  }
}

// ================= BUBBLE POP GAME =================
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
    setState(() {
      _score = 0;
      _timeLeft = 30;
      _bubbles = [];
      _gameStarted = true;
    });
    
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _timeLeft--;
        if (_timeLeft <= 0) {
          _endGame();
        }
      });
    });
    
    _spawnTimer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      if (mounted) {
        setState(() {
          _bubbles.add(_Bubble.random());
        });
        _bubbles.removeWhere((b) => b.life <= 0);
      }
    });
  }

  void _endGame() {
    _timer?.cancel();
    _spawnTimer?.cancel();
    setState(() => _gameStarted = false);
  }

  void _popBubble(_Bubble bubble) {
    setState(() {
      _bubbles.remove(bubble);
      _score += bubble.points;
    });
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
                        CupertinoButton(
                          padding: EdgeInsets.zero,
                          minimumSize: const Size(44, 44),
                          onPressed: () => Navigator.of(context).pop(),
                          child: Icon(CupertinoIcons.chevron_left, color: textDark, size: 28),
                        ),
                        Text('Bubble Pop', style: headingStyle(fontSize: 20, fontWeight: FontWeight.w700)),
                        const Spacer(),
                        Text('$_score pts', style: bodyStyle(color: Colors.cyan, fontSize: 14, fontWeight: FontWeight.w700)),
                        const SizedBox(width: 16),
                        Text('$_timeLeft s', style: bodyStyle(color: _timeLeft < 10 ? Colors.red : Colors.white, fontSize: 14, fontWeight: FontWeight.w700)),
                      ],
                    ),
                  ),
                  if (!_gameStarted)
                    Expanded(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (_score > 0)
                              Text('Score: $_score', style: headingStyle(fontSize: 32, fontWeight: FontWeight.w800)),
                            const SizedBox(height: 20),
                            CupertinoButton(
                              padding: EdgeInsets.zero,
                              onPressed: _startGame,
                              child: Container(
                                width: 200,
                                height: 60,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(colors: [primary, accent]),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Center(
                                  child: Text('Start Game', style: bodyStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700)),
                                ),
                              ),
                            ),
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
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: [
                              bubble.color.withValues(alpha: 0.8),
                              bubble.color.withValues(alpha: 0.4),
                            ],
                          ),
                        ),
                        child: Center(
                          child: Text(
                            '${bubble.points}',
                            style: bodyStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w700),
                          ),
                        ),
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

  _Bubble({
    required this.x,
    required this.y,
    required this.radius,
    required this.color,
    required this.points,
    required this.life,
  });

  factory _Bubble.random() {
    final random = Random();
    final colors = [Colors.cyan, Colors.pink, Colors.amber, Colors.purple, Colors.green];
    return _Bubble(
      x: random.nextDouble() * 300 + 40,
      y: random.nextDouble() * 500 + 100,
      radius: 20 + random.nextDouble() * 20,
      color: colors[random.nextInt(colors.length)],
      points: random.nextInt(3) + 1,
      life: 3,
    );
  }
}

// ================= TYPING SPEED GAME =================
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
    setState(() {
      _score = 0;
      _timeLeft = 30;
      _started = true;
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _timeLeft--;
        if (_timeLeft <= 0) {
          _timer?.cancel();
          _started = false;
        }
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
      if (value == _currentWord) {
        _score += _currentWord.length * 2;
        _nextWord();
      }
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
                    CupertinoButton(
                      padding: EdgeInsets.zero,
                      minimumSize: const Size(44, 44),
                      onPressed: () => Navigator.of(context).pop(),
                      child: Icon(CupertinoIcons.chevron_left, color: textDark, size: 28),
                    ),
                    Text('Typing Speed', style: headingStyle(fontSize: 20, fontWeight: FontWeight.w700)),
                    const Spacer(),
                    Text('$_score pts', style: bodyStyle(color: Colors.indigo, fontSize: 14, fontWeight: FontWeight.w700)),
                    const SizedBox(width: 16),
                    Text('$_timeLeft s', style: bodyStyle(color: _timeLeft < 10 ? Colors.red : Colors.white, fontSize: 14)),
                  ],
                ),
              ),
              const Spacer(),
              if (!_started)
                CupertinoButton(
                  padding: EdgeInsets.zero,
                  onPressed: _startGame,
                  child: Container(
                    width: 200,
                    height: 60,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [primary, accent]),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                      child: Text('Start', style: bodyStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700)),
                    ),
                  ),
                )
              else ...[
                Text('Type this word:', style: bodyStyle(color: textMid, fontSize: 16)),
                const SizedBox(height: 20),
                Text(
                  _currentWord,
                  style: headingStyle(fontSize: 40, fontWeight: FontWeight.w800, color: Colors.white),
                ),
                const SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: CupertinoTextField(
                    controller: _controller,
                    onChanged: _checkInput,
                    placeholder: 'Start typing...',
                    placeholderStyle: bodyStyle(color: textMid),
                    style: bodyStyle(fontSize: 24, fontWeight: FontWeight.w600),
                    textAlign: TextAlign.center,
                    autofocus: true,
                    decoration: BoxDecoration(
                      color: surface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.white10),
                    ),
                    padding: const EdgeInsets.all(16),
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

// ================= PUZZLE SLIDE GAME =================
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
      setState(() {
        _swapTiles(emptyIndex, index);
        _moves++;
        _checkSolved();
      });
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
                    CupertinoButton(
                      padding: EdgeInsets.zero,
                      minimumSize: const Size(44, 44),
                      onPressed: () => Navigator.of(context).pop(),
                      child: Icon(CupertinoIcons.chevron_left, color: textDark, size: 28),
                    ),
                    Text('Puzzle Slide', style: headingStyle(fontSize: 20, fontWeight: FontWeight.w700)),
                    const Spacer(),
                    Text('$_moves moves', style: bodyStyle(color: Colors.brown, fontSize: 14, fontWeight: FontWeight.w700)),
                  ],
                ),
              ),
              const Spacer(),
              if (_solved)
                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Text('Solved in $_moves moves!', style: headingStyle(fontSize: 20, fontWeight: FontWeight.w700, color: Colors.green)),
                ),
              SizedBox(
                width: 280,
                height: 280,
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    mainAxisSpacing: 4,
                    crossAxisSpacing: 4,
                  ),
                  itemCount: 16,
                  itemBuilder: (context, index) {
                    final value = _tiles[index];
                    if (value == 0) return const SizedBox();
                    
                    return GestureDetector(
                      onTap: () => _onTileTap(index),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 150),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [primary, accent],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Text(
                            '$value',
                            style: headingStyle(fontSize: 24, fontWeight: FontWeight.w700, color: Colors.white),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.all(20),
                child: CupertinoButton(
                  padding: EdgeInsets.zero,
                  onPressed: () => setState(() => _initPuzzle()),
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [primary, accent]),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Center(
                      child: Text('New Puzzle', style: bodyStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700)),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 80 + MediaQuery.of(context).padding.bottom),
            ],
          ),
        ),
      ),
    );
  }
}

// ================= QUIZ TRIVIA GAME =================
class QuizTriviaGame extends StatefulWidget {
  const QuizTriviaGame({super.key});

  @override
  State<QuizTriviaGame> createState() => _QuizTriviaGameState();
}

class _QuizTriviaGameState extends State<QuizTriviaGame> {
  final List<Map<String, dynamic>> _questions = [
    {'q': 'How many hours recommended for adults?', 'a': ['7-9', '5-6', '10-12', '4-5'], 'correct': 0},
    {'q': 'What hormone helps you sleep?', 'a': ['Melatonin', 'Adrenaline', 'Cortisol', 'Insulin'], 'correct': 0},
    {'q': 'How long is a sleep cycle?', 'a': ['90 min', '30 min', '60 min', '120 min'], 'correct': 0},
    {'q': 'Which sleep stage is deepest?', 'a': ['Deep', 'Light', 'REM', 'Awake'], 'correct': 0},
    {'q': 'What disrupts sleep most?', 'a': ['Blue light', 'Reading', 'Meditation', 'Exercise'], 'correct': 0},
    {'q': 'Best temperature for sleep?', 'a': ['65°F', '80°F', '50°F', '75°F'], 'correct': 0},
    {'q': 'How many sleep cycles per night?', 'a': ['4-6', '1-2', '8-10', '2-3'], 'correct': 0},
    {'q': 'What is REM sleep?', 'a': ['Rapid Eye Movement', 'Rest Every Morning', 'Random Eye Motion', 'Relaxed Eye State'], 'correct': 0},
  ];
  int _currentQuestion = 0;
  int _score = 0;
  String _feedback = '';
  bool _answered = false;

  void _answerQuestion(int index) {
    if (_answered) return;
    setState(() {
      _answered = true;
      if (index == _questions[_currentQuestion]['correct']) {
        _score += 10;
        _feedback = 'Correct!';
      } else {
        _feedback = 'Wrong!';
      }
    });
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          _currentQuestion++;
          _answered = false;
          _feedback = '';
          if (_currentQuestion >= _questions.length) _currentQuestion = 0;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final q = _questions[_currentQuestion];
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
                    CupertinoButton(
                      padding: EdgeInsets.zero,
                      minimumSize: const Size(44, 44),
                      onPressed: () => Navigator.of(context).pop(),
                      child: Icon(CupertinoIcons.chevron_left, color: textDark, size: 28),
                    ),
                    Text('Quiz Trivia', style: headingStyle(fontSize: 20, fontWeight: FontWeight.w700)),
                    const Spacer(),
                    Text('Score: $_score', style: bodyStyle(color: Colors.deepOrange, fontSize: 14, fontWeight: FontWeight.w700)),
                    const SizedBox(width: 8),
                    Text('${_currentQuestion + 1}/${_questions.length}', style: bodyStyle(color: textMid, fontSize: 14)),
                  ],
                ),
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Text(q['q'], style: headingStyle(fontSize: 22, fontWeight: FontWeight.w700), textAlign: TextAlign.center),
              ),
              const SizedBox(height: 30),
              if (_feedback.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Text(_feedback, style: bodyStyle(color: _feedback == 'Correct!' ? Colors.green : Colors.red, fontSize: 18, fontWeight: FontWeight.w700)),
                ),
              ...List.generate(4, (i) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 6),
                child: CupertinoButton(
                  padding: EdgeInsets.zero,
                  onPressed: () => _answerQuestion(i),
                  child: Container(
                    width: double.infinity,
                    height: 52,
                    decoration: BoxDecoration(
                      color: _answered && i == q['correct'] ? Colors.green.withValues(alpha: 0.3) : surface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: _answered && i == q['correct'] ? Colors.green : Colors.white10),
                    ),
                    child: Center(
                      child: Text(q['a'][i], style: bodyStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                    ),
                  ),
                ),
              )),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}

// ================= SHAPE MATCH GAME =================
class ShapeMatchGame extends StatefulWidget {
  const ShapeMatchGame({super.key});

  @override
  State<ShapeMatchGame> createState() => _ShapeMatchGameState();
}

class _ShapeMatchGameState extends State<ShapeMatchGame> {
  final List<Color> _colors = [Colors.red, Colors.blue, Colors.green, Colors.yellow, Colors.purple, Colors.orange];
  List<int> _shapes = [];
  int? _selected;
  int _matches = 0;
  int _moves = 0;

  @override
  void initState() {
    super.initState();
    _initGame();
  }

  void _initGame() {
    final pairs = List.generate(6, (i) => i)..toList();
    _shapes = [...pairs, ...pairs]..shuffle();
    _selected = null;
    _matches = 0;
    _moves = 0;
  }

  void _onTap(int index) {
    if (_shapes[index] == -1 || _selected == index) return;
    
    setState(() {
      _moves++;
      if (_selected == null) {
        _selected = index;
      } else {
        if (_shapes[_selected!] == _shapes[index]) {
          _shapes[_selected!] = -1;
          _shapes[index] = -1;
          _matches++;
        }
        _selected = null;
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
                    CupertinoButton(
                      padding: EdgeInsets.zero,
                      minimumSize: const Size(44, 44),
                      onPressed: () => Navigator.of(context).pop(),
                      child: Icon(CupertinoIcons.chevron_left, color: textDark, size: 28),
                    ),
                    Text('Shape Match', style: headingStyle(fontSize: 20, fontWeight: FontWeight.w700)),
                    const Spacer(),
                    Text('Moves: $_moves', style: bodyStyle(color: Colors.lime, fontSize: 14, fontWeight: FontWeight.w700)),
                  ],
                ),
              ),
              const Spacer(),
              if (_matches == 6)
                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Text('Completed in $_moves moves!', style: headingStyle(fontSize: 20, fontWeight: FontWeight.w700, color: Colors.green)),
                ),
              SizedBox(
                width: 300,
                height: 300,
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4, mainAxisSpacing: 8, crossAxisSpacing: 8),
                  itemCount: 12,
                  itemBuilder: (context, index) {
                    final shapeIndex = _shapes[index];
                    final isMatched = shapeIndex == -1;
                    final isSelected = _selected == index;
                    return GestureDetector(
                      onTap: () => _onTap(index),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        decoration: BoxDecoration(
                          color: isMatched ? Colors.transparent : isSelected ? _colors[shapeIndex].withValues(alpha: 0.5) : surface,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: isSelected ? _colors[shapeIndex] : Colors.white10, width: isSelected ? 2 : 1),
                        ),
                        child: isMatched ? null : Center(
                          child: Container(
                            width: 30,
                            height: 30,
                            decoration: BoxDecoration(color: _colors[shapeIndex], shape: BoxShape.circle),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.all(20),
                child: CupertinoButton(
                  padding: EdgeInsets.zero,
                  onPressed: () => setState(() => _initGame()),
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(gradient: LinearGradient(colors: [primary, accent]), borderRadius: BorderRadius.circular(16)),
                    child: Center(child: Text('New Game', style: bodyStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700))),
                  ),
                ),
              ),
              SizedBox(height: 80 + MediaQuery.of(context).padding.bottom),
            ],
          ),
        ),
      ),
    );
  }
}

// ================= NUMBER MEMORY GAME =================
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
      setState(() {
        _gameOver = true;
        _feedback = 'Game Over! Level: $_level';
      });
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
                    CupertinoButton(
                      padding: EdgeInsets.zero,
                      minimumSize: const Size(44, 44),
                      onPressed: () => Navigator.of(context).pop(),
                      child: Icon(CupertinoIcons.chevron_left, color: textDark, size: 28),
                    ),
                    Text('Number Memory', style: headingStyle(fontSize: 20, fontWeight: FontWeight.w700)),
                    const Spacer(),
                    Text('Level: $_level', style: bodyStyle(color: Colors.deepPurple, fontSize: 14, fontWeight: FontWeight.w700)),
                  ],
                ),
              ),
              const Spacer(),
              Text(_feedback, style: bodyStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
              const SizedBox(height: 20),
              if (_showingSequence)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: _sequence.map((n) => Padding(
                    padding: const EdgeInsets.all(4),
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(color: primary, borderRadius: BorderRadius.circular(8)),
                      child: Center(child: Text('$n', style: headingStyle(fontSize: 24, fontWeight: FontWeight.w700, color: Colors.white))),
                    ),
                  )).toList(),
                )
              else
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: List.generate(9, (i) => GestureDetector(
                    onTap: () => _onNumberTap(i + 1),
                    child: Container(
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(color: surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.white10)),
                      child: Center(child: Text('${i + 1}', style: headingStyle(fontSize: 24, fontWeight: FontWeight.w700))),
                    ),
                  )),
                ),
              const Spacer(),
              if (_gameOver)
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: CupertinoButton(
                    padding: EdgeInsets.zero,
                    onPressed: () => setState(() { _level = 0; _gameOver = false; _nextLevel(); }),
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(gradient: LinearGradient(colors: [primary, accent]), borderRadius: BorderRadius.circular(16)),
                      child: Center(child: Text('Play Again', style: bodyStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700))),
                    ),
                  ),
                ),
              SizedBox(height: 80 + MediaQuery.of(context).padding.bottom),
            ],
          ),
        ),
      ),
    );
  }
}

// ================= COLOR CATCH GAME =================
class ColorCatchGame extends StatefulWidget {
  const ColorCatchGame({super.key});

  @override
  State<ColorCatchGame> createState() => _ColorCatchGameState();
}

class _ColorCatchGameState extends State<ColorCatchGame> {
  final List<Color> _colors = [Colors.red, Colors.blue, Colors.green, Colors.yellow];
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
    setState(() {
      _score = 0;
      _timeLeft = 30;
      _started = true;
      _targetColor = Random().nextInt(4);
    });
    
    _timer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
      if (mounted) {
        setState(() {
          _ballY += 8;
          if (_ballY > 600) {
            _ballY = 0;
            _ballX = Random().nextDouble() * 300 + 20;
            _targetColor = Random().nextInt(4);
          }
        });
      }
    });
    
    _gameTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _timeLeft--;
        if (_timeLeft <= 0) _endGame();
      });
    });
  }

  void _endGame() {
    _timer?.cancel();
    _gameTimer?.cancel();
    setState(() => _started = false);
  }

  void _catchBall(int colorIndex) {
    if (!_started) return;
    setState(() {
      if (colorIndex == _targetColor) {
        _score += 10;
        _ballY = 0;
        _ballX = Random().nextDouble() * 300 + 20;
        _targetColor = Random().nextInt(4);
      } else {
        _score = (_score - 5).clamp(0, 9999);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _gameTimer?.cancel();
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
                    CupertinoButton(
                      padding: EdgeInsets.zero,
                      minimumSize: const Size(44, 44),
                      onPressed: () => Navigator.of(context).pop(),
                      child: Icon(CupertinoIcons.chevron_left, color: textDark, size: 28),
                    ),
                    Text('Color Catch', style: headingStyle(fontSize: 20, fontWeight: FontWeight.w700)),
                    const Spacer(),
                    Text('$_score pts', style: bodyStyle(color: Colors.tealAccent, fontSize: 14, fontWeight: FontWeight.w700)),
                    const SizedBox(width: 16),
                    Text('$_timeLeft s', style: bodyStyle(color: _timeLeft < 10 ? Colors.red : Colors.white, fontSize: 14)),
                  ],
                ),
              ),
              if (_started) ...[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text('Catch the ${_colors[_targetColor].toString().split('.').last} ball!', style: bodyStyle(color: _colors[_targetColor], fontSize: 16, fontWeight: FontWeight.w700)),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: Stack(
                    children: [
                      Positioned(
                        left: _ballX,
                        top: _ballY,
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(shape: BoxShape.circle, color: _colors[_targetColor]),
                        ),
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
                      child: Container(
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(color: _colors[i], borderRadius: BorderRadius.circular(16)),
                      ),
                    )),
                  ),
                ),
              ] else ...[
                const Spacer(),
                if (_score > 0)
                  Text('Final Score: $_score', style: headingStyle(fontSize: 32, fontWeight: FontWeight.w800)),
                const SizedBox(height: 20),
                CupertinoButton(
                  padding: EdgeInsets.zero,
                  onPressed: _startGame,
                  child: Container(
                    width: 200,
                    height: 60,
                    decoration: BoxDecoration(gradient: LinearGradient(colors: [primary, accent]), borderRadius: BorderRadius.circular(20)),
                    child: Center(child: Text('Start Game', style: bodyStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700))),
                  ),
                ),
                const Spacer(),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

// ================= WORD CHAIN GAME =================
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
    
    setState(() {
      _chain.add(word);
      _currentWord = word;
      _score += word.length;
      _feedback = '';
      _controller.clear();
    });
  }

  @override
  void dispose() {
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
                    CupertinoButton(
                      padding: EdgeInsets.zero,
                      minimumSize: const Size(44, 44),
                      onPressed: () => Navigator.of(context).pop(),
                      child: Icon(CupertinoIcons.chevron_left, color: textDark, size: 28),
                    ),
                    Text('Word Chain', style: headingStyle(fontSize: 20, fontWeight: FontWeight.w700)),
                    const Spacer(),
                    Text('Score: $_score', style: bodyStyle(color: Colors.lightBlue, fontSize: 14, fontWeight: FontWeight.w700)),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Text('Last letter: ${_currentWord[_currentWord.length - 1].toUpperCase()}', style: bodyStyle(color: Colors.amber, fontSize: 16, fontWeight: FontWeight.w700)),
              const SizedBox(height: 10),
              Text('Current word:', style: bodyStyle(color: textMid, fontSize: 12)),
              Text(_currentWord.toUpperCase(), style: headingStyle(fontSize: 28, fontWeight: FontWeight.w800)),
              const SizedBox(height: 16),
              if (_feedback.isNotEmpty)
                Text(_feedback, style: bodyStyle(color: Colors.red, fontSize: 14, fontWeight: FontWeight.w600)),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: CupertinoTextField(
                  controller: _controller,
                  onSubmitted: (_) => _submitWord(),
                  placeholder: 'Enter a word...',
                  placeholderStyle: bodyStyle(color: textMid),
                  style: bodyStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  textAlign: TextAlign.center,
                  decoration: BoxDecoration(color: surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.white10)),
                  padding: const EdgeInsets.all(14),
                ),
              ),
              const SizedBox(height: 12),
              CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed: _submitWord,
                child: Container(
                  width: 150,
                  height: 44,
                  decoration: BoxDecoration(gradient: LinearGradient(colors: [primary, accent]), borderRadius: BorderRadius.circular(12)),
                  child: Center(child: Text('Submit', style: bodyStyle(color: Colors.white, fontWeight: FontWeight.w700))),
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  itemCount: _chain.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Text('${_chain.length - index}. ${_chain[_chain.length - 1 - index]}', style: bodyStyle(color: index == 0 ? Colors.white : textMid, fontSize: 14, fontWeight: index == 0 ? FontWeight.w700 : FontWeight.w400)),
                    );
                  },
                ),
              ),
              SizedBox(height: 80 + MediaQuery.of(context).padding.bottom),
            ],
          ),
        ),
      ),
    );
  }
}

// ================= RAPID TAP GAME =================
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
    setState(() {
      _taps = 0;
      _timeLeft = 10;
      _started = true;
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _timeLeft--;
        if (_timeLeft <= 0) {
          _timer?.cancel();
          _started = false;
        }
      });
    });
  }

  void _onTap() {
    if (!_started) return;
    setState(() => _taps++);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

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
                      CupertinoButton(
                        padding: EdgeInsets.zero,
                        minimumSize: const Size(44, 44),
                        onPressed: () => Navigator.of(context).pop(),
                        child: Icon(CupertinoIcons.chevron_left, color: textDark, size: 28),
                      ),
                      Text('Rapid Tap', style: headingStyle(fontSize: 20, fontWeight: FontWeight.w700)),
                      const Spacer(),
                      if (_started)
                        Text('$_timeLeft s', style: bodyStyle(color: Colors.redAccent, fontSize: 14, fontWeight: FontWeight.w700)),
                    ],
                  ),
                ),
                const Spacer(),
                if (!_started && _taps == 0)
                  CupertinoButton(
                    padding: EdgeInsets.zero,
                    onPressed: _startGame,
                    child: Container(
                      width: 200,
                      height: 60,
                      decoration: BoxDecoration(gradient: LinearGradient(colors: [primary, accent]), borderRadius: BorderRadius.circular(20)),
                      child: Center(child: Text('Start', style: bodyStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700))),
                    ),
                  )
                else ...[
                  Text('$_taps', style: headingStyle(fontSize: 72, fontWeight: FontWeight.w300)),
                  const SizedBox(height: 8),
                  Text(_started ? 'TAP ANYWHERE!' : 'Taps per second: ${(_taps / 10).toStringAsFixed(1)}', style: bodyStyle(color: textMid, fontSize: 16)),
                  if (!_started) ...[
                    const SizedBox(height: 30),
                    CupertinoButton(
                      padding: EdgeInsets.zero,
                      onPressed: () => setState(() { _taps = 0; _startGame(); }),
                      child: Container(
                        width: 180,
                        height: 50,
                        decoration: BoxDecoration(gradient: LinearGradient(colors: [primary, accent]), borderRadius: BorderRadius.circular(16)),
                        child: Center(child: Text('Play Again', style: bodyStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700))),
                      ),
                    ),
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
