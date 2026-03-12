import 'package:flutter/material.dart';
import 'package:bekon/features/settings/settings_screen.dart';
import 'package:bekon/features/stats/stats_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;
  
  String _userName = 'Alex Johnson';
  String _userEmail = 'alex.johnson@email.com';
  String _userPhone = '+1 (555) 123-4567';
  String _userLocation = 'San Francisco, CA';
  String _userBio = 'Passionate about technology and helping others discover their potential. Always curious, always learning.';
  String _joinDate = 'March 2024';
  String _userTitle = 'Product Designer';
  String _userCompany = 'Creative Studios';
  
  bool _isEditing = false;
  bool _isLoading = false;
  int _selectedTab = 0;
  
  final List<Map<String, dynamic>> _skills = [
    {'name': 'UX Research', 'level': 85, 'endorsements': 12, 'color': const Color(0xFF2563EB)},
    {'name': 'Product Strategy', 'level': 78, 'endorsements': 8, 'color': const Color(0xFF7C3AED)},
    {'name': 'User Testing', 'level': 92, 'endorsements': 15, 'color': const Color(0xFF059669)},
    {'name': 'Wireframing', 'level': 88, 'endorsements': 10, 'color': const Color(0xFFEA580C)},
    {'name': 'Prototyping', 'level': 82, 'endorsements': 9, 'color': const Color(0xFFDC2626)},
    {'name': 'Analytical Thinking', 'level': 90, 'endorsements': 14, 'color': const Color(0xFFBE185D)},
  ];
  
  final List<Map<String, dynamic>> _interests = [
    {'name': 'Technology', 'icon': Icons.computer, 'color': const Color(0xFF2563EB)},
    {'name': 'Design', 'icon': Icons.palette, 'color': const Color(0xFFEA580C)},
    {'name': 'Data Science', 'icon': Icons.analytics, 'color': const Color(0xFF7C3AED)},
    {'name': 'Education', 'icon': Icons.school, 'color': const Color(0xFF059669)},
    {'name': 'AI & ML', 'icon': Icons.psychology, 'color': const Color(0xFFDC2626)},
    {'name': 'Writing', 'icon': Icons.edit, 'color': const Color(0xFFBE185D)},
  ];
  
  final List<Map<String, dynamic>> _achievements = [
    {
      'title': 'Assessment Master',
      'description': 'Completed all 6 assessment games',
      'icon': Icons.emoji_events,
      'color': const Color(0xFFCBA776),
      'date': '2 weeks ago',
      'rarity': 'rare',
      'progress': 1.0,
    },
    {
      'title': 'Career Explorer',
      'description': 'Saved 10+ careers to profile',
      'icon': Icons.explore,
      'color': const Color(0xFF2563EB),
      'date': '1 month ago',
      'rarity': 'common',
      'progress': 1.0,
    },
    {
      'title': 'Consistency King',
      'description': 'Active for 30 consecutive days',
      'icon': Icons.local_fire_department,
      'color': const Color(0xFFEA580C),
      'date': '3 days ago',
      'rarity': 'epic',
      'progress': 0.7,
    },
    {
      'title': 'Insight Seeker',
      'description': 'Completed 5 career deep-dives',
      'icon': Icons.lightbulb,
      'color': const Color(0xFF059669),
      'date': '1 week ago',
      'rarity': 'common',
      'progress': 1.0,
    },
    {
      'title': 'Community Helper',
      'description': 'Helped 50 users with advice',
      'icon': Icons.people,
      'color': const Color(0xFF7C3AED),
      'date': '5 days ago',
      'rarity': 'rare',
      'progress': 0.4,
    },
    {
      'title': 'Early Adopter',
      'description': 'Joined in the first month',
      'icon': Icons.rocket_launch,
      'color': const Color(0xFFDC2626),
      'date': 'Joined Mar 2024',
      'rarity': 'legendary',
      'progress': 1.0,
    },
  ];
  
  final List<Map<String, dynamic>> _recentActivities = [
    {
      'type': 'assessment',
      'title': 'Completed Pattern Recognition',
      'score': 92,
      'date': '2 hours ago',
      'icon': Icons.pattern,
      'color': const Color(0xFF2563EB),
    },
    {
      'type': 'career',
      'title': 'Saved Software Engineer',
      'date': '1 day ago',
      'icon': Icons.code,
      'color': const Color(0xFF7C3AED),
    },
    {
      'type': 'achievement',
      'title': 'Earned "Assessment Master"',
      'date': '2 days ago',
      'icon': Icons.emoji_events,
      'color': const Color(0xFFCBA776),
    },
    {
      'type': 'assessment',
      'title': 'Completed Spatial Reasoning',
      'score': 88,
      'date': '3 days ago',
      'icon': Icons.threed_rotation,
      'color': const Color(0xFFEA580C),
    },
  ];
  
  final List<Map<String, dynamic>> _savedCareers = [
    {
      'title': 'Software Engineer',
      'company': 'Tech Corp',
      'match': 94,
      'icon': Icons.code,
      'color': const Color(0xFF2563EB),
      'salary': '$120k',
    },
    {
      'title': 'UX Designer',
      'company': 'Design Studio',
      'match': 91,
      'icon': Icons.design_services,
      'color': const Color(0xFFEA580C),
      'salary': '$95k',
    },
    {
      'title': 'Data Scientist',
      'company': 'Analytics Inc',
      'match': 87,
      'icon': Icons.analytics,
      'color': const Color(0xFF7C3AED),
      'salary': '$130k',
    },
  ];

  final Map<String, dynamic> _stats = {
    'assessments': 12,
    'careers': 24,
    'connections': 156,
    'endorsements': 68,
    'streak': 15,
    'rank': 'Expert',
  };

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
    
    _scaleAnimation = Tween<double>(begin: 0.95, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOut,
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
      _userName = prefs.getString('userName') ?? _userName;
      _userEmail = prefs.getString('userEmail') ?? _userEmail;
      _userPhone = prefs.getString('userPhone') ?? _userPhone;
    });
  }

  void _showEditProfileDialog() {
    final nameController = TextEditingController(text: _userName);
    final bioController = TextEditingController(text: _userBio);
    final titleController = TextEditingController(text: _userTitle);
    final companyController = TextEditingController(text: _userCompany);
    final locationController = TextEditingController(text: _userLocation);
    
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Profile'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Full Name',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    labelText: 'Professional Title',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: companyController,
                  decoration: const InputDecoration(
                    labelText: 'Company',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: locationController,
                  decoration: const InputDecoration(
                    labelText: 'Location',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: bioController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: 'Bio',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _userName = nameController.text;
                  _userBio = bioController.text;
                  _userTitle = titleController.text;
                  _userCompany = companyController.text;
                  _userLocation = locationController.text;
                });
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2C3A2A),
              ),
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
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
            icon: const Icon(Icons.bar_chart_outlined, color: Color(0xFF2C3A2A)),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const StatsScreen()),
              );
            },
          ),
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
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF2C3A2A)),
              ),
            )
          : FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      // Cover Photo
                      Stack(
                        children: [
                          Container(
                            height: 150,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Color(0xFF2C3A2A),
                                  Color(0xFF3E4F3C),
                                ],
                              ),
                              borderRadius: const BorderRadius.only(
                                bottomLeft: Radius.circular(30),
                                bottomRight: Radius.circular(30),
                              ),
                            ),
                          ),
                          
                          // Profile Picture
                          Positioned(
                            top: 100,
                            left: 20,
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: CircleAvatar(
                                radius: 50,
                                backgroundColor: const Color(0xFFCBA776),
                                child: Text(
                                  _userName[0].toUpperCase(),
                                  style: const TextStyle(
                                    fontSize: 40,
                                    fontWeight: FontWeight.w300,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          
                          // Edit Button
                          Positioned(
                            top: 120,
                            right: 20,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: IconButton(
                                icon: const Icon(
                                  Icons.edit,
                                  color: Color(0xFF2C3A2A),
                                ),
                                onPressed: _showEditProfileDialog,
                              ),
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 60),
                      
                      // Profile Info
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Name and Title
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        _userName,
                                        style: const TextStyle(
                                          fontSize: 28,
                                          fontWeight: FontWeight.w300,
                                          color: Color(0xFF2C3A2A),
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        _userTitle,
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.grey.shade600,
                                        ),
                                      ),
                                      Text(
                                        _userCompany,
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey.shade500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF2C3A2A).withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.star,
                                        color: Color(0xFFCBA776),
                                        size: 16,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        '4.8',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          color: const Color(0xFF2C3A2A),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            
                            const SizedBox(height: 16),
                            
                            // Location and Join Date
                            Row(
                              children: [
                                Icon(
                                  Icons.location_on_outlined,
                                  size: 16,
                                  color: Colors.grey.shade500,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  _userLocation,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Icon(
                                  Icons.calendar_today_outlined,
                                  size: 14,
                                  color: Colors.grey.shade500,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  'Joined $_joinDate',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              ],
                            ),
                            
                            const SizedBox(height: 16),
                            
                            // Bio
                            Container(
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
                              child: Text(
                                _userBio,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey.shade700,
                                  height: 1.5,
                                ),
                              ),
                            ),
                            
                            const SizedBox(height: 24),
                            
                            // Stats Grid
                            GridView.count(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              crossAxisCount: 4,
                              childAspectRatio: 1,
                              children: [
                                _buildStatItem('Assessments', '${_stats['assessments']}'),
                                _buildStatItem('Careers', '${_stats['careers']}'),
                                _buildStatItem('Connections', '${_stats['connections']}'),
                                _buildStatItem('Endorse', '${_stats['endorsements']}'),
                              ],
                            ),
                            
                            const SizedBox(height: 24),
                            
                            // Tabs
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(30),
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
                                  _buildTab(0, 'Skills'),
                                  _buildTab(1, 'Interests'),
                                  _buildTab(2, 'Achievements'),
                                ],
                              ),
                            ),
                            
                            const SizedBox(height: 20),
                            
                            // Tab Content
                            if (_selectedTab == 0) _buildSkillsTab(),
                            if (_selectedTab == 1) _buildInterestsTab(),
                            if (_selectedTab == 2) _buildAchievementsTab(),
                            
                            const SizedBox(height: 24),
                            
                            // Saved Careers Section
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Saved Careers',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xFF2C3A2A),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {},
                                  child: const Text(
                                    'View All',
                                    style: TextStyle(
                                      color: Color(0xFF2C3A2A),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            
                            const SizedBox(height: 12),
                            
                            ..._savedCareers.map((career) => _buildSavedCareerCard(career)),
                            
                            const SizedBox(height: 24),
                            
                            // Recent Activity
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Recent Activity',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xFF2C3A2A),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => const HistoryScreen(),
                                      ),
                                    );
                                  },
                                  child: const Text(
                                    'View All',
                                    style: TextStyle(
                                      color: Color(0xFF2C3A2A),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            
                            const SizedBox(height: 12),
                            
                            ..._recentActivities.map((activity) => _buildActivityItem(activity)),
                            
                            const SizedBox(height: 30),
                          ],
                        ),
                      ),
                    ],
                  ),
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
            color: isSelected ? const Color(0xFF2C3A2A) : Colors.transparent,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.grey.shade600,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
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
            fontSize: 11,
            color: Colors.grey.shade500,
          ),
        ),
      ],
    );
  }

  Widget _buildSkillsTab() {
    return Column(
      children: _skills.map((skill) {
        return Container(
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
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    skill['name'],
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF2C3A2A),
                    ),
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.thumb_up_outlined,
                        size: 14,
                        color: Colors.grey.shade500,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${skill['endorsements']}',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: skill['level'] / 100,
                        backgroundColor: Colors.grey.shade200,
                        valueColor: AlwaysStoppedAnimation<Color>(skill['color']),
                        minHeight: 6,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    '${skill['level']}%',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: skill['color'],
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

  Widget _buildInterestsTab() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: _interests.map((interest) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: interest['color'].withOpacity(0.1),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: interest['color'].withOpacity(0.3),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                interest['icon'],
                size: 16,
                color: interest['color'],
              ),
              const SizedBox(width: 8),
              Text(
                interest['name'],
                style: TextStyle(
                  color: interest['color'],
                  fontWeight: FontWeight.w500,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildAchievementsTab() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.1,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: _achievements.length,
      itemBuilder: (context, index) {
        final achievement = _achievements[index];
        return Container(
          padding: const EdgeInsets.all(12),
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
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: achievement['color'].withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      achievement['icon'],
                      color: achievement['color'],
                      size: 24,
                    ),
                  ),
                  if (achievement['rarity'] == 'legendary')
                    Positioned(
                      top: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: const BoxDecoration(
                          color: Color(0xFFCBA776),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.star,
                          color: Colors.white,
                          size: 8,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                achievement['title'],
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF2C3A2A),
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              if (achievement['progress'] < 1.0)
                LinearProgressIndicator(
                  value: achievement['progress'],
                  backgroundColor: Colors.grey.shade200,
                  valueColor: AlwaysStoppedAnimation<Color>(achievement['color']),
                  minHeight: 3,
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSavedCareerCard(Map<String, dynamic> career) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
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
                        color: const Color(0xFF2C3A2A).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${career['match']}%',
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
                  career['company'] + ' • ' + career['salary'],
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
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: activity['color'].withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              activity['icon'],
              color: activity['color'],
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
                if (activity.containsKey('score'))
                  Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Text(
                      'Score: ${activity['score']}%',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Text(
            activity['date'],
            style: TextStyle(
              fontSize: 10,
              color: Colors.grey.shade400,
            ),
          ),
        ],
      ),
    );
  }
}