import 'package:flutter/material.dart';
import 'package:bekon/features/splash/splash_screen.dart';
import 'package:bekon/features/onboarding/welcome_screen.dart';
import 'package:bekon/features/onboarding/assessment_intro_screen.dart';
import 'package:bekon/features/assessment/aptitude_game_screen.dart';
import 'package:bekon/features/results/results_screen.dart';
import 'package:bekon/features/auth/login_screen.dart';
import 'package:bekon/features/auth/signup_screen.dart';
import 'package:bekon/features/auth/forgot_password_screen.dart';
import 'package:bekon/features/dashboard/dashboard_screen.dart';
import 'package:bekon/features/careers/career_detail_screen.dart';
import 'package:bekon/features/careers/career_list_screen.dart';
import 'package:bekon/features/profile/profile_screen.dart';
import 'package:bekon/features/settings/settings_screen.dart';
import 'package:bekon/features/settings/notifications_screen.dart';
import 'package:bekon/features/settings/privacy_screen.dart';
import 'package:bekon/features/settings/help_screen.dart';
import 'package:bekon/features/settings/about_screen.dart';
import 'package:bekon/features/history/history_screen.dart';
import 'package:bekon/features/stats/stats_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize shared preferences
  await SharedPreferences.getInstance();
  
  runApp(const BekonApp());
}

class BekonApp extends StatelessWidget {
  const BekonApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bekon',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Inter',
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2C3A2A),
          brightness: Brightness.light,
        ),
        appBarTheme: const AppBarTheme(
          centerTitle: false,
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF2C3A2A), width: 1),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.red),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF2C3A2A),
            foregroundColor: Colors.white,
            minimumSize: const Size(double.infinity, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        cardTheme: CardTheme(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          color: Colors.white,
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Inter',
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2C3A2A),
          brightness: Brightness.dark,
        ),
      ),
      themeMode: ThemeMode.system,
      initialRoute: '/',
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/':
            return MaterialPageRoute(builder: (_) => const SplashScreen());
          case '/welcome':
            return MaterialPageRoute(builder: (_) => const WelcomeScreen());
          case '/login':
            return MaterialPageRoute(builder: (_) => const LoginScreen());
          case '/signup':
            return MaterialPageRoute(builder: (_) => const SignupScreen());
          case '/forgot-password':
            return MaterialPageRoute(builder: (_) => const ForgotPasswordScreen());
          case '/assessment-intro':
            return MaterialPageRoute(builder: (_) => const AssessmentIntroScreen());
          case '/assessment':
            return MaterialPageRoute(builder: (_) => const AptitudeGameScreen());
          case '/results':
            if (settings.arguments != null) {
              final args = settings.arguments as Map<String, dynamic>;
              return MaterialPageRoute(
                builder: (_) => ResultsScreen(
                  score: args['score'],
                  categoryScores: args['categoryScores'],
                ),
              );
            }
            return MaterialPageRoute(builder: (_) => const ResultsScreen(score: 0, categoryScores: {}));
          case '/dashboard':
            return MaterialPageRoute(builder: (_) => const DashboardScreen());
          case '/careers':
            return MaterialPageRoute(builder: (_) => const CareerListScreen());
          case '/career-detail':
            if (settings.arguments != null) {
              final args = settings.arguments as Map<String, dynamic>;
              return MaterialPageRoute(
                builder: (_) => CareerDetailScreen(career: args['career']),
              );
            }
            return MaterialPageRoute(builder: (_) => const CareerDetailScreen(career: {}));
          case '/profile':
            return MaterialPageRoute(builder: (_) => const ProfileScreen());
          case '/settings':
            return MaterialPageRoute(builder: (_) => const SettingsScreen());
          case '/notifications':
            return MaterialPageRoute(builder: (_) => const NotificationsScreen());
          case '/privacy':
            return MaterialPageRoute(builder: (_) => const PrivacyScreen());
          case '/help':
            return MaterialPageRoute(builder: (_) => const HelpScreen());
          case '/about':
            return MaterialPageRoute(builder: (_) => const AboutScreen());
          case '/history':
            return MaterialPageRoute(builder: (_) => const HistoryScreen());
          case '/stats':
            return MaterialPageRoute(builder: (_) => const StatsScreen());
          default:
            return MaterialPageRoute(builder: (_) => const SplashScreen());
        }
      },
    );
  }
}