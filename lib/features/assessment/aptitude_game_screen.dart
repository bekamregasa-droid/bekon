import 'package:flutter/material.dart';
import 'package:bekon/features/results/results_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AptitudeGameScreen extends StatefulWidget {
  const AptitudeGameScreen({super.key});

  @override
  State<AptitudeGameScreen> createState() => _AptitudeGameScreenState();
}

class _AptitudeGameScreenState extends State<AptitudeGameScreen> with SingleTickerProviderStateMixin {
  int _currentGameIndex = 0;
  int _currentQuestionIndex = 0;
  int _totalScore = 0;
  bool _isLoading = false;
  bool _showExplanation = false;
  
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  
  final List<Map<String, dynamic>> _games = [
    {
      'id': 'pattern_recognition',
      'name': 'Pattern Recognition',
      'icon': Icons.pattern,
      'color': const Color(0xFF2563EB),
      'description': 'Identify the logical pattern in sequences',
      'instructions': 'Look at the pattern and select the next item that completes it logically.',
      'questions': [
        {
          'question': 'Which number completes the pattern?',
          'pattern': [2, 4, 8, 16],
          'options': ['24', '32', '30', '18'],
          'correct': '32',
          'explanation': 'Each number doubles the previous (2×2=4, 4×2=8, 8×2=16, 16×2=32)',
          'category': 'logical',
          'skill': 'pattern_recognition',
          'difficulty': 'easy',
        },
        {
          'question': 'Which letter completes the pattern?',
          'pattern': ['A', 'C', 'E', 'G'],
          'options': ['H', 'I', 'J', 'K'],
          'correct': 'I',
          'explanation': 'The pattern skips one letter each time (A, C, E, G, I)',
          'category': 'logical',
          'skill': 'pattern_recognition',
          'difficulty': 'easy',
        },
        {
          'question': 'Which number completes the pattern?',
          'pattern': [3, 6, 11, 18],
          'options': ['25', '27', '29', '31'],
          'correct': '27',
          'explanation': 'The differences increase by 2 each time: +3, +5, +7, +9 (18+9=27)',
          'category': 'logical',
          'skill': 'pattern_recognition',
          'difficulty': 'medium',
        },
        {
          'question': 'Which shape completes the pattern?',
          'pattern': ['●', '○', '●', '○'],
          'options': ['●', '○', '◑', '◐'],
          'correct': '●',
          'explanation': 'The pattern alternates between filled and empty circles',
          'category': 'spatial',
          'skill': 'pattern_recognition',
          'difficulty': 'easy',
        },
        {
          'question': 'Which number completes the pattern?',
          'pattern': [1, 1, 2, 3, 5],
          'options': ['7', '8', '9', '10'],
          'correct': '8',
          'explanation': 'This is the Fibonacci sequence: each number is the sum of the two previous (5+3=8)',
          'category': 'logical',
          'skill': 'pattern_recognition',
          'difficulty': 'medium',
        },
      ],
    },
    {
      'id': 'spatial_reasoning',
      'name': 'Spatial Reasoning',
      'icon': Icons.threed_rotation,
      'color': const Color(0xFF7C3AED),
      'description': 'Visualize and manipulate objects in space',
      'instructions': 'Imagine how these shapes would look when rotated or folded.',
      'questions': [
        {
          'question': 'Which shape is the same as the first one rotated?',
          'image': 'spatial_1',
          'options': ['A', 'B', 'C', 'D'],
          'correct': 'B',
          'explanation': 'When rotated 90 degrees clockwise, shape A matches shape B',
          'category': 'spatial',
          'skill': 'mental_rotation',
          'difficulty': 'medium',
        },
        {
          'question': 'Which cube cannot be made from this net?',
          'image': 'spatial_2',
          'options': ['A', 'B', 'C', 'D'],
          'correct': 'C',
          'explanation': 'In net C, the shaded faces would be adjacent, which is impossible',
          'category': 'spatial',
          'skill': 'spatial_visualization',
          'difficulty': 'hard',
        },
        {
          'question': 'Which shape is the mirror image?',
          'image': 'spatial_3',
          'options': ['A', 'B', 'C', 'D'],
          'correct': 'A',
          'explanation': 'A is the exact mirror reflection of the original',
          'category': 'spatial',
          'skill': 'mental_rotation',
          'difficulty': 'medium',
        },
        {
          'question': 'How many cubes are in this structure?',
          'image': 'spatial_4',
          'options': ['6', '7', '8', '9'],
          'correct': '8',
          'explanation': 'Count carefully: there are 4 visible and 4 hidden cubes',
          'category': 'spatial',
          'skill': 'spatial_visualization',
          'difficulty': 'medium',
        },
        {
          'question': 'Which 3D shape matches these 2D views?',
          'image': 'spatial_5',
          'options': ['A', 'B', 'C', 'D'],
          'correct': 'D',
          'explanation': 'Only D matches all three views: front, top, and side',
          'category': 'spatial',
          'skill': 'spatial_visualization',
          'difficulty': 'hard',
        },
      ],
    },
    {
      'id': 'verbal_ability',
      'name': 'Verbal Ability',
      'icon': Icons.translate,
      'color': const Color(0xFF059669),
      'description': 'Word relationships and language logic',
      'instructions': 'Find the relationship between words and choose the best answer.',
      'questions': [
        {
          'question': 'Doctor is to hospital as teacher is to:',
          'options': ['Student', 'School', 'Book', 'Classroom'],
          'correct': 'School',
          'explanation': 'A doctor works in a hospital; a teacher works in a school',
          'category': 'verbal',
          'skill': 'analogies',
          'difficulty': 'easy',
        },
        {
          'question': 'Which word is the odd one out?',
          'options': ['Happy', 'Joyful', 'Content', 'Sad'],
          'correct': 'Sad',
          'explanation': 'Sad is the opposite of the others which are all positive emotions',
          'category': 'verbal',
          'skill': 'categorization',
          'difficulty': 'easy',
        },
        {
          'question': 'If all birds can fly and a penguin is a bird, then:',
          'options': [
            'Penguins can fly',
            'Penguins cannot fly',
            'The statement is false',
            'Cannot be determined'
          ],
          'correct': 'Cannot be determined',
          'explanation': 'The premise "all birds can fly" is false, so the conclusion cannot be determined',
          'category': 'verbal',
          'skill': 'logical_reasoning',
          'difficulty': 'medium',
        },
        {
          'question': 'Complete the analogy: Book is to chapter as play is to:',
          'options': ['Actor', 'Theater', 'Scene', 'Script'],
          'correct': 'Scene',
          'explanation': 'A book is divided into chapters; a play is divided into scenes',
          'category': 'verbal',
          'skill': 'analogies',
          'difficulty': 'medium',
        },
        {
          'question': 'Which word means the opposite of "benevolent"?',
          'options': ['Kind', 'Generous', 'Malevolent', 'Charitable'],
          'correct': 'Malevolent',
          'explanation': 'Benevolent means kind/wishing well; malevolent means wishing harm',
          'category': 'verbal',
          'skill': 'vocabulary',
          'difficulty': 'hard',
        },
      ],
    },
    {
      'id': 'numerical_reasoning',
      'name': 'Numerical Reasoning',
      'icon': Icons.calculate,
      'color': const Color(0xFFDC2626),
      'description': 'Work with numbers and data patterns',
      'instructions': 'Analyze the numerical information and select the correct answer.',
      'questions': [
        {
          'question': 'If a shirt costs $40 and is on sale for 25% off, what is the sale price?',
          'options': ['$30', '$32', '$35', '$38'],
          'correct': '$30',
          'explanation': '25% of $40 is $10, so $40 - $10 = $30',
          'category': 'numerical',
          'skill': 'percentages',
          'difficulty': 'easy',
        },
        {
          'question': 'What is the average of 12, 15, 18, and 21?',
          'options': ['15', '16', '16.5', '17'],
          'correct': '16.5',
          'explanation': 'Sum = 66, divided by 4 = 16.5',
          'category': 'numerical',
          'skill': 'averages',
          'difficulty': 'easy',
        },
        {
          'question': 'A car travels 240 miles in 4 hours. What is its average speed?',
          'options': ['50 mph', '55 mph', '60 mph', '65 mph'],
          'correct': '60 mph',
          'explanation': 'Speed = Distance ÷ Time = 240 ÷ 4 = 60 mph',
          'category': 'numerical',
          'skill': 'rate_calculation',
          'difficulty': 'easy',
        },
        {
          'question': 'If 5 workers can build a wall in 10 days, how many days will 2 workers take?',
          'options': ['20 days', '25 days', '30 days', '35 days'],
          'correct': '25 days',
          'explanation': '5 workers × 10 days = 50 worker-days. 50 ÷ 2 = 25 days',
          'category': 'numerical',
          'skill': 'inverse_proportion',
          'difficulty': 'medium',
        },
        {
          'question': 'What is 15% of 200?',
          'options': ['25', '30', '35', '40'],
          'correct': '30',
          'explanation': '15% = 0.15, 0.15 × 200 = 30',
          'category': 'numerical',
          'skill': 'percentages',
          'difficulty': 'easy',
        },
      ],
    },
    {
      'id': 'creative_thinking',
      'name': 'Creative Thinking',
      'icon': Icons.lightbulb,
      'color': const Color(0xFFEA580C),
      'description': 'Generate innovative solutions',
      'instructions': 'There are no wrong answers - choose what feels most natural to you.',
      'questions': [
        {
          'question': 'How many different uses can you think of for a paperclip?',
          'type': 'open',
          'skill': 'divergent_thinking',
          'difficulty': 'medium',
        },
        {
          'question': 'If you could invent a new holiday, what would it celebrate?',
          'type': 'open',
          'skill': 'idea_generation',
          'difficulty': 'medium',
        },
        {
          'question': 'Complete this sentence in the most interesting way: "If I could fly, I would..."',
          'type': 'open',
          'skill': 'imagination',
          'difficulty': 'easy',
        },
        {
          'question': 'What would happen if humans could photosynthesize like plants?',
          'type': 'open',
          'skill': 'consequential_thinking',
          'difficulty': 'hard',
        },
        {
          'question': 'Design a new type of transportation for cities in 2050.',
          'type': 'open',
          'skill': 'innovation',
          'difficulty': 'hard',
        },
      ],
    },
    {
      'id': 'emotional_intelligence',
      'name': 'Emotional Intelligence',
      'icon': Icons.favorite,
      'color': const Color(0xFFBE185D),
      'description': 'Understand and manage emotions',
      'instructions': 'Choose the response that feels most authentic to you.',
      'questions': [
        {
          'question': 'A friend is crying. What do you do first?',
          'options': [
            'Give them advice',
            'Listen quietly',
            'Distract them',
            'Ask what\'s wrong'
          ],
          'correct': 'Listen quietly',
          'explanation': 'Sometimes people just need someone to listen without judgment',
          'category': 'emotional',
          'skill': 'empathy',
          'difficulty': 'medium',
        },
        {
          'question': 'You feel angry after an argument. What helps most?',
          'options': [
            'Yell to release it',
            'Take deep breaths',
            'Ignore the feeling',
            'Blame the other person'
          ],
          'correct': 'Take deep breaths',
          'explanation': 'Deep breathing activates the parasympathetic nervous system, calming you down',
          'category': 'emotional',
          'skill': 'self_regulation',
          'difficulty': 'easy',
        },
        {
          'question': 'A colleague succeeds at something you failed at. How do you feel?',
          'options': [
            'Happy for them',
            'Jealous',
            'Motivated to try again',
            'Indifferent'
          ],
          'correct': 'Happy for them',
          'explanation': 'Being genuinely happy for others\' success is a sign of emotional maturity',
          'category': 'emotional',
          'skill': 'emotional_awareness',
          'difficulty': 'medium',
        },
        {
          'question': 'Someone criticizes your work. Your first reaction is:',
          'options': [
            'Get defensive',
            'Consider if they\'re right',
            'Ignore them',
            'Criticize them back'
          ],
          'correct': 'Consider if they\'re right',
          'explanation': 'Taking a moment to reflect on feedback shows emotional intelligence',
          'category': 'emotional',
          'skill': 'receptivity',
          'difficulty': 'medium',
        },
        {
          'question': 'You notice a friend seems quiet and withdrawn. You:',
          'options': [
            'Ask if they\'re okay',
            'Give them space',
            'Cheer them up',
            'Wait for them to talk'
          ],
          'correct': 'Ask if they\'re okay',
          'explanation': 'Checking in shows you notice and care about their emotional state',
          'category': 'emotional',
          'skill': 'social_awareness',
          'difficulty': 'easy',
        },
      ],
    },
  ];

  List<Map<String, dynamic>> get _currentQuestions => _games[_currentGameIndex]['questions'];
  Map<String, dynamic> get _currentQuestion => _currentQuestions[_currentQuestionIndex];
  bool get _isLastGame => _currentGameIndex == _games.length - 1;
  bool get _isLastQuestion => _currentQuestionIndex == _currentQuestions.length - 1;
  double get _progress {
    int totalQuestions = _games.length * 5; // 5 questions per game
    int completedQuestions = (_currentGameIndex * 5) + _currentQuestionIndex;
    return completedQuestions / totalQuestions;
  }

  @override
  void initState() {
    super.initState();
    
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeIn,
      ),
    );
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.1, 0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOut,
      ),
    );
    
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleAnswer(String answer) {
    // For creative/open questions, award points based on completion
    if (_currentQuestion['type'] == 'open') {
      _totalScore += 5; // Base points for answering
    } else {
      // Check if answer is correct
      if (answer == _currentQuestion['correct']) {
        _totalScore += 10;
      }
      
      // Show explanation for non-creative questions
      setState(() {
        _showExplanation = true;
      });
      
      Future.delayed(const Duration(seconds: 2), () {
        if (!mounted) return;
        setState(() {
          _showExplanation = false;
        });
        _moveToNext();
      });
      return;
    }
    
    _moveToNext();
  }

  void _moveToNext() {
    if (_isLastQuestion && _isLastGame) {
      _completeAssessment();
    } else if (_isLastQuestion) {
      // Move to next game
      setState() {
        _currentGameIndex++;
        _currentQuestionIndex = 0;
      };
      _animationController.reset();
      _animationController.forward();
    } else {
      // Move to next question in same game
      setState(() {
        _currentQuestionIndex++;
      });
      _animationController.reset();
      _animationController.forward();
    }
  }

  Future<void> _completeAssessment() async {
    setState(() => _isLoading = true);
    
    // Save results
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('assessmentCompleted', true);
    await prefs.setInt('assessmentScore', _totalScore);
    await prefs.setString('assessmentDate', DateTime.now().toIso8601String());
    
    // Calculate scores per category
    Map<String, int> categoryScores = {};
    for (var game in _games) {
      categoryScores[game['id']] = 70 + (game == _games[_currentGameIndex] ? 15 : 0); // Mock scores
    }
    
    await prefs.setString('categoryScores', categoryScores.toString());
    
    if (!mounted) return;
    
    setState(() => _isLoading = false);
    
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => ResultsScreen(
          score: _totalScore,
          categoryScores: categoryScores,
        ),
      ),
    );
  }

  void _showPauseMenu() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Assessment Paused',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF2C3A2A),
                ),
              ),
              const SizedBox(height: 20),
              _buildPauseOption(
                icon: Icons.play_arrow,
                label: 'Resume',
                color: const Color(0xFF2C3A2A),
                onTap: () => Navigator.pop(context),
              ),
              _buildPauseOption(
                icon: Icons.restart_alt,
                label: 'Restart Game',
                color: const Color(0xFFCBA776),
                onTap: () {
                  Navigator.pop(context);
                  setState(() {
                    _currentQuestionIndex = 0;
                  });
                },
              ),
              _buildPauseOption(
                icon: Icons.exit_to_app,
                label: 'Save & Exit',
                color: Colors.red.shade400,
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPauseOption({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: color, size: 20),
      ),
      title: Text(
        label,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Color(0xFF2C3A2A),
        ),
      ),
      onTap: onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F0),
      body: SafeArea(
        child: _isLoading
            ? const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF2C3A2A)),
                ),
              )
            : Column(
                children: [
                  // Header with progress and pause
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: IconButton(
                            icon: const Icon(Icons.pause, color: Color(0xFF2C3A2A)),
                            onPressed: _showPauseMenu,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _games[_currentGameIndex]['name'],
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF2C3A2A),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Stack(
                                children: [
                                  Container(
                                    height: 6,
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade200,
                                      borderRadius: BorderRadius.circular(3),
                                    ),
                                  ),
                                  Container(
                                    height: 6,
                                    width: MediaQuery.of(context).size.width * 0.6 * _progress,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          const Color(0xFF2C3A2A),
                                          const Color(0xFFCBA776),
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(3),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: const Color(0xFF2C3A2A).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            '${_currentQuestionIndex + 1}/${_currentQuestions.length}',
                            style: const TextStyle(
                              color: Color(0xFF2C3A2A),
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // Game header
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: _games[_currentGameIndex]['color'].withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: _games[_currentGameIndex]['color'].withOpacity(0.3),
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: _games[_currentGameIndex]['color'],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            _games[_currentGameIndex]['icon'],
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _games[_currentGameIndex]['description'],
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF2C3A2A),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                _games[_currentGameIndex]['instructions'],
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Question area
                  Expanded(
                    child: FadeTransition(
                      opacity: _fadeAnimation,
                      child: SlideTransition(
                        position: _slideAnimation,
                        child: Container(
                          margin: const EdgeInsets.all(20),
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 30,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Question number
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: _games[_currentGameIndex]['color'].withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  'Question ${_currentQuestionIndex + 1}',
                                  style: TextStyle(
                                    color: _games[_currentGameIndex]['color'],
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              
                              const SizedBox(height: 20),
                              
                              // Question text
                              Text(
                                _currentQuestion['question'],
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w400,
                                  color: Color(0xFF2C3A2A),
                                  height: 1.3,
                                ),
                              ),
                              
                              const SizedBox(height: 24),
                              
                              // Pattern display for pattern questions
                              if (_currentQuestion.containsKey('pattern'))
                                _buildPatternDisplay(_currentQuestion['pattern']),
                              
                              // Options
                              if (_currentQuestion.containsKey('options'))
                                Expanded(
                                  child: ListView.separated(
                                    itemCount: _currentQuestion['options'].length,
                                    separatorBuilder: (context, index) => const SizedBox(height: 12),
                                    itemBuilder: (context, index) {
                                      return _buildOptionButton(
                                        _currentQuestion['options'][index],
                                      );
                                    },
                                  ),
                                ),
                              
                              // For open-ended questions
                              if (_currentQuestion['type'] == 'open')
                                Expanded(
                                  child: Column(
                                    children: [
                                      const SizedBox(height: 20),
                                      TextField(
                                        maxLines: 5,
                                        decoration: InputDecoration(
                                          hintText: 'Type your answer here...',
                                          hintStyle: TextStyle(color: Colors.grey.shade400),
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(16),
                                            borderSide: BorderSide.none,
                                          ),
                                          filled: true,
                                          fillColor: Colors.grey.shade50,
                                        ),
                                      ),
                                      const SizedBox(height: 20),
                                      SizedBox(
                                        width: double.infinity,
                                        child: ElevatedButton(
                                          onPressed: () => _handleAnswer('open_response'),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: _games[_currentGameIndex]['color'],
                                            foregroundColor: Colors.white,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(12),
                                            ),
                                            padding: const EdgeInsets.symmetric(vertical: 16),
                                          ),
                                          child: const Text('Submit Answer'),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  
                  // Explanation overlay
                  if (_showExplanation)
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 20,
                              offset: const Offset(0, -4),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.green.shade50,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(
                                Icons.check_circle,
                                color: Colors.green.shade400,
                                size: 24,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Good answer!',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF2C3A2A),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    _currentQuestion['explanation'] ?? '',
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
      ),
    );
  }

  Widget _buildPatternDisplay(List<dynamic> pattern) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: pattern.map((item) {
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 8),
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.grey.shade300),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.02),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Center(
              child: Text(
                item.toString(),
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF2C3A2A),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildOptionButton(String option) {
    return Container(
      width: double.infinity,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _handleAnswer(option),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              option,
              style: const TextStyle(
                fontSize: 16,
                color: Color(0xFF2C3A2A),
              ),
            ),
          ),
        ),
      ),
    );
  }
}