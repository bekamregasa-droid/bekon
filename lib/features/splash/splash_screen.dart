import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bekon/features/onboarding/welcome_screen.dart';
import 'package:bekon/features/dashboard/dashboard_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    
    // Setup animations
    _controller = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
      ),
    );
    
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOutBack),
      ),
    );
    
    _controller.forward();
    
    // Navigate to next screen
    _navigateToNext();
  }

  Future<void> _navigateToNext() async {
    await Future.delayed(const Duration(seconds: 3));
    
    if (!mounted) return;
    
    final prefs = await SharedPreferences.getInstance();
    final hasOnboarded = prefs.getBool('hasCompletedOnboarding') ?? false;
    final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    
    if (!mounted) return;
    
    if (hasOnboarded && isLoggedIn) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const DashboardScreen()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const WelcomeScreen()),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF2C3A2A), // Deep Olive
              Color(0xFF3E4F3C), // Lighter Olive
            ],
          ),
        ),
        child: Stack(
          children: [
            // Background pattern (subtle)
            Positioned.fill(
              child: CustomPaint(
                painter: _BackgroundPatternPainter(),
              ),
            ),
            
            // Main content
            Center(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: ScaleTransition(
                  scale: _scaleAnimation,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Logo container with shadow
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 20,
                              spreadRadius: 5,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            'B',
                            style: TextStyle(
                              fontSize: 60,
                              fontWeight: FontWeight.w300,
                              color: const Color(0xFF2C3A2A),
                              letterSpacing: 2,
                              shadows: [
                                Shadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 5,
                                  offset: const Offset(2, 2),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
                      
                      // App name
                      Text(
                        'BEKON',
                        style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.w300,
                          color: Colors.white,
                          letterSpacing: 12,
                          shadows: [
                            Shadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 10,
                              offset: const Offset(2, 2),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      
                      // Tagline
                      Text(
                        'discover your path',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w300,
                          color: Colors.white.withOpacity(0.8),
                          letterSpacing: 3,
                          shadows: [
                            Shadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 5,
                              offset: const Offset(1, 1),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 48),
                      
                      // Loading indicator with custom styling
                      SizedBox(
                        height: 40,
                        width: 40,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white.withOpacity(0.8),
                          ),
                          backgroundColor: Colors.white.withOpacity(0.2),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            
            // Version number at bottom
            Positioned(
              bottom: 24,
              left: 0,
              right: 0,
              child: Center(
                child: Text(
                  'Version 1.0.0',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white.withOpacity(0.4),
                    letterSpacing: 1,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Custom painter for subtle background pattern
class _BackgroundPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.03)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    
    final path = Path();
    final spacing = 40.0;
    
    // Draw diagonal lines
    for (double i = -size.height; i < size.width + size.height; i += spacing) {
      path.reset();
      path.moveTo(i, 0);
      path.lineTo(i - size.height, size.height);
      canvas.drawPath(path, paint);
    }
    
    // Draw dots at intersections
    final dotPaint = Paint()
      ..color = Colors.white.withOpacity(0.02)
      ..style = PaintingStyle.fill;
    
    for (double x = 0; x < size.width; x += spacing) {
      for (double y = 0; y < size.height; y += spacing) {
        canvas.drawCircle(Offset(x, y), 2, dotPaint);
      }
    }
  }
  
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Additional loading widget for future use
class BekonLoadingIndicator extends StatelessWidget {
  final String? message;
  final Color? color;
  
  const BekonLoadingIndicator({
    Key? key,
    this.message,
    this.color,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 40,
            width: 40,
            child: CircularProgressIndicator(
              strokeWidth: 2.5,
              valueColor: AlwaysStoppedAnimation<Color>(
                color ?? const Color(0xFF2C3A2A),
              ),
            ),
          ),
          if (message != null) ...[
            const SizedBox(height: 16),
            Text(
              message!,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF5C6B5A),
              ),
            ),
          ],
        ],
      ),
    );
  }
}