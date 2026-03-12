import 'package:flutter/material.dart';

class StatsScreen extends StatefulWidget {
  const StatsScreen({super.key});

  @override
  State<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  
  final Map<String, dynamic> _monthlyStats = {
    'assessments': [5, 8, 12, 15, 18, 22, 25, 28, 30, 32, 35, 38],
    'careers': [3, 7, 10, 14, 18, 21, 24, 27, 30, 32, 34, 36],
    'activities': [12, 18, 25, 30, 38, 45, 52, 58, 65, 70, 75, 82],
  };
  
  final List<Map<String, dynamic>> _skillProgress = [
    {'name': 'Logical Thinking', 'initial': 65, 'current': 92, 'color': const Color(0xFF2563EB)},
    {'name': 'Creativity', 'initial': 70, 'current': 88, 'color': const Color(0xFFEA580C)},
    {'name': 'Spatial Awareness', 'initial': 55, 'current': 85, 'color': const Color(0xFF7C3AED)},
    {'name': 'Verbal Ability', 'initial': 80, 'current': 94, 'color': const Color(0xFF059669)},
    {'name': 'Numerical', 'initial': 60, 'current': 82, 'color': const Color(0xFFDC2626)},
    {'name': 'Emotional IQ', 'initial': 75, 'current': 91, 'color': const Color(0xFFBE185D)},
  ];
  
  final List<Map<String, dynamic>> _categoryBreakdown = [
    {'category': 'Technology', 'count': 24, 'percentage': 35, 'color': const Color(0xFF2563EB)},
    {'category': 'Healthcare', 'count': 12, 'percentage': 18, 'color': const Color(0xFF059669)},
    {'category': 'Creative', 'count': 18, 'percentage': 26, 'color': const Color(0xFFEA580C)},
    {'category': 'Business', 'count': 8, 'percentage': 12, 'color': const Color(0xFF7C3AED)},
    {'category': 'Education', 'count': 6, 'percentage': 9, 'color': const Color(0xFFBE185D)},
  ];
  
  final List<Map<String, dynamic>> _achievements = [
    {'name': 'Speed Demon', 'description': 'Complete assessment in under 10 min', 'achieved': true},
    {'name': 'Perfectionist', 'description': 'Score 100% on any game', 'achieved': true},
    {'name': 'Explorer', 'description': 'View 50 different careers', 'achieved': true},
    {'name': 'Strategist', 'description': 'Save 20 careers to profile', 'achieved': false},
    {'name': 'Veteran', 'description': 'Complete 50 assessments', 'achieved': false},
    {'name': 'Influencer', 'description': 'Get 100 profile views', 'achieved': false},
  ];
  
  int _selectedTimeRange = 0; // 0: Monthly, 1: Quarterly, 2: Yearly

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
    
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F0),
      appBar: AppBar(
        title: const Text(
          'Statistics',
          style: TextStyle(
            color: Color(0xFF2C3A2A),
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF2C3A2A)),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined, color: Color(0xFF2C3A2A)),
            onPressed: () {},
          ),
        ],
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // Time Range Selector
                Container(
                  padding: const EdgeInsets.all(4),
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
                      _buildTimeRangeTab(0, 'Monthly'),
                      _buildTimeRangeTab(1, 'Quarterly'),
                      _buildTimeRangeTab(2, 'Yearly'),
                    ],
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // Overview Cards
                Row(
                  children: [
                    Expanded(
                      child: _buildOverviewCard(
                        'Total Assessments',
                        '38',
                        '↑ 12%',
                        Icons.assessment,
                        const Color(0xFF2563EB),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildOverviewCard(
                        'Careers Viewed',
                        '142',
                        '↑ 23%',
                        Icons.visibility,
                        const Color(0xFF7C3AED),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 12),
                
                Row(
                  children: [
                    Expanded(
                      child: _buildOverviewCard(
                        'Saved Careers',
                        '36',
                        '↑ 8%',
                        Icons.bookmark,
                        const Color(0xFF059669),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildOverviewCard(
                        'Avg. Match',
                        '87%',
                        '↑ 5%',
                        Icons.star,
                        const Color(0xFFCBA776),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 24),
                
                // Chart Section
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.02),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Activity Overview',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF2C3A2A),
                        ),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        height: 200,
                        child: CustomPaint(
                          painter: _LineChartPainter(
                            data: _monthlyStats['assessments'],
                            color: const Color(0xFF2C3A2A),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildChartLegend('Assessments', const Color(0xFF2C3A2A)),
                          const SizedBox(width: 20),
                          _buildChartLegend('Careers', const Color(0xFFCBA776)),
                          const SizedBox(width: 20),
                          _buildChartLegend('Activities', const Color(0xFF2563EB)),
                        ],
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // Skill Progress
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.02),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Skill Development',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF2C3A2A),
                        ),
                      ),
                      const SizedBox(height: 20),
                      ..._skillProgress.map((skill) => _buildSkillProgress(skill)),
                    ],
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // Category Breakdown
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.02),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Career Interests',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF2C3A2A),
                        ),
                      ),
                      const SizedBox(height: 20),
                      ..._categoryBreakdown.map((category) => _buildCategoryItem(category)),
                    ],
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // Achievements Grid
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.02),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Achievements',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF2C3A2A),
                            ),
                          ),
                          Text(
                            '${_achievements.where((a) => a['achieved']).length}/${_achievements.length}',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Color(0xFF2C3A2A),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 1.5,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                        ),
                        itemCount: _achievements.length,
                        itemBuilder: (context, index) {
                          final achievement = _achievements[index];
                          return Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: achievement['achieved']
                                  ? const Color(0xFF2C3A2A).withOpacity(0.1)
                                  : Colors.grey.shade50,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: achievement['achieved']
                                    ? const Color(0xFF2C3A2A).withOpacity(0.3)
                                    : Colors.grey.shade200,
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  achievement['achieved']
                                      ? Icons.emoji_events
                                      : Icons.lock_outline,
                                  color: achievement['achieved']
                                      ? const Color(0xFFCBA776)
                                      : Colors.grey.shade400,
                                  size: 24,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  achievement['name'],
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: achievement['achieved']
                                        ? const Color(0xFF2C3A2A)
                                        : Colors.grey.shade500,
                                  ),
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTimeRangeTab(int index, String label) {
    final isSelected = _selectedTimeRange == index;
    
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedTimeRange = index;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
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
              fontSize: 13,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOverviewCard(String title, String value, String change, IconData icon, Color color) {
    return Container(
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 16),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  change,
                  style: const TextStyle(
                    fontSize: 10,
                    color: Colors.green,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w600,
              color: Color(0xFF2C3A2A),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChartLegend(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }

  Widget _buildSkillProgress(Map<String, dynamic> skill) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
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
                '${skill['initial']}% → ${skill['current']}%',
                style: TextStyle(
                  fontSize: 12,
                  color: skill['color'],
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
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
                width: MediaQuery.of(context).size.width * 0.5 * (skill['initial'] / 100),
                decoration: BoxDecoration(
                  color: Colors.grey.shade400,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
              Container(
                height: 6,
                width: MediaQuery.of(context).size.width * 0.5 * (skill['current'] / 100),
                decoration: BoxDecoration(
                  color: skill['color'],
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryItem(Map<String, dynamic> category) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 40,
            child: Text(
              '${category['percentage']}%',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: category['color'],
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      category['category'],
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF2C3A2A),
                      ),
                    ),
                    Text(
                      '${category['count']} careers',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                ClipRRect(
                  borderRadius: BorderRadius.circular(2),
                  child: LinearProgressIndicator(
                    value: category['percentage'] / 100,
                    backgroundColor: Colors.grey.shade200,
                    valueColor: AlwaysStoppedAnimation<Color>(category['color']),
                    minHeight: 4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _LineChartPainter extends CustomPainter {
  final List<int> data;
  final Color color;

  _LineChartPainter({required this.data, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withOpacity(0.2)
      ..style = PaintingStyle.fill;

    final linePaint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final pointPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    if (data.isEmpty) return;

    final maxValue = data.reduce((a, b) => a > b ? a : b).toDouble();
    final minValue = data.reduce((a, b) => a < b ? a : b).toDouble();
    final range = maxValue - minValue == 0 ? 1 : maxValue - minValue;

    final path = Path();
    final points = <Offset>[];

    for (int i = 0; i < data.length; i++) {
      final x = (i / (data.length - 1)) * size.width;
      final y = size.height - ((data[i] - minValue) / range) * (size.height * 0.8) - 10;
      points.add(Offset(x, y));
    }

    // Draw area
    path.moveTo(points[0].dx, size.height);
    path.lineTo(points[0].dx, points[0].dy);
    for (int i = 1; i < points.length; i++) {
      path.lineTo(points[i].dx, points[i].dy);
    }
    path.lineTo(points.last.dx, size.height);
    path.close();
    canvas.drawPath(path, paint);

    // Draw line
    for (int i = 0; i < points.length - 1; i++) {
      canvas.drawLine(points[i], points[i + 1], linePaint);
    }

    // Draw points
    for (final point in points) {
      canvas.drawCircle(point, 3, pointPaint);
      canvas.drawCircle(point, 2, Paint()..color = Colors.white);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}