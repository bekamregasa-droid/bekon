import 'package:flutter/material.dart';

class CareerDetailScreen extends StatelessWidget {
  final Map<String, dynamic> career;

  const CareerDetailScreen({
    Key? key,
    required this.career,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F0),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with back button and image
              Stack(
                children: [
                  Container(
                    height: 200,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: career['color'].withOpacity(0.2),
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(40),
                        bottomRight: Radius.circular(40),
                      ),
                    ),
                    child: Center(
                      child: Icon(
                        career['icon'],
                        color: career['color'],
                        size: 80,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 20,
                    left: 20,
                    child: Container(
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
                  ),
                ],
              ),
              
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title and match
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                career['title'],
                                style: const TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.w300,
                                  color: Color(0xFF2C3A2A),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                career['category'],
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: career['color'].withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            '${career['match']}% match',
                            style: TextStyle(
                              color: career['color'],
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 20),
                    
                    // Quick info
                    Row(
                      children: [
                        Expanded(
                          child: _buildInfoChip(
                            icon: Icons.attach_money,
                            label: career['salary'],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildInfoChip(
                            icon: Icons.trending_up,
                            label: '${career['growth']} growth',
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 20),
                    
                    // Description
                    const Text(
                      'Description',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF2C3A2A),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      career['description'],
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.grey.shade700,
                        height: 1.5,
                      ),
                    ),
                    
                    const SizedBox(height: 20),
                    
                    // Education
                    const Text(
                      'Education',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF2C3A2A),
                      ),
                    ),
                    const SizedBox(height: 8),
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
                      child: Row(
                        children: [
                          Icon(
                            Icons.school,
                            color: career['color'],
                            size: 20,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              career['education'],
                              style: const TextStyle(
                                fontSize: 15,
                                color: Color(0xFF2C3A2A),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 20),
                    
                    // Skills
                    const Text(
                      'Key Skills',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF2C3A2A),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: career['skills'].map<Widget>((skill) {
                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: career['color'].withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            skill,
                            style: TextStyle(
                              color: career['color'],
                              fontSize: 13,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    
                    const SizedBox(height: 20),
                    
                    // Work Environment
                    const Text(
                      'Work Environment',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF2C3A2A),
                      ),
                    ),
                    const SizedBox(height: 8),
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
                      child: Row(
                        children: [
                          Icon(
                            Icons.work_outline,
                            color: career['color'],
                            size: 20,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            career['workEnvironment'],
                            style: const TextStyle(
                              fontSize: 15,
                              color: Color(0xFF2C3A2A),
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 20),
                    
                    // Daily Tasks
                    const Text(
                      'What You\'ll Do Daily',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF2C3A2A),
                      ),
                    ),
                    const SizedBox(height: 8),
                    ...career['dailyTasks'].map<Widget>((task) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.check_circle_outline,
                              size: 16,
                              color: career['color'],
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                task,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey.shade700,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                    
                    const SizedBox(height: 20),
                    
                    // Action buttons
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: career['color'],
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                            ),
                            child: const Text('Save Career'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {},
                            style: OutlinedButton.styleFrom(
                              foregroundColor: const Color(0xFF2C3A2A),
                              side: const BorderSide(color: Color(0xFF2C3A2A)),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                            ),
                            child: const Text('Explore Similar'),
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoChip({
    required IconData icon,
    required String label,
    Color? color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
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
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 16,
            color: color ?? Colors.grey.shade600,
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: color ?? Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}