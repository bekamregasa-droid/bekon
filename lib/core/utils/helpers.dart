import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Helpers {
  static void showSnackBar(
    BuildContext context, {
    required String message,
    bool isError = false,
    Duration duration = const Duration(seconds: 3),
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? const Color(0xFFBA4A4A) : const Color(0xFF2C3A2A),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        duration: duration,
      ),
    );
  }

  static Future<void> saveUserData({
    required String name,
    required String email,
    String? phone,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userName', name);
    await prefs.setString('userEmail', email);
    if (phone != null) {
      await prefs.setString('userPhone', phone);
    }
  }

  static Future<Map<String, String?>> getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'name': prefs.getString('userName'),
      'email': prefs.getString('userEmail'),
      'phone': prefs.getString('userPhone'),
    };
  }

  static String getInitials(String name) {
    if (name.isEmpty) return '';
    final parts = name.trim().split(' ');
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
  }

  static String formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    
    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        if (difference.inMinutes == 0) {
          return 'Just now';
        }
        return '${difference.inMinutes}m ago';
      }
      return '${difference.inHours}h ago';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else if (difference.inDays < 30) {
      return '${(difference.inDays / 7).floor()}w ago';
    }
    return '${(difference.inDays / 30).floor()}mo ago';
  }

  static Color getColorFromString(String input) {
    final hash = input.hashCode.abs();
    final hue = hash % 360;
    return HSLColor.fromAHSL(1.0, hue.toDouble(), 0.7, 0.6).toColor();
  }

  static String truncate(String text, int length) {
    if (text.length <= length) return text;
    return '${text.substring(0, length)}...';
  }
}