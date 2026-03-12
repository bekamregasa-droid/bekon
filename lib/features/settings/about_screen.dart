import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F0),
      appBar: AppBar(
        title: const Text(
          'About',
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
              // Logo
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
                      color: const Color(0xFF2C3A2A).withOpacity(0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: const Center(
                  child: Text(
                    'B',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 48,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ),
              ),
              
              const SizedBox(height: 20),
              
              // App Name
              const Text(
                'Bekon',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w300,
                  color: Color(0xFF2C3A2A),
                  letterSpacing: 2,
                ),
              ),
              
              const SizedBox(height: 4),
              
              // Tagline
              Text(
                'Discover your career path',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                  letterSpacing: 0.5,
                ),
              ),
              
              const SizedBox(height: 8),
              
              // Version
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFF2C3A2A).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'Version 1.0.0',
                  style: TextStyle(
                    color: Color(0xFF2C3A2A),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              
              const SizedBox(height: 32),
              
              // Description
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.03),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    const Text(
                      'Bekon helps you discover careers that align with your natural strengths and personality. Our AI-powered assessment uses cognitive games to measure your abilities across 6 dimensions, then matches you with careers where you\'ll thrive.',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF2C3A2A),
                        height: 1.6,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Divider(),
                    const SizedBox(height: 16),
                    _buildInfoRow('Founded', '2024'),
                    _buildInfoRow('Headquarters', 'San Francisco, CA'),
                    _buildInfoRow('Users', '10,000+'),
                    _buildInfoRow('Countries', '45+'),
                  ],
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Team Section
              const Row(
                children: [
                  Icon(Icons.people_outline, color: Color(0xFF2C3A2A), size: 20),
                  SizedBox(width: 8),
                  Text(
                    'Our Team',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF2C3A2A),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 16),
              
              Row(
                children: [
                  Expanded(
                    child: _buildTeamMember(
                      name: 'Alex Chen',
                      role: 'Founder & CEO',
                      initial: 'A',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildTeamMember(
                      name: 'Sarah Kim',
                      role: 'Head of Product',
                      initial: 'S',
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 12),
              
              Row(
                children: [
                  Expanded(
                    child: _buildTeamMember(
                      name: 'Marcus Wright',
                      role: 'Lead Engineer',
                      initial: 'M',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildTeamMember(
                      name: 'Elena Rodriguez',
                      role: 'Career Psychologist',
                      initial: 'E',
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 24),
              
              // Links
              _buildLinkTile(
                icon: Icons.privacy_tip_outlined,
                title: 'Privacy Policy',
                onTap: () {},
              ),
              _buildLinkTile(
                icon: Icons.description_outlined,
                title: 'Terms of Service',
                onTap: () {},
              ),
              _buildLinkTile(
                icon: Icons.gavel_outlined,
                title: 'Licenses',
                onTap: () {},
              ),
              _buildLinkTile(
                icon: Icons.code_outlined,
                title: 'Open Source Libraries',
                onTap: () {},
              ),
              
              const SizedBox(height: 30),
              
              // Copyright
              Text(
                '© 2024 Bekon Labs. All rights reserved.',
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey.shade400,
                ),
              ),
              
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey.shade600,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Color(0xFF2C3A2A),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTeamMember({
    required String name,
    required String role,
    required String initial,
  }) {
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
        children: [
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
            ),
            child: Center(
              child: Text(
                initial,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            name,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF2C3A2A),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            role,
            style: TextStyle(
              fontSize: 10,
              color: Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLinkTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      onTap: onTap,
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
          fontSize: 15,
          color: Color(0xFF2C3A2A),
        ),
      ),
      trailing: Icon(Icons.launch, color: Colors.grey.shade400, size: 16),
    );
  }
}