import 'package:flutter/material.dart';
import 'package:bekon/features/onboarding/assessment_intro_screen.dart';
import 'package:bekon/features/auth/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation1;
  late Animation<Offset> _slideAnimation2;
  late Animation<Offset> _slideAnimation3;

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
    
    _slideAnimation1 = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.1, 0.5, curve: Curves.easeOut),
      ),
    );
    
    _slideAnimation2 = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.2, 0.6, curve: Curves.easeOut),
      ),
    );
    
    _slideAnimation3 = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.3, 0.7, curve: Curves.easeOut),
      ),
    );
    
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _markOnboardingComplete() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('hasCompletedOnboarding', true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F0),
      body: SafeArea(
        child: Column(
          children: [
            // Top decorative element
            Container(
              height: 120,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    const Color(0xFF2C3A2A).withOpacity(0.1),
                    const Color(0xFFCBA776).withOpacity(0.1),
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
                    top: -20,
                    right: -20,
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xFF2C3A2A).withOpacity(0.05),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: -30,
                    left: -30,
                    child: Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xFFCBA776).withOpacity(0.05),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    
                    // Brand mark
                    FadeTransition(
                      opacity: _fadeAnimation,
                      child: Container(
                        width: 80,
                        height: 80,
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
                        child: const Center(
                          child: Text(
                            'B',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 40,
                              fontWeight: FontWeight.w300,
                              letterSpacing: 2,
                            ),
                          ),
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 32),
                    
                    // Main headline
                    FadeTransition(
                      opacity: _fadeAnimation,
                      child: Text(
                        'Find work that\nfeels like you',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.w300,
                          height: 1.1,
                          color: const Color(0xFF2C3A2A),
                          letterSpacing: -0.5,
                          shadows: [
                            Shadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Subheadline
                    FadeTransition(
                      opacity: _fadeAnimation,
                      child: Text(
                        'A different approach to career guidance.\nWe help you discover what you\'re naturally drawn to.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey.shade600,
                          height: 1.5,
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 48),
                    
                    // Feature 1
                    SlideTransition(
                      position: _slideAnimation1,
                      child: Container(
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
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: const Color(0xFF2C3A2A).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Icon(
                                Icons.psychology_outlined,
                                color: const Color(0xFF2C3A2A),
                                size: 28,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Natural aptitude assessment',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: const Color(0xFF2C3A2A),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Discover your inherent strengths through engaging exercises',
                                    style: TextStyle(
                                      fontSize: 14,
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
                    
                    const SizedBox(height: 16),
                    
                    // Feature 2
                    SlideTransition(
                      position: _slideAnimation2,
                      child: Container(
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
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: const Color(0xFFCBA776).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Icon(
                                Icons.insights_outlined,
                                color: const Color(0xFFCBA776),
                                size: 28,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Real-world career matching',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: const Color(0xFF2C3A2A),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'See which careers align with your unique profile',
                                    style: TextStyle(
                                      fontSize: 14,
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
                    
                    const SizedBox(height: 16),
                    
                    // Feature 3
                    SlideTransition(
                      position: _slideAnimation3,
                      child: Container(
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
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: const Color(0xFF4A7A5C).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Icon(
                                Icons.auto_awesome_outlined,
                                color: const Color(0xFF4A7A5C),
                                size: 28,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Personalized guidance',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: const Color(0xFF2C3A2A),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Step-by-step path to your ideal career',
                                    style: TextStyle(
                                      fontSize: 14,
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
                    
                    const SizedBox(height: 40),
                    
                    // Trust indicators
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildTrustBadge(Icons.verified_user, '100% Private'),
                        Container(width: 1, height: 20, color: Colors.grey.shade300),
                        _buildTrustBadge(Icons.science, 'Science-based'),
                        Container(width: 1, height: 20, color: Colors.grey.shade300),
                        _buildTrustBadge(Icons.people, '10k+ Users'),
                      ],
                    ),
                    
                    const SizedBox(height: 40),
                    
                    // Get started button
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: () async {
                          await _markOnboardingComplete();
                          if (!mounted) return;
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const AssessmentIntroScreen(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2C3A2A),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: const Text(
                          'Begin your journey',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Sign in link
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Already have an account? ',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const LoginScreen(),
                              ),
                            );
                          },
                          child: const Text(
                            'Sign in',
                            style: TextStyle(
                              color: Color(0xFF2C3A2A),
                              fontWeight: FontWeight.w600,
                              decoration: TextDecoration.underline,
                              decorationColor: Color(0xFF2C3A2A),
                            ),
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTrustBadge(IconData icon, String label) {
    return Expanded(
      child: Column(
        children: [
          Icon(
            icon,
            size: 18,
            color: const Color(0xFF2C3A2A).withOpacity(0.5),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey.shade500,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}