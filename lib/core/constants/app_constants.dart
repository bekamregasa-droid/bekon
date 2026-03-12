class AppConstants {
  // App Info
  static const String appName = 'Bekon';
  static const String appVersion = '1.0.0';
  static const String companyName = 'Bekon Labs';
  static const String supportEmail = 'support@bekon.com';
  
  // Storage Keys
  static const String onboardedKey = 'hasCompletedOnboarding';
  static const String isLoggedInKey = 'isLoggedIn';
  static const String userNameKey = 'userName';
  static const String userEmailKey = 'userEmail';
  static const String userPhoneKey = 'userPhone';
  static const String assessmentCompletedKey = 'assessmentCompleted';
  static const String assessmentScoreKey = 'assessmentScore';
  static const String savedCareersKey = 'savedCareers';
  static const String themeModeKey = 'themeMode';
  static const String notificationsEnabledKey = 'notificationsEnabled';
  
  // Assessment Constants
  static const int minAssessmentQuestions = 5;
  static const int maxAssessmentQuestions = 30;
  static const int assessmentTimeMinutes = 20;
  
  // Career Categories
  static const List<Map<String, dynamic>> careerCategories = [
    {'id': 'tech', 'name': 'Technology', 'icon': Icons.computer, 'color': 0xFF2563EB},
    {'id': 'healthcare', 'name': 'Healthcare', 'icon': Icons.local_hospital, 'color': 0xFF059669},
    {'id': 'creative', 'name': 'Creative Arts', 'icon': Icons.palette, 'color': 0xFFEA580C},
    {'id': 'business', 'name': 'Business', 'icon': Icons.business_center, 'color': 0xFF7C3AED},
    {'id': 'engineering', 'name': 'Engineering', 'icon': Icons.engineering, 'color': 0xFF2563EB},
    {'id': 'education', 'name': 'Education', 'icon': Icons.school, 'color': 0xFFBE185D},
    {'id': 'legal', 'name': 'Legal', 'icon': Icons.gavel, 'color': 0xFF92400E},
    {'id': 'science', 'name': 'Science', 'icon': Icons.science, 'color': 0xFF059669},
  ];
  
  // Error Messages
  static const String networkError = 'Network connection error. Please check your internet.';
  static const String serverError = 'Server error. Please try again later.';
  static const String authError = 'Authentication failed. Please sign in again.';
  static const String unknownError = 'An unexpected error occurred.';
}

class AppColors {
  static const Color primary = Color(0xFF2C3A2A);
  static const Color primaryLight = Color(0xFF3E4F3C);
  static const Color primaryDark = Color(0xFF1A2319);
  static const Color secondary = Color(0xFFCBA776);
  static const Color secondaryLight = Color(0xFFDBC29F);
  static const Color secondaryDark = Color(0xFFB48B54);
  static const Color background = Color(0xFFF5F5F0);
  static const Color surface = Colors.white;
  static const Color error = Color(0xFFBA4A4A);
  static const Color success = Color(0xFF4A7A5C);
  static const Color warning = Color(0xFFE6B800);
  static const Color textPrimary = Color(0xFF2C3A2A);
  static const Color textSecondary = Color(0xFF5C6B5A);
  static const Color textHint = Color(0xFF8C9A8A);
}

class AppStrings {
  static const String appName = 'Bekon';
  static const String tagline = 'Discover your career path';
  
  // Auth Strings
  static const String login = 'Login';
  static const String signup = 'Sign Up';
  static const String email = 'Email';
  static const String password = 'Password';
  static const String forgotPassword = 'Forgot Password?';
  static const String rememberMe = 'Remember me';
  
  // Onboarding Strings
  static const String welcome = 'Welcome to Bekon';
  static const String getStarted = 'Get Started';
  static const String alreadyHaveAccount = 'Already have an account?';
  
  // Assessment Strings
  static const String startAssessment = 'Start Assessment';
  static const String assessmentIntro = 'Let\'s discover your strengths';
  static const String assessmentComplete = 'Assessment Complete!';
  
  // Dashboard Strings
  static const String home = 'Home';
  static const String explore = 'Explore';
  static const String profile = 'Profile';
  static const String settings = 'Settings';
}