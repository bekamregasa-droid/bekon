import 'package:flutter/material.dart';
import 'package:bekon/features/assessment/aptitude_game_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AssessmentIntroScreen extends StatefulWidget {
  const AssessmentIntroScreen({super.key});

  @override
  State<AssessmentIntroScreen> createState() => _AssessmentIntroScreenState();
}

class _AssessmentIntroScreenState extends State<AssessmentIntroScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;
  
  int _selectedExperience = -1;
  bool _isLoading = false;
  
  final List<Map<String, dynamic>> _benefits = [
    {
      'icon': Icons.speed,
      'title': '15 minutes',
      'description': 'Quick but comprehensive assessment',
      'color': const Color(0xFF2563EB),
    },
    {
      'icon': Icons.psychology,
      'title': 'Scientific approach',
      'description': 'Based on career psychology research',
      'color': const Color(0xFF7C3AED),
    },
    {
      'icon': Icons.insights,
      'title': 'Accurate results',
      'description': '92% match accuracy with real careers',
      'color': const Color(0xFF059669),
    },
    {
      'icon': Icons.auto_awesome,
      'title': 'AI-powered',
      'description': 'Advanced algorithms analyze your responses',
      'color': const Color(0xFFDC2626),
    },
  ];
  
  final List<Map<String, dynamic>> _gameTypes = [
    {
      'name': 'Pattern Recognition',
      'icon': Icons.pattern,
      'description': 'Identify sequences and logical patterns',
      'duration': '3 min',
      'questions': 5,
      'color': const Color(0xFF2563EB),
    },
    {
      'name': 'Spatial Reasoning',
      'icon': Icons.threed_rotation,
      'description': 'Visualize and manipulate shapes in space',
      'duration': '4 min',
      'questions': 5,
      'color': const Color(0xFF7C3AED),
    },
    {
      'name': 'Verbal Ability',
      'icon': Icons.translate,
      'description': 'Word relationships and language logic',
      'duration': '3 min',
      'questions': 5,
      'color': const Color(0xFF059669),
    },
    {
      'name': 'Numerical Reasoning',
      'icon': Icons.calculate,
      'description': 'Work with numbers and data patterns',
      'duration': '4 min',
      'questions': 5,
      'color': const Color(0xFFDC2626),
    },
    {
      'name': 'Creative Thinking',
      'icon': Icons.lightbulb,
      'description': 'Generate innovative solutions',
      'duration': '3 min',
      'questions': 5,
      'color': const Color(0xFFEA580C),
    },
    {
      'name': 'Emotional Intelligence',
      'icon': Icons.favorite,
      'description': 'Understand and manage emotions',
      'duration': '3 min',
      'questions': 5,
      'color': const Color(0xFFBE185D),
    },
  ];
  
  final List<Map<String, dynamic>> _experienceLevels = [
    {
      'title': 'Never taken before',
      'description': 'I\'m new to career assessments',
      'icon': Icons.auto_awesome_outlined,
    },
    {
      'title': 'Some experience',
      'description': 'I\'ve taken similar tests before',
      'icon': Icons.trending_up,
    },
    {
      'title': 'Very experienced',
      'description': 'I know my strengths well',
      'icon': Icons.psychology,
    },
  ];

  @override
  void initState() {
    super.initState();
    
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
      ),
    );
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.2, 0.7, curve: Curves.easeOut),
      ),
    );
    
    _scaleAnimation = Tween<double>(begin: 0.95, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
      ),
    );
    
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _startAssessment() async {
    if (_selectedExperience == -1) {
      _showErrorSnackBar('Please select your experience level to continue');
      return;
    }
    
    setState(() => _isLoading = true);
    
    // Save user preference
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('assessmentExperience', _selectedExperience);
    
    if (!mounted) return;
    
    setState(() => _isLoading = false);
    
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AptitudeGameScreen(),
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red.shade400,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  void _showInfoDialog(String title, String content) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Got it'),
          ),
        ],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F0),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with back button and progress
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
                        icon: const Icon(Icons.arrow_back, color: Color(0xFF2C3A2A)),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2C3A2A).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Row(
                        children: [
                          Icon(
                            Icons.timer_outlined,
                            size: 14,
                            color: Color(0xFF2C3A2A),
                          ),
                          SizedBox(width: 4),
                          Text(
                            '15-20 min',
                            style: TextStyle(
                              color: Color(0xFF2C3A2A),
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              
              // Main illustration area
              FadeTransition(
                opacity: _fadeAnimation,
                child: Container(
                  height: 200,
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        const Color(0xFF2C3A2A).withOpacity(0.1),
                        const Color(0xFFCBA776).withOpacity(0.1),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Stack(
                    children: [
                      // Decorative circles
                      Positioned(
                        top: -30,
                        right: -30,
                        child: Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: const Color(0xFF2C3A2A).withOpacity(0.1),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: -20,
                        left: -20,
                        child: Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: const Color(0xFFCBA776).withOpacity(0.1),
                          ),
                        ),
                      ),
                      
                      // Center content
                      Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _buildAnimatedIcon(Icons.psychology, const Color(0xFF2C3A2A), 0.2),
                            const SizedBox(width: 20),
                            _buildAnimatedIcon(Icons.auto_awesome, const Color(0xFFCBA776), 0.4),
                            const SizedBox(width: 20),
                            _buildAnimatedIcon(Icons.insights, const Color(0xFF4A7A5C), 0.6),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Title section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FadeTransition(
                      opacity: _fadeAnimation,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: const Color(0xFF2C3A2A).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          'STEP 1 OF 4',
                          style: TextStyle(
                            color: Color(0xFF2C3A2A),
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 16),
                    
                    FadeTransition(
                      opacity: _fadeAnimation,
                      child: const Text(
                        'Discover your natural\nabilities',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w300,
                          color: Color(0xFF2C3A2A),
                          height: 1.1,
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 12),
                    
                    FadeTransition(
                      opacity: _fadeAnimation,
                      child: Text(
                        'Through a series of engaging games and exercises, we\'ll identify your inherent strengths and how you naturally approach problems.',
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.grey.shade700,
                          height: 1.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Benefits grid
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 1.3,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemCount: _benefits.length,
                  itemBuilder: (context, index) {
                    return FadeTransition(
                      opacity: _fadeAnimation,
                      child: ScaleTransition(
                        scale: _scaleAnimation,
                        child: _buildBenefitCard(_benefits[index]),
                      ),
                    );
                  },
                ),
              ),
              
              const SizedBox(height: 32),
              
              // What to expect section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'What to expect',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF2C3A2A),
                      ),
                    ),
                    
                    const SizedBox(height: 16),
                    
                    _buildExpectItem(
                      icon: Icons.games,
                      title: '6 interactive games',
                      description: 'Each designed to measure different cognitive abilities',
                      color: const Color(0xFF2563EB),
                    ),
                    
                    const SizedBox(height: 16),
                    
                    _buildExpectItem(
                      icon: Icons.timeline,
                      title: 'Real-time progress',
                      description: 'See your results as you complete each game',
                      color: const Color(0xFF7C3AED),
                    ),
                    
                    const SizedBox(height: 16),
                    
                    _buildExpectItem(
                      icon: Icons.emoji_objects,
                      title: 'No right or wrong answers',
                      description: 'We\'re measuring your natural preferences',
                      color: const Color(0xFF059669),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 32),
              
              // Game types preview
              Container(
                padding: const EdgeInsets.symmetric(vertical: 24),
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Assessment games',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF2C3A2A),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              _showInfoDialog(
                                'About the games',
                                'Each game measures a different cognitive ability. The results help us build a complete picture of your natural strengths and preferences.',
                              );
                            },
                            child: const Text(
                              'Learn more',
                              style: TextStyle(
                                color: Color(0xFF2C3A2A),
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 16),
                    
                    SizedBox(
                      height: 120,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        itemCount: _gameTypes.length,
                        itemBuilder: (context, index) {
                          return Container(
                            width: 200,
                            margin: const EdgeInsets.only(right: 12),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: _gameTypes[index]['color'].withOpacity(0.05),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: _gameTypes[index]['color'].withOpacity(0.2),
                              ),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: _gameTypes[index]['color'].withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Icon(
                                    _gameTypes[index]['icon'],
                                    color: _gameTypes[index]['color'],
                                    size: 20,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        _gameTypes[index]['name'],
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: Color(0xFF2C3A2A),
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 4),
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.timer_outlined,
                                            size: 10,
                                            color: Colors.grey.shade500,
                                          ),
                                          const SizedBox(width: 2),
                                          Text(
                                            '${_gameTypes[index]['duration']} • ${_gameTypes[index]['questions']} questions',
                                            style: TextStyle(
                                              fontSize: 9,
                                              color: Colors.grey.shade500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              
              // Experience level section
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Your experience level',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF2C3A2A),
                      ),
                    ),
                    
                    const SizedBox(height: 4),
                    
                    Text(
                      'This helps us calibrate the assessment',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    
                    const SizedBox(height: 16),
                    
                    ...List.generate(_experienceLevels.length, (index) {
                      return _buildExperienceOption(index);
                    }),
                    
                    const SizedBox(height: 32),
                    
                    // Start button
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _startAssessment,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2C3A2A),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          disabledBackgroundColor: Colors.grey.shade300,
                        ),
                        child: _isLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                ),
                              )
                            : const Text(
                                'Begin Assessment',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 0.5,
                                ),
                              ),
                      ),
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Privacy note
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.lock_outline,
                            size: 18,
                            color: const Color(0xFF2C3A2A).withOpacity(0.5),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Your responses are anonymous and used only to generate your career recommendations',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade600,
                                height: 1.4,
                              ),
                            ),
                          ),
                        ],
                      ),
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

  Widget _buildAnimatedIcon(IconData icon, Color color, double delay) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: (500 + (delay * 1000)).toInt()),
      curve: Curves.elasticOut,
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: color,
              size: 24,
            ),
          ),
        );
      },
    );
  }

  Widget _buildBenefitCard(Map<String, dynamic> benefit) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: benefit['color'].withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              benefit['icon'],
              color: benefit['color'],
              size: 18,
            ),
          ),
          const Spacer(),
          Text(
            benefit['title'],
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF2C3A2A),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            benefit['description'],
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey.shade600,
              height: 1.3,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildExpectItem({
    required IconData icon,
    required String title,
    required String description,
    required Color color,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: color,
            size: 20,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF2C3A2A),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                description,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildExperienceOption(int index) {
    final isSelected = _selectedExperience == index;
    final experience = _experienceLevels[index];
    
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedExperience = index;
        });
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF2C3A2A).withOpacity(0.05) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? const Color(0xFF2C3A2A) : Colors.grey.shade200,
            width: isSelected ? 1.5 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: const Color(0xFF2C3A2A).withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.02),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color(0xFF2C3A2A)
                    : const Color(0xFF2C3A2A).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                experience['icon'],
                color: isSelected ? Colors.white : const Color(0xFF2C3A2A),
                size: 20,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    experience['title'],
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: isSelected ? const Color(0xFF2C3A2A) : Colors.grey.shade800,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    experience['description'],
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Container(
                width: 24,
                height: 24,
                decoration: const BoxDecoration(
                  color: Color(0xFF2C3A2A),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check,
                  color: Colors.white,
                  size: 14,
                ),
              ),
          ],
        ),
      ),
    );
  }
}