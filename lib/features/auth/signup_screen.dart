import 'package:flutter/material.dart';
import 'package:bekon/features/dashboard/dashboard_screen.dart';
import 'package:bekon/features/auth/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _isLoading = false;
  bool _acceptTerms = false;
  bool _acceptMarketing = false;
  
  int _currentStep = 0;
  
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

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
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _handleSignUp() async {
    if (!_formKey.currentState!.validate()) return;
    
    if (!_acceptTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please accept the terms and conditions'),
          backgroundColor: Colors.orange,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }
    
    setState(() => _isLoading = true);
    
    // Simulate network delay (replace with actual Firebase later)
    await Future.delayed(const Duration(seconds: 2));
    
    if (!mounted) return;
    
    // Save user data
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', true);
    await prefs.setString('userName', _fullNameController.text);
    await prefs.setString('userEmail', _emailController.text);
    await prefs.setBool('hasCompletedOnboarding', true);
    
    setState(() => _isLoading = false);
    
    if (!mounted) return;
    
    // Navigate to assessment or dashboard
    _showWelcomeDialog();
  }

  void _showWelcomeDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Welcome to Bekon!'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF2C3A2A).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.celebration,
                  color: Color(0xFF2C3A2A),
                  size: 48,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Your account has been created successfully. Would you like to take the assessment now to discover your career path?',
                textAlign: TextAlign.center,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const DashboardScreen()),
                );
              },
              child: const Text('Maybe later'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/assessment-intro');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2C3A2A),
              ),
              child: const Text('Start Assessment'),
            ),
          ],
        );
      },
    );
  }

  String? _validateFullName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Full name is required';
    }
    if (value.length < 2) {
      return 'Name must be at least 2 characters';
    }
    if (value.contains(RegExp(r'[0-9]'))) {
      return 'Name cannot contain numbers';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    final emailRegex = RegExp(r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+');
    if (!emailRegex.hasMatch(value)) {
      return 'Enter a valid email';
    }
    return null;
  }

  String? _validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return null; // Phone is optional
    }
    final phoneRegex = RegExp(r'^[0-9]{10,15}$');
    if (!phoneRegex.hasMatch(value.replaceAll(RegExp(r'[\s-]'), ''))) {
      return 'Enter a valid phone number';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }
    if (!value.contains(RegExp(r'[A-Z]'))) {
      return 'Include at least one uppercase letter';
    }
    if (!value.contains(RegExp(r'[0-9]'))) {
      return 'Include at least one number';
    }
    if (!value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      return 'Include at least one special character';
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    if (value != _passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  Widget _buildProgressIndicator() {
    return Row(
      children: [
        _buildStepIndicator(0, 'Account'),
        _buildStepConnector(0),
        _buildStepIndicator(1, 'Details'),
        _buildStepConnector(1),
        _buildStepIndicator(2, 'Preferences'),
      ],
    );
  }

  Widget _buildStepIndicator(int step, String label) {
    final isActive = step <= _currentStep;
    final isCompleted = step < _currentStep;
    
    return Expanded(
      child: Column(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isActive ? const Color(0xFF2C3A2A) : Colors.grey.shade200,
              border: isActive ? null : Border.all(color: Colors.grey.shade400),
            ),
            child: Center(
              child: isCompleted
                  ? const Icon(Icons.check, color: Colors.white, size: 16)
                  : Text(
                      '${step + 1}',
                      style: TextStyle(
                        color: isActive ? Colors.white : Colors.grey.shade600,
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                    ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              color: isActive ? const Color(0xFF2C3A2A) : Colors.grey.shade500,
              fontWeight: isActive ? FontWeight.w500 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepConnector(int step) {
    final isActive = step < _currentStep;
    return Container(
      width: 20,
      height: 2,
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFF2C3A2A) : Colors.grey.shade300,
        borderRadius: BorderRadius.circular(1),
      ),
    );
  }

  Widget _buildStep1() {
    return Column(
      children: [
        // Full Name
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
          child: TextFormField(
            controller: _fullNameController,
            validator: _validateFullName,
            enabled: !_isLoading,
            decoration: InputDecoration(
              hintText: 'Full name',
              prefixIcon: Icon(
                Icons.person_outline,
                color: const Color(0xFF2C3A2A).withOpacity(0.5),
                size: 20,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(vertical: 16),
            ),
          ),
        ),
        
        const SizedBox(height: 16),
        
        // Email
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
          child: TextFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            validator: _validateEmail,
            enabled: !_isLoading,
            decoration: InputDecoration(
              hintText: 'Email address',
              prefixIcon: Icon(
                Icons.email_outlined,
                color: const Color(0xFF2C3A2A).withOpacity(0.5),
                size: 20,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(vertical: 16),
            ),
          ),
        ),
        
        const SizedBox(height: 16),
        
        // Phone (optional)
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
          child: TextFormField(
            controller: _phoneController,
            keyboardType: TextInputType.phone,
            validator: _validatePhone,
            enabled: !_isLoading,
            decoration: InputDecoration(
              hintText: 'Phone number (optional)',
              prefixIcon: Icon(
                Icons.phone_outlined,
                color: const Color(0xFF2C3A2A).withOpacity(0.5),
                size: 20,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(vertical: 16),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStep2() {
    return Column(
      children: [
        // Password
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
          child: TextFormField(
            controller: _passwordController,
            obscureText: !_isPasswordVisible,
            validator: _validatePassword,
            enabled: !_isLoading,
            decoration: InputDecoration(
              hintText: 'Password',
              prefixIcon: Icon(
                Icons.lock_outline,
                color: const Color(0xFF2C3A2A).withOpacity(0.5),
                size: 20,
              ),
              suffixIcon: IconButton(
                icon: Icon(
                  _isPasswordVisible ? Icons.visibility_off : Icons.visibility,
                  color: Colors.grey,
                  size: 20,
                ),
                onPressed: () {
                  setState(() {
                    _isPasswordVisible = !_isPasswordVisible;
                  });
                },
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(vertical: 16),
            ),
          ),
        ),
        
        const SizedBox(height: 8),
        
        // Password requirements
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Icon(
                Icons.info_outline,
                size: 12,
                color: Colors.grey.shade500,
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  'Minimum 8 characters with uppercase, number & symbol',
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.grey.shade500,
                  ),
                ),
              ),
            ],
          ),
        ),
        
        const SizedBox(height: 16),
        
        // Confirm Password
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
          child: TextFormField(
            controller: _confirmPasswordController,
            obscureText: !_isConfirmPasswordVisible,
            validator: _validateConfirmPassword,
            enabled: !_isLoading,
            decoration: InputDecoration(
              hintText: 'Confirm password',
              prefixIcon: Icon(
                Icons.lock_outline,
                color: const Color(0xFF2C3A2A).withOpacity(0.5),
                size: 20,
              ),
              suffixIcon: IconButton(
                icon: Icon(
                  _isConfirmPasswordVisible ? Icons.visibility_off : Icons.visibility,
                  color: Colors.grey,
                  size: 20,
                ),
                onPressed: () {
                  setState(() {
                    _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                  });
                },
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(vertical: 16),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStep3() {
    return Column(
      children: [
        // Terms and conditions
        Container(
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
            children: [
              Row(
                children: [
                  SizedBox(
                    height: 24,
                    width: 24,
                    child: Checkbox(
                      value: _acceptTerms,
                      onChanged: _isLoading ? null : (value) {
                        setState(() {
                          _acceptTerms = value ?? false;
                        });
                      },
                      activeColor: const Color(0xFF2C3A2A),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        text: 'I accept the ',
                        style: TextStyle(color: Colors.grey.shade700, fontSize: 14),
                        children: [
                          TextSpan(
                            text: 'Terms of Service',
                            style: const TextStyle(
                              color: Color(0xFF2C3A2A),
                              fontWeight: FontWeight.w600,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                          TextSpan(text: ' and '),
                          TextSpan(
                            text: 'Privacy Policy',
                            style: const TextStyle(
                              color: Color(0xFF2C3A2A),
                              fontWeight: FontWeight.w600,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 16),
              
              Row(
                children: [
                  SizedBox(
                    height: 24,
                    width: 24,
                    child: Checkbox(
                      value: _acceptMarketing,
                      onChanged: _isLoading ? null : (value) {
                        setState(() {
                          _acceptMarketing = value ?? false;
                        });
                      },
                      activeColor: const Color(0xFF2C3A2A),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'I want to receive career tips and updates (optional)',
                      style: TextStyle(color: Colors.grey.shade700, fontSize: 14),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        
        const SizedBox(height: 24),
        
        // Age confirmation
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF2C3A2A).withOpacity(0.05),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Icon(
                Icons.verified_user_outlined,
                size: 20,
                color: const Color(0xFF2C3A2A).withOpacity(0.7),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'By creating an account, you confirm that you are at least 13 years old',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade700,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F0),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Back button and header
                FadeTransition(
                  opacity: _fadeAnimation,
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
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: const Color(0xFF2C3A2A),
                          shape: BoxShape.circle,
                        ),
                        child: const Center(
                          child: Text(
                            'B',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 20),
                
                // Progress indicator
                _buildProgressIndicator(),
                
                const SizedBox(height: 24),
                
                // Title
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: Text(
                    _currentStep == 0 ? 'Create your account' :
                    _currentStep == 1 ? 'Secure your account' :
                    'Almost there!',
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w300,
                      color: Color(0xFF2C3A2A),
                    ),
                  ),
                ),
                
                const SizedBox(height: 8),
                
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: Text(
                    _currentStep == 0 ? 'Tell us about yourself' :
                    _currentStep == 1 ? 'Create a strong password' :
                    'Review and accept terms',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ),
                
                const SizedBox(height: 32),
                
                // Form
                SlideTransition(
                  position: _slideAnimation,
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        // Step content
                        if (_currentStep == 0) _buildStep1(),
                        if (_currentStep == 1) _buildStep2(),
                        if (_currentStep == 2) _buildStep3(),
                        
                        const SizedBox(height: 32),
                        
                        // Navigation buttons
                        Row(
                          children: [
                            if (_currentStep > 0)
                              Expanded(
                                child: OutlinedButton(
                                  onPressed: _isLoading ? null : () {
                                    setState(() {
                                      _currentStep--;
                                    });
                                  },
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: const Color(0xFF2C3A2A),
                                    side: const BorderSide(color: Color(0xFF2C3A2A)),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    padding: const EdgeInsets.symmetric(vertical: 16),
                                  ),
                                  child: const Text('Back'),
                                ),
                              ),
                            if (_currentStep > 0) const SizedBox(width: 16),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: _isLoading ? null : () {
                                  if (_formKey.currentState!.validate()) {
                                    if (_currentStep < 2) {
                                      setState(() {
                                        _currentStep++;
                                      });
                                    } else {
                                      _handleSignUp();
                                    }
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF2C3A2A),
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  padding: const EdgeInsets.symmetric(vertical: 16),
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
                                    : Text(_currentStep < 2 ? 'Continue' : 'Create Account'),
                              ),
                            ),
                          ],
                        ),
                        
                        const SizedBox(height: 24),
                        
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
                              onTap: _isLoading ? null : () {
                                Navigator.pushReplacement(
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
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}