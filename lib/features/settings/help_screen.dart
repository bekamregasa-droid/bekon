import 'package:flutter/material.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  final List<Map<String, dynamic>> _faqs = const [
    {
      'question': 'How does the career assessment work?',
      'answer': 'Our assessment uses 6 different cognitive games to measure your natural abilities in pattern recognition, spatial reasoning, verbal ability, numerical reasoning, creative thinking, and emotional intelligence.',
    },
    {
      'question': 'How accurate are the results?',
      'answer': 'Bekon has 92% accuracy in matching users with careers that align with their natural strengths. Our algorithm is based on career psychology research and continuous learning from user outcomes.',
    },
    {
      'question': 'Can I retake the assessment?',
      'answer': 'Yes, you can retake the assessment every 6 months to track your progress or if you feel your results don\'t reflect your current abilities.',
    },
    {
      'question': 'How is my data protected?',
      'answer': 'All your data is encrypted and stored securely. We never share your personal information without your explicit consent. Read our Privacy Policy for details.',
    },
    {
      'question': 'Can I save careers for later?',
      'answer': 'Absolutely! You can save careers to your profile, add notes, and track your interest in different paths over time.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F0),
      appBar: AppBar(
        title: const Text(
          'Help Center',
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
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // Search Bar
              Container(
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
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search for help...',
                    prefixIcon: Icon(Icons.search, color: Colors.grey.shade400),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Quick Help Categories
              Row(
                children: [
                  Expanded(
                    child: _buildQuickHelpCard(
                      icon: Icons.assignment_outlined,
                      title: 'Assessment',
                      color: const Color(0xFF2563EB),
                      onTap: () {},
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildQuickHelpCard(
                      icon: Icons.work_outline,
                      title: 'Careers',
                      color: const Color(0xFF7C3AED),
                      onTap: () {},
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 12),
              
              Row(
                children: [
                  Expanded(
                    child: _buildQuickHelpCard(
                      icon: Icons.account_circle_outlined,
                      title: 'Account',
                      color: const Color(0xFF059669),
                      onTap: () {},
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildQuickHelpCard(
                      icon: Icons.payment_outlined,
                      title: 'Billing',
                      color: const Color(0xFFDC2626),
                      onTap: () {},
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 24),
              
              // FAQ Section
              const Row(
                children: [
                  Icon(Icons.help_outline, color: Color(0xFF2C3A2A), size: 20),
                  SizedBox(width: 8),
                  Text(
                    'Frequently Asked Questions',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF2C3A2A),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 16),
              
              // FAQ List
              ..._faqs.map((faq) => _buildFaqItem(faq['question'], faq['answer'])),
              
              const SizedBox(height: 24),
              
              // Contact Support
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF2C3A2A).withOpacity(0.05),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2C3A2A),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.headset_mic,
                        color: Colors.white,
                        size: 32,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Still need help?',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF2C3A2A),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Our support team is ready to assist you',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2C3A2A),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: const Text('Contact Support'),
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickHelpCard({
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
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
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Color(0xFF2C3A2A),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFaqItem(String question, String answer) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide.none,
        ),
        collapsedShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide.none,
        ),
        backgroundColor: Colors.white,
        collapsedBackgroundColor: Colors.white,
        title: Text(
          question,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: Color(0xFF2C3A2A),
          ),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Text(
              answer,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade700,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}