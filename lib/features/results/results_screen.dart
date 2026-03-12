import 'package:flutter/material.dart';
import 'package:bekon/features/careers/career_detail_screen.dart';
import 'package:bekon/features/dashboard/dashboard_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ResultsScreen extends StatefulWidget {
  final int score;
  final Map<String, int> categoryScores;

  const ResultsScreen({
    Key? key,
    required this.score,
    required this.categoryScores,
  }) : super(key: key);

  @override
  State<ResultsScreen> createState() => _ResultsScreenState();
}

class _ResultsScreenState extends State<ResultsScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<Offset> _slideAnimation1;
  late Animation<Offset> _slideAnimation2;
  
  int _selectedTab = 0;
  bool _isSaved = false;
  String _userName = 'User';
  
  final List<Map<String, dynamic>> _topCareers = [
    {
      'id': 'software-engineer',
      'title': 'Software Engineer',
      'match': 94,
      'category': 'Technology',
      'description': 'Design and develop software applications',
      'salary': '\$80k - \$150k',
      'growth': '22%',
      'icon': Icons.code,
      'color': const Color(0xFF2563EB),
      'skills': ['Programming', 'Problem Solving', 'Analytical Thinking', 'Teamwork'],
      'personality': ['Analytical', 'Detail-oriented', 'Logical', 'Patient'],
      'education': "Bachelor's in Computer Science",
      'workEnvironment': 'Office / Remote',
      'dailyTasks': [
        'Writing and testing code',
        'Debugging issues',
        'Collaborating with team',
        'Designing software solutions',
      ],
    },
    {
      'id': 'data-scientist',
      'title': 'Data Scientist',
      'match': 91,
      'category': 'Technology',
      'description': 'Analyze complex data to drive decisions',
      'salary': '\$90k - \$160k',
      'growth': '36%',
      'icon': Icons.analytics,
      'color': const Color(0xFF7C3AED),
      'skills': ['Statistics', 'Machine Learning', 'Python', 'Data Visualization'],
      'personality': ['Curious', 'Analytical', 'Methodical', 'Detail-oriented'],
      'education': "Master's in Data Science",
      'workEnvironment': 'Office / Remote',
      'dailyTasks': [
        'Analyzing large datasets',
        'Building ML models',
        'Presenting findings',
        'Data cleaning',
      ],
    },
    {
      'id': 'ux-designer',
      'title': 'UX Designer',
      'match': 88,
      'category': 'Design',
      'description': 'Create user-friendly digital experiences',
      'salary': '\$70k - \$120k',
      'growth': '15%',
      'icon': Icons.design_services,
      'color': const Color(0xFFDC2626),
      'skills': ['User Research', 'Wireframing', 'Prototyping', 'Usability Testing'],
      'personality': ['Empathetic', 'Creative', 'Detail-oriented', 'User-focused'],
      'education': "Bachelor's in Design or HCI",
      'workEnvironment': 'Studio / Remote',
      'dailyTasks': [
        'User research',
        'Creating wireframes',
        'Testing prototypes',
        'Collaborating with developers',
      ],
    },
    {
      'id': 'product-manager',
      'title': 'Product Manager',
      'match': 85,
      'category': 'Business',
      'description': 'Lead product strategy and development',
      'salary': '\$90k - \$160k',
      'growth': '18%',
      'icon': Icons.business_center,
      'color': const Color(0xFFEA580C),
      'skills': ['Strategy', 'Communication', 'Market Research', 'Leadership'],
      'personality': ['Strategic', 'Visionary', 'Collaborative', 'Decisive'],
      'education': "Bachelor's in Business or related",
      'workEnvironment': 'Office / Remote',
      'dailyTasks': [
        'Defining product vision',
        'Prioritizing features',
        'Working with stakeholders',
        'Analyzing market trends',
      ],
    },
    {
      'id': 'doctor',
      'title': 'Physician',
      'match': 82,
      'category': 'Healthcare',
      'description': 'Diagnose and treat medical conditions',
      'salary': '\$150k - \$300k',
      'growth': '14%',
      'icon': Icons.local_hospital,
      'color': const Color(0xFF059669),
      'skills': ['Diagnosis', 'Patient Care', 'Communication', 'Decision Making'],
      'personality': ['Compassionate', 'Detail-oriented', 'Calm under pressure'],
      'education': 'Medical Degree',
      'workEnvironment': 'Hospitals / Clinics',
      'dailyTasks': [
        'Examining patients',
        'Diagnosing conditions',
        'Prescribing treatments',
        'Collaborating with specialists',
      ],
    },
  ];

  final List<Map<String, dynamic>> _skillBreakdown = [
    {'skill': 'Logical Reasoning', 'score': 92, 'color': const Color(0xFF2563EB)},
    {'skill': 'Creative Thinking', 'score': 78, 'color': const Color(0xFFEA580C)},
    {'skill': 'Spatial Awareness', 'score': 85, 'color': const Color(0xFF7C3AED)},
    {'skill': 'Verbal Ability', 'score': 88, 'color': const Color(0xFF059669)},
    {'skill': 'Numerical Reasoning', 'score': 76, 'color': const Color(0xFFDC2626)},
    {'skill': 'Emotional Intelligence', 'score': 94, 'color': const Color(0xFFBE185D)},
  ];

  final List<Map<String, dynamic>> _personalityTraits = [
    {'trait': 'Analytical', 'percentage': 92, 'description': 'You enjoy breaking down complex problems'},
    {'trait': 'Creative', 'percentage': 78, 'description': 'You think outside the box'},
    {'trait': 'Detail-oriented', 'percentage': 88, 'description': 'You notice things others miss'},
    {'trait': 'Collaborative', 'percentage': 84, 'description': 'You work well with others'},
    {'trait': 'Adaptable', 'percentage': 81, 'description': 'You handle change well'},
  ];

  final List<Map<String, dynamic>> _recommendedPaths = [
    {
      'title': 'Technology Path',
      'description': 'Software, Data, AI',
      'match': 94,
      'icon': Icons.computer,
      'color': const Color(0xFF2563EB),
    },
    {
      'title': 'Creative Path',
      'description': 'Design, Arts, Media',
      'match': 88,
      'icon': Icons.palette,
      'color': const Color(0xFFEA580C),
    },
    {
      'title': 'Analytical Path',
      'description': 'Science, Research, Analysis',
      'match': 86,
      'icon': Icons.science,
      'color': const Color(0xFF7C3AED),
    },
  ];

  @override
  void initState() {
    super.initState();
    
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeIn),
      ),
    );
    
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.5, curve: Curves.elasticOut),
      ),
    );
    
    _slideAnimation1 = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.3, 0.7, curve: Curves.easeOut),
      ),
    );
    
    _slideAnimation2 = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.5, 0.9, curve: Curves.easeOut),
      ),
    );
    
    _animationController.forward();
    _loadUserData();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _userName = prefs.getString('userName') ?? 'User';
    });
  }

  Future<void> _saveResults() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('resultsSaved', true);
    await prefs.setString('topCareer', _topCareers[0]['title']);
    
    setState(() {
      _isSaved = true;
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Results saved to your profile'),
        backgroundColor: const Color(0xFF2C3A2A),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  void _showShareDialog() {
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
                'Share Your Results',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF2C3A2A),
                ),
              ),
              const SizedBox(height: 20),
              _buildShareOption(
                icon: Icons.download,
                label: 'Download PDF Report',
                color: const Color(0xFF2563EB),
                onTap: () => Navigator.pop(context),
              ),
              _buildShareOption(
                icon: Icons.share,
                label: 'Share with Counselor',
                color: const Color(0xFF7C3AED),
                onTap: () => Navigator.pop(context),
              ),
              _buildShareOption(
                icon: Icons.email,
                label: 'Email to Myself',
                color: const Color(0xFF059669),
                onTap: () => Navigator.pop(context),
              ),
              _buildShareOption(
                icon: Icons.print,
                label: 'Print Results',
                color: const Color(0xFFEA580C),
                onTap: () => Navigator.pop(context),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildShareOption({
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
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              // Header with celebration effect
              Stack(
                children: [
                  Container(
                    height: 280,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          const Color(0xFF2C3A2A),
                          const Color(0xFF2C3A2A).withOpacity(0.8),
                        ],
                      ),
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(40),
                        bottomRight: Radius.circular(40),
                      ),
                    ),
                    child: Stack(
                      children: [
                        // Decorative circles
                        Positioned(
                          top: -50,
                          right: -50,
                          child: Container(
                            width: 150,
                            height: 150,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white.withOpacity(0.1),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: -30,
                          left: -30,
                          child: Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: const Color(0xFFCBA776).withOpacity(0.2),
                            ),
                          ),
                        ),
                        
                        // Confetti effect (simulated with dots)
                        ...List.generate(20, (index) {
                          return Positioned(
                            top: 50 + (index * 10).toDouble(),
                            left: 20 + (index * 30).toDouble(),
                            child: Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: [
                                  Colors.yellow,
                                  Colors.orange,
                                  Colors.green,
                                  Colors.blue,
                                  Colors.purple,
                                ][index % 5].withOpacity(0.6),
                              ),
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                  
                  // Header content
                  Positioned(
                    top: 60,
                    left: 0,
                    right: 0,
                    child: Column(
                      children: [
                        ScaleTransition(
                          scale: _scaleAnimation,
                          child: Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 20,
                                  spreadRadius: 5,
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.emoji_events,
                              color: Color(0xFFCBA776),
                              size: 50,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        FadeTransition(
                          opacity: _fadeAnimation,
                          child: Text(
                            'Congratulations, $_userName!',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        FadeTransition(
                          opacity: _fadeAnimation,
                          child: Text(
                            'Your assessment is complete',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white.withOpacity(0.8),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              
              // Score card
              Transform.translate(
                offset: const Offset(0, -30),
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 30,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Your Score',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    '${widget.score}',
                                    style: const TextStyle(
                                      fontSize: 48,
                                      fontWeight: FontWeight.w300,
                                      color: Color(0xFF2C3A2A),
                                    ),
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.only(bottom: 8),
                                    child: Text(
                                      '/500',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Top 15% of users',
                                style: TextStyle(
                                  color: const Color(0xFF059669),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: 1,
                          height: 60,
                          color: Colors.grey.shade300,
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              const Text(
                                'Match Accuracy',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                '${(widget.score / 5).toStringAsFixed(1)}%',
                                style: const TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.w300,
                                  color: Color(0xFF2C3A2A),
                                ),
                              ),
                              const SizedBox(height: 4),
                              const Text(
                                'Very High',
                                style: TextStyle(
                                  color: Color(0xFF059669),
                                  fontWeight: FontWeight.w500,
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
              
              // Tab bar
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    _buildTab(0, 'Top Careers'),
                    _buildTab(1, 'Skills'),
                    _buildTab(2, 'Personality'),
                    _buildTab(3, 'Paths'),
                  ],
                ),
              ),
              
              const SizedBox(height: 20),
              
              // Tab content
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SlideTransition(
                  position: _slideAnimation1,
                  child: _selectedTab == 0
                      ? _buildCareersTab()
                      : _selectedTab == 1
                          ? _buildSkillsTab()
                          : _selectedTab == 2
                              ? _buildPersonalityTab()
                              : _buildPathsTab(),
                ),
              ),
              
              const SizedBox(height: 20),
              
              // Action buttons
              SlideTransition(
                position: _slideAnimation2,
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _isSaved ? null : _saveResults,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _isSaved ? Colors.grey.shade300 : const Color(0xFF2C3A2A),
                            foregroundColor: _isSaved ? Colors.grey.shade600 : Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                _isSaved ? Icons.check : Icons.bookmark_outline,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Text(_isSaved ? 'Saved' : 'Save Results'),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton(
                          onPressed: _showShareDialog,
                          style: OutlinedButton.styleFrom(
                            foregroundColor: const Color(0xFF2C3A2A),
                            side: const BorderSide(color: Color(0xFF2C3A2A)),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(Icons.share, size: 20),
                              SizedBox(width: 8),
                              Text('Share'),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 20),
              
              // Continue to dashboard button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TextButton(
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => const DashboardScreen()),
                      (route) => false,
                    );
                  },
                  child: const Text(
                    'Continue to Dashboard',
                    style: TextStyle(
                      color: Color(0xFF2C3A2A),
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTab(int index, String label) {
    final isSelected = _selectedTab == index;
    
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedTab = index;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF2C3A2A).withOpacity(0.1) : Colors.transparent,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isSelected ? const Color(0xFF2C3A2A) : Colors.grey.shade600,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              fontSize: 13,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCareersTab() {
    return Column(
      children: _topCareers.asMap().entries.map((entry) {
        final index = entry.key;
        final career = entry.value;
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.02),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: career['color'].withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      career['icon'],
                      color: career['color'],
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                career['title'],
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF2C3A2A),
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: career['color'].withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                children: [
                                  Text(
                                    '${career['match']}%',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: career['color'],
                                    ),
                                  ),
                                  if (index == 0) ...[
                                    const SizedBox(width: 4),
                                    const Icon(
                                      Icons.star,
                                      color: Color(0xFFCBA776),
                                      size: 12,
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          career['category'],
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          career['description'],
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey.shade700,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Icon(
                          Icons.attach_money,
                          size: 14,
                          color: Colors.grey.shade500,
                        ),
                        const SizedBox(width: 2),
                        Text(
                          career['salary'],
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      children: [
                        Icon(
                          Icons.trending_up,
                          size: 14,
                          color: Colors.green.shade400,
                        ),
                        const SizedBox(width: 2),
                        Text(
                          '${career['growth']} growth',
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.green.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 80,
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CareerDetailScreen(career: career),
                          ),
                        );
                      },
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: const Size(0, 30),
                      ),
                      child: const Text(
                        'View',
                        style: TextStyle(
                          color: Color(0xFF2C3A2A),
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildSkillsTab() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.02),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: _skillBreakdown.map((skill) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          skill['skill'],
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF2C3A2A),
                          ),
                        ),
                        Text(
                          '${skill['score']}%',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: skill['color'],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: skill['score'] / 100,
                        backgroundColor: Colors.grey.shade200,
                        valueColor: AlwaysStoppedAnimation<Color>(skill['color']),
                        minHeight: 8,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
        
        const SizedBox(height: 16),
        
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.02),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Your Strengths',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF2C3A2A),
                ),
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _skillBreakdown
                    .where((s) => s['score'] >= 85)
                    .map((skill) {
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: skill['color'].withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          skill['skill'],
                          style: TextStyle(
                            color: skill['color'],
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      );
                    }).toList(),
              ),
              const SizedBox(height: 12),
              const Text(
                'Areas to Develop',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF2C3A2A),
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _skillBreakdown
                    .where((s) => s['score'] < 80)
                    .map((skill) {
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          skill['skill'],
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 12,
                          ),
                        ),
                      );
                    }).toList(),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPersonalityTab() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.02),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: _personalityTraits.map((trait) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          trait['trait'],
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF2C3A2A),
                          ),
                        ),
                        Text(
                          '${trait['percentage']}%',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF2C3A2A),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: trait['percentage'] / 100,
                        backgroundColor: Colors.grey.shade200,
                        valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF2C3A2A)),
                        minHeight: 8,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        trait['description'],
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
        
        const SizedBox(height: 16),
        
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFF2C3A2A).withOpacity(0.05),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.lightbulb,
                  color: Color(0xFFCBA776),
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Your Personality Type',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF2C3A2A),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Analytical Creative (AC)',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPathsTab() {
    return Column(
      children: _recommendedPaths.map((path) {
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
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
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: path['color'].withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  path['icon'],
                  color: path['color'],
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            path['title'],
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF2C3A2A),
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: path['color'].withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '${path['match']}%',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: path['color'],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      path['description'],
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
        );
      }).toList(),
    );
  }
}