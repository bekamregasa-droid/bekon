import 'package:flutter/material.dart';
import 'package:bekon/features/careers/career_list_screen.dart';
import 'package:bekon/features/assessment/aptitude_game_screen.dart';
import 'package:bekon/features/profile/profile_screen.dart';
import 'package:bekon/features/settings/settings_screen.dart';
import 'package:bekon/features/history/history_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  String _userName = 'User';
  bool _hasAssessment = false;
  Map<String, dynamic> _userStats = {};
  
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  
  late PageController _pageController;
  
  final List<Widget> _screens = [
    const HomeTab(),
    const CareerListScreen(),
    const HistoryScreen(),
    const ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeIn,
      ),
    );
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOut,
      ),
    );
    
    _pageController = PageController(initialPage: 0);
    
    _loadUserData();
    _animationController.forward();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _userName = prefs.getString('userName') ?? 'User';
      _hasAssessment = prefs.getBool('assessmentCompleted') ?? false;
      _userStats = {
        'assessments': prefs.getInt('assessmentsCount') ?? 0,
        'careers': prefs.getInt('savedCareers') ?? 0,
        'daysActive': prefs.getInt('daysActive') ?? 1,
      };
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F0),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        children: _screens,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 20,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(0, Icons.home_outlined, Icons.home, 'Home'),
                _buildNavItem(1, Icons.explore_outlined, Icons.explore, 'Explore'),
                _buildNavItem(2, Icons.history_outlined, Icons.history, 'History'),
                _buildNavItem(3, Icons.person_outlined, Icons.person, 'Profile'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData iconOutlined, IconData iconFilled, String label) {
    final isSelected = _selectedIndex == index;
    
    return GestureDetector(
      onTap: () => _onItemTapped(index),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(
          horizontal: isSelected ? 20 : 12,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF2C3A2A).withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSelected ? iconFilled : iconOutlined,
              color: isSelected ? const Color(0xFF2C3A2A) : Colors.grey.shade400,
              size: 24,
            ),
            if (isSelected) ...[
              const SizedBox(width: 6),
              Text(
                label,
                style: const TextStyle(
                  color: Color(0xFF2C3A2A),
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ==================== HOME TAB ====================

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> with AutomaticKeepAliveClientMixin {
  String _greeting = '';
  String _userName = 'User';
  bool _hasAssessment = false;
  List<Map<String, dynamic>> _recommendedCareers = [];
  List<Map<String, dynamic>> _recentActivities = [];
  
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _updateGreeting();
    _loadData();
  }

  void _updateGreeting() {
    final hour = DateTime.now().hour;
    setState(() {
      if (hour < 12) {
        _greeting = 'Good morning';
      } else if (hour < 17) {
        _greeting = 'Good afternoon';
      } else {
        _greeting = 'Good evening';
      }
    });
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _userName = prefs.getString('userName') ?? 'User';
      _hasAssessment = prefs.getBool('assessmentCompleted') ?? false;
      
      // Mock recommended careers
      _recommendedCareers = [
        {
          'id': 'software-engineer',
          'title': 'Software Engineer',
          'match': 92,
          'category': 'Technology',
          'icon': Icons.code,
          'color': 0xFF2563EB,
        },
        {
          'id': 'data-scientist',
          'title': 'Data Scientist',
          'match': 87,
          'category': 'Technology',
          'icon': Icons.analytics,
          'color': 0xFF7C3AED,
        },
        {
          'id': 'ux-designer',
          'title': 'UX Designer',
          'match': 84,
          'category': 'Creative',
          'icon': Icons.design_services,
          'color': 0xFFDC2626,
        },
      ];
      
      // Mock recent activities
      _recentActivities = [
        {
          'title': 'Completed assessment',
          'subtitle': 'Your results are ready',
          'time': '2h ago',
          'icon': Icons.assessment,
          'color': 0xFF2C3A2A,
        },
        {
          'title': 'Saved new career',
          'subtitle': 'Software Engineer added',
          'time': '1d ago',
          'icon': Icons.bookmark,
          'color': 0xFFCBA776,
        },
      ];
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F0),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with greeting and profile
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _greeting,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _userName,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF2C3A2A),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Color(0xFF2C3A2A),
                            Color(0xFF3E4F3C),
                          ],
                        ),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF2C3A2A).withOpacity(0.2),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          _userName[0].toUpperCase(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 24),
                
                // Assessment card if not completed
                if (!_hasAssessment) ...[
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color(0xFF2C3A2A),
                          Color(0xFF3E4F3C),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF2C3A2A).withOpacity(0.3),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.psychology,
                                color: Colors.white,
                                size: 24,
                              ),
                            ),
                            const SizedBox(width: 12),
                            const Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Discover your path',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    'Take our assessment to find careers that match your strengths',
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const AptitudeGameScreen(),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: const Color(0xFF2C3A2A),
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                            child: const Text(
                              'Start Assessment',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
                
                // Stats cards
                Row(
                  children: [
                    Expanded(
                      child: _buildStatCard(
                        'Assessments',
                        _hasAssessment ? '1' : '0',
                        Icons.assessment_outlined,
                        const Color(0xFF2C3A2A),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildStatCard(
                        'Saved Careers',
                        '3',
                        Icons.bookmark_outlined,
                        const Color(0xFFCBA776),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildStatCard(
                        'Days Active',
                        '7',
                        Icons.local_fire_department_outlined,
                        const Color(0xFF4A7A5C),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 24),
                
                // Recommended for you section
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Recommended for you',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF2C3A2A),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        // Navigate to all careers
                      },
                      child: const Text(
                        'See all',
                        style: TextStyle(
                          color: Color(0xFF2C3A2A),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 12),
                
                // Career cards
                SizedBox(
                  height: 160,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: _recommendedCareers.length,
                    separatorBuilder: (context, index) => const SizedBox(width: 12),
                    itemBuilder: (context, index) {
                      final career = _recommendedCareers[index];
                      return _buildCareerCard(career);
                    },
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // Recent activity
                const Text(
                  'Recent activity',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF2C3A2A),
                  ),
                ),
                
                const SizedBox(height: 12),
                
                // Activity list
                ..._recentActivities.map((activity) => _buildActivityItem(activity)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon, Color color) {
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
          Icon(
            icon,
            color: color.withOpacity(0.7),
            size: 20,
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Color(0xFF2C3A2A),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCareerCard(Map<String, dynamic> career) {
    return Container(
      width: 140,
      padding: const EdgeInsets.all(12),
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
              color: Color(career['color']).withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              career['icon'],
              color: Color(career['color']),
              size: 20,
            ),
          ),
          const Spacer(),
          Text(
            career['title'],
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF2C3A2A),
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Text(
                career['category'],
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.grey.shade500,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFF2C3A2A).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '${career['match']}%',
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2C3A2A),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActivityItem(Map<String, dynamic> activity) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
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
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Color(activity['color']).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              activity['icon'],
              color: Color(activity['color']),
              size: 18,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  activity['title'],
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF2C3A2A),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  activity['subtitle'],
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
          Text(
            activity['time'],
            style: TextStyle(
              fontSize: 10,
              color: Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }
}

// ==================== HISTORY SCREEN ====================

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> with AutomaticKeepAliveClientMixin {
  final List<Map<String, dynamic>> _history = [
    {
      'date': 'Mar 12, 2024',
      'title': 'Career Assessment',
      'description': 'Completed full assessment',
      'score': 85,
      'icon': Icons.assessment,
      'color': 0xFF2C3A2A,
    },
    {
      'date': 'Mar 10, 2024',
      'title': 'Software Engineer',
      'description': 'Saved to favorites',
      'score': null,
      'icon': Icons.bookmark,
      'color': 0xFFCBA776,
    },
    {
      'date': 'Mar 8, 2024',
      'title': 'Pattern Recognition Game',
      'description': 'Score: 92%',
      'score': 92,
      'icon': Icons.games,
      'color': 0xFF4A7A5C,
    },
    {
      'date': 'Mar 5, 2024',
      'title': 'Data Scientist',
      'description': 'Viewed career details',
      'score': null,
      'icon': Icons.visibility,
      'color': 0xFF2563EB,
    },
    {
      'date': 'Mar 3, 2024',
      'title': 'Spatial Reasoning Game',
      'description': 'Score: 78%',
      'score': 78,
      'icon': Icons.games,
      'color': 0xFF7C3AED,
    },
  ];

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F0),
      appBar: AppBar(
        title: const Text(
          'History',
          style: TextStyle(
            color: Color(0xFF2C3A2A),
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list, color: Color(0xFF2C3A2A)),
            onPressed: () {
              _showFilterDialog();
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Timeline header
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: const Color(0xFF2C3A2A).withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.timeline,
                      color: Color(0xFF2C3A2A),
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Your activity timeline',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF2C3A2A),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 24),
              
              // History items
              ..._buildHistoryTimeline(),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildHistoryTimeline() {
    final List<Widget> items = [];
    String? lastDate;
    
    for (var i = 0; i < _history.length; i++) {
      final item = _history[i];
      final currentDate = item['date'];
      
      if (lastDate != currentDate) {
        items.add(Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Text(
            currentDate,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade700,
            ),
          ),
        ));
        lastDate = currentDate;
      }
      
      items.add(_buildHistoryItem(item, i == _history.length - 1));
    }
    
    return items;
  }

  Widget _buildHistoryItem(Map<String, dynamic> item, bool isLast) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: Color(item['color']).withOpacity(0.1),
                shape: BoxShape.circle,
                border: Border.all(
                  color: Color(item['color']),
                  width: 1.5,
                ),
              ),
              child: Center(
                child: Icon(
                  item['icon'],
                  color: Color(item['color']),
                  size: 16,
                ),
              ),
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 50,
                color: Colors.grey.shade300,
              ),
          ],
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
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
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        item['title'],
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF2C3A2A),
                        ),
                      ),
                    ),
                    if (item['score'] != null)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFF2C3A2A).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '${item['score']}%',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF2C3A2A),
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  item['description'],
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _showFilterDialog() {
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
                'Filter History',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF2C3A2A),
                ),
              ),
              const SizedBox(height: 20),
              _buildFilterOption('All Activity', true),
              _buildFilterOption('Assessments', false),
              _buildFilterOption('Saved Careers', false),
              _buildFilterOption('Games', false),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2C3A2A),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text('Apply Filters'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFilterOption(String label, bool isSelected) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          SizedBox(
            height: 24,
            width: 24,
            child: Checkbox(
              value: isSelected,
              onChanged: (value) {},
              activeColor: const Color(0xFF2C3A2A),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              color: Color(0xFF2C3A2A),
            ),
          ),
        ],
      ),
    );
  }
}

// ==================== PROFILE SCREEN ====================

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> with AutomaticKeepAliveClientMixin {
  String _userName = 'User';
  String _userEmail = 'user@example.com';
  String _userPhone = '';
  String _joinDate = 'March 2024';
  
  final List<Map<String, dynamic>> _skills = [
    {'name': 'Analytical Thinking', 'level': 85},
    {'name': 'Problem Solving', 'level': 78},
    {'name': 'Creativity', 'level': 72},
    {'name': 'Communication', 'level': 68},
  ];
  
  final List<String> _interests = [
    'Technology',
    'Data Science',
    'UX Design',
    'AI',
  ];

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _userName = prefs.getString('userName') ?? 'User';
      _userEmail = prefs.getString('userEmail') ?? 'user@example.com';
      _userPhone = prefs.getString('userPhone') ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F0),
      appBar: AppBar(
        title: const Text(
          'Profile',
          style: TextStyle(
            color: Color(0xFF2C3A2A),
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined, color: Color(0xFF2C3A2A)),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // Profile header
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color(0xFF2C3A2A),
                          Color(0xFF3E4F3C),
                        ],
                      ),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF2C3A2A).withOpacity(0.2),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        _userName[0].toUpperCase(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 40,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: const Color(0xFFCBA776),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 3),
                    ),
                    child: const Icon(
                      Icons.edit,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 16),
              
              Text(
                _userName,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF2C3A2A),
                ),
              ),
              
              const SizedBox(height: 4),
              
              Text(
                _userEmail,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                ),
              ),
              
              if (_userPhone.isNotEmpty) ...[
                const SizedBox(height: 2),
                Text(
                  _userPhone,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
              
              const SizedBox(height: 4),
              
              Text(
                'Joined $_joinDate',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade500,
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Stats row
              Row(
                children: [
                  _buildProfileStat('Assessments', '3'),
                  Container(width: 1, height: 30, color: Colors.grey.shade300),
                  _buildProfileStat('Careers', '12'),
                  Container(width: 1, height: 30, color: Colors.grey.shade300),
                  _buildProfileStat('Games', '8'),
                ],
              ),
              
              const SizedBox(height: 24),
              
              // Skills section
              const Row(
                children: [
                  Icon(Icons.psychology_outlined, color: Color(0xFF2C3A2A), size: 20),
                  SizedBox(width: 8),
                  Text(
                    'Your Skills',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF2C3A2A),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 16),
              
              ..._skills.map((skill) => _buildSkillItem(skill)),
              
              const SizedBox(height: 24),
              
              // Interests section
              const Row(
                children: [
                  Icon(Icons.interests_outlined, color: Color(0xFF2C3A2A), size: 20),
                  SizedBox(width: 8),
                  Text(
                    'Your Interests',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF2C3A2A),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 16),
              
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _interests.map((interest) {
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2C3A2A).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Text(
                      interest,
                      style: const TextStyle(
                        color: Color(0xFF2C3A2A),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  );
                }).toList(),
              ),
              
              const SizedBox(height: 24),
              
              // Account actions
              _buildAccountAction(
                icon: Icons.person_outline,
                title: 'Personal Information',
                subtitle: 'Update your details',
                onTap: () {},
              ),
              
              _buildAccountAction(
                icon: Icons.notifications_outlined,
                title: 'Notifications',
                subtitle: 'Manage your preferences',
                onTap: () {},
              ),
              
              _buildAccountAction(
                icon: Icons.security_outlined,
                title: 'Privacy & Security',
                subtitle: 'Control your data',
                onTap: () {},
              ),
              
              _buildAccountAction(
                icon: Icons.help_outline,
                title: 'Help & Support',
                subtitle: 'Get assistance',
                onTap: () {},
              ),
              
              const SizedBox(height: 20),
              
              // Sign out button
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () => _showSignOutDialog(context),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red.shade400,
                    side: BorderSide(color: Colors.red.shade400),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text(
                    'Sign Out',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileStat(String label, String value) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Color(0xFF2C3A2A),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSkillItem(Map<String, dynamic> skill) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                skill['name'],
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF2C3A2A),
                ),
              ),
              Text(
                '${skill['level']}%',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: skill['level'] / 100,
              backgroundColor: Colors.grey.shade200,
              valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF2C3A2A)),
              minHeight: 6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAccountAction({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: const Color(0xFF2C3A2A).withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: const Color(0xFF2C3A2A), size: 20),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Color(0xFF2C3A2A),
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          fontSize: 13,
          color: Colors.grey.shade600,
        ),
      ),
      trailing: Icon(Icons.arrow_forward_ios, color: Colors.grey.shade400, size: 16),
      onTap: onTap,
    );
  }

  void _showSignOutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Sign Out'),
          content: const Text('Are you sure you want to sign out?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                // Clear user data
                final prefs = await SharedPreferences.getInstance();
                await prefs.setBool('isLoggedIn', false);
                
                if (!context.mounted) return;
                
                // Navigate to login
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/login',
                  (route) => false,
                );
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.red,
              ),
              child: const Text('Sign Out'),
            ),
          ],
        );
      },
    );
  }
}