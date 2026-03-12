import 'package:flutter/material.dart';
import 'package:bekon/features/auth/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bekon/features/settings/notifications_screen.dart';
import 'package:bekon/features/settings/privacy_screen.dart';
import 'package:bekon/features/settings/help_screen.dart';
import 'package:bekon/features/settings/about_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> with SingleTickerProviderStateMixin {
  bool _isDarkMode = false;
  bool _isLoading = false;
  String _appVersion = '1.0.0';
  double _textSize = 1.0;
  String _language = 'English';
  bool _autoSave = true;
  bool _analyticsEnabled = true;
  bool _crashReporting = true;
  String _storageUsed = '245 MB';
  String _cacheSize = '128 MB';
  
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  final List<Map<String, dynamic>> _languages = [
    {'code': 'en', 'name': 'English', 'flag': '🇺🇸'},
    {'code': 'es', 'name': 'Spanish', 'flag': '🇪🇸'},
    {'code': 'fr', 'name': 'French', 'flag': '🇫🇷'},
    {'code': 'de', 'name': 'German', 'flag': '🇩🇪'},
    {'code': 'zh', 'name': 'Chinese', 'flag': '🇨🇳'},
    {'code': 'ja', 'name': 'Japanese', 'flag': '🇯🇵'},
  ];

  final List<Map<String, dynamic>> _textSizes = [
    {'value': 0.8, 'label': 'Small'},
    {'value': 1.0, 'label': 'Medium'},
    {'value': 1.2, 'label': 'Large'},
    {'value': 1.4, 'label': 'Extra Large'},
  ];

  @override
  void initState() {
    super.initState();
    
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
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
    _loadSettings();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isDarkMode = prefs.getBool('darkMode') ?? false;
      _language = prefs.getString('language') ?? 'English';
      _autoSave = prefs.getBool('autoSave') ?? true;
      _analyticsEnabled = prefs.getBool('analytics') ?? true;
    });
  }

  Future<void> _saveSetting(String key, dynamic value) async {
    final prefs = await SharedPreferences.getInstance();
    if (value is bool) {
      await prefs.setBool(key, value);
    } else if (value is String) {
      await prefs.setString(key, value);
    } else if (value is double) {
      await prefs.setDouble(key, value);
    }
  }

  Future<void> _clearCache() async {
    setState(() => _isLoading = true);
    
    // Simulate cache clearing
    await Future.delayed(const Duration(seconds: 2));
    
    setState(() {
      _cacheSize = '0 MB';
      _isLoading = false;
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Cache cleared successfully'),
        backgroundColor: Color(0xFF2C3A2A),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Select Language'),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: _languages.length,
              itemBuilder: (context, index) {
                final lang = _languages[index];
                final isSelected = lang['name'] == _language;
                
                return ListTile(
                  leading: Text(
                    lang['flag'],
                    style: const TextStyle(fontSize: 24),
                  ),
                  title: Text(lang['name']),
                  trailing: isSelected
                      ? const Icon(Icons.check, color: Color(0xFF2C3A2A))
                      : null,
                  onTap: () {
                    setState(() {
                      _language = lang['name'];
                      _saveSetting('language', lang['name']);
                    });
                    Navigator.pop(context);
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }

  void _showTextSizeDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Text Size'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: _textSizes.map((size) {
              final isSelected = size['value'] == _textSize;
              
              return RadioListTile(
                title: Text(size['label']),
                value: size['value'],
                groupValue: _textSize,
                activeColor: const Color(0xFF2C3A2A),
                onChanged: (value) {
                  setState(() {
                    _textSize = value as double;
                    _saveSetting('textSize', value);
                  });
                  Navigator.pop(context);
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }

  void _showSignOutDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Sign Out'),
          content: const Text('Are you sure you want to sign out?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                final prefs = await SharedPreferences.getInstance();
                await prefs.setBool('isLoggedIn', false);
                
                if (!context.mounted) return;
                
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                  (route) => false,
                );
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.red,
              ),
              child: const Text('Sign Out'),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteAccountDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Account'),
          content: const Text(
            'This action cannot be undone. All your data will be permanently deleted. Are you absolutely sure?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _showFinalConfirmationDialog();
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.red,
              ),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  void _showFinalConfirmationDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Final Confirmation'),
          content: const Text(
            'Type "DELETE" to confirm account deletion',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Implement actual account deletion
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Account deletion requested'),
                    backgroundColor: Colors.red,
                  ),
                );
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.red,
              ),
              child: const Text('Confirm'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F0),
      appBar: AppBar(
        title: const Text(
          'Settings',
          style: TextStyle(
            color: Color(0xFF2C3A2A),
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Color(0xFF2C3A2A)),
            onPressed: _loadSettings,
          ),
        ],
      ),
      body: SafeArea(
        child: _isLoading
            ? const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF2C3A2A)),
                ),
              )
            : SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          // Profile Summary Card
                          _buildProfileCard(),
                          
                          const SizedBox(height: 24),
                          
                          // Appearance Section
                          _buildSectionHeader(
                            'Appearance',
                            Icons.palette_outlined,
                          ),
                          const SizedBox(height: 12),
                          _buildSettingsCard([
                            _buildSwitchTile(
                              icon: Icons.dark_mode_outlined,
                              title: 'Dark Mode',
                              subtitle: 'Switch between light and dark theme',
                              value: _isDarkMode,
                              onChanged: (value) {
                                setState(() {
                                  _isDarkMode = value;
                                  _saveSetting('darkMode', value);
                                });
                              },
                            ),
                            _buildDivider(),
                            _buildListTile(
                              icon: Icons.text_fields,
                              title: 'Text Size',
                              subtitle: _textSizes.firstWhere(
                                (s) => s['value'] == _textSize,
                                orElse: () => _textSizes[1],
                              )['label'],
                              onTap: _showTextSizeDialog,
                            ),
                            _buildDivider(),
                            _buildListTile(
                              icon: Icons.language,
                              title: 'Language',
                              subtitle: _language,
                              onTap: _showLanguageDialog,
                            ),
                          ]),
                          
                          const SizedBox(height: 20),
                          
                          // Notifications Section
                          _buildSectionHeader(
                            'Notifications',
                            Icons.notifications_outlined,
                          ),
                          const SizedBox(height: 12),
                          _buildSettingsCard([
                            _buildNavigationTile(
                              icon: Icons.notifications_active_outlined,
                              title: 'Notification Settings',
                              subtitle: 'Manage your alerts and reminders',
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const NotificationsScreen(),
                                  ),
                                );
                              },
                            ),
                            _buildDivider(),
                            _buildSwitchTile(
                              icon: Icons.auto_awesome_outlined,
                              title: 'Smart Recommendations',
                              subtitle: 'Get personalized career alerts',
                              value: true,
                              onChanged: (value) {},
                            ),
                          ]),
                          
                          const SizedBox(height: 20),
                          
                          // Privacy Section
                          _buildSectionHeader(
                            'Privacy & Security',
                            Icons.security_outlined,
                          ),
                          const SizedBox(height: 12),
                          _buildSettingsCard([
                            _buildNavigationTile(
                              icon: Icons.lock_outline,
                              title: 'Privacy Settings',
                              subtitle: 'Control your data and visibility',
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const PrivacyScreen(),
                                  ),
                                );
                              },
                            ),
                            _buildDivider(),
                            _buildSwitchTile(
                              icon: Icons.analytics_outlined,
                              title: 'Usage Analytics',
                              subtitle: 'Help us improve the app',
                              value: _analyticsEnabled,
                              onChanged: (value) {
                                setState(() {
                                  _analyticsEnabled = value;
                                  _saveSetting('analytics', value);
                                });
                              },
                            ),
                            _buildDivider(),
                            _buildSwitchTile(
                              icon: Icons.bug_report_outlined,
                              title: 'Crash Reporting',
                              subtitle: 'Automatically send crash reports',
                              value: _crashReporting,
                              onChanged: (value) {
                                setState(() {
                                  _crashReporting = value;
                                  _saveSetting('crashReporting', value);
                                });
                              },
                            ),
                          ]),
                          
                          const SizedBox(height: 20),
                          
                          // Storage Section
                          _buildSectionHeader(
                            'Storage',
                            Icons.storage_outlined,
                          ),
                          const SizedBox(height: 12),
                          _buildSettingsCard([
                            _buildInfoTile(
                              icon: Icons.data_usage,
                              title: 'Storage Used',
                              subtitle: _storageUsed,
                            ),
                            _buildDivider(),
                            _buildInfoTile(
                              icon: Icons.cached,
                              title: 'Cache Size',
                              subtitle: _cacheSize,
                            ),
                            _buildDivider(),
                            _buildActionTile(
                              icon: Icons.cleaning_services,
                              title: 'Clear Cache',
                              subtitle: 'Free up storage space',
                              onTap: _clearCache,
                            ),
                          ]),
                          
                          const SizedBox(height: 20),
                          
                          // Support Section
                          _buildSectionHeader(
                            'Support',
                            Icons.support_agent_outlined,
                          ),
                          const SizedBox(height: 12),
                          _buildSettingsCard([
                            _buildNavigationTile(
                              icon: Icons.help_outline,
                              title: 'Help Center',
                              subtitle: 'FAQs and guides',
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const HelpScreen(),
                                  ),
                                );
                              },
                            ),
                            _buildDivider(),
                            _buildNavigationTile(
                              icon: Icons.email_outlined,
                              title: 'Contact Us',
                              subtitle: 'Get in touch with our team',
                              onTap: () {
                                // Implement contact
                              },
                            ),
                            _buildDivider(),
                            _buildNavigationTile(
                              icon: Icons.info_outline,
                              title: 'About',
                              subtitle: 'Version $_appVersion',
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const AboutScreen(),
                                  ),
                                );
                              },
                            ),
                          ]),
                          
                          const SizedBox(height: 20),
                          
                          // Account Actions
                          _buildSettingsCard([
                            _buildActionTile(
                              icon: Icons.logout,
                              title: 'Sign Out',
                              subtitle: 'Sign out of your account',
                              iconColor: Colors.red,
                              textColor: Colors.red,
                              onTap: _showSignOutDialog,
                            ),
                            _buildDivider(),
                            _buildActionTile(
                              icon: Icons.delete_forever,
                              title: 'Delete Account',
                              subtitle: 'Permanently delete your account',
                              iconColor: Colors.red,
                              textColor: Colors.red,
                              onTap: _showDeleteAccountDialog,
                            ),
                          ]),
                          
                          const SizedBox(height: 30),
                          
                          // App Version
                          Center(
                            child: Column(
                              children: [
                                Text(
                                  'Bekon v$_appVersion',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey.shade500,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '© 2024 Bekon Labs. All rights reserved.',
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.grey.shade400,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
      ),
    );
  }

  Widget _buildProfileCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF2C3A2A),
            Color(0xFF3E4F3C),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF2C3A2A).withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                ),
              ],
            ),
            child: const Center(
              child: Text(
                'U',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w300,
                  color: Color(0xFF2C3A2A),
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'User Name',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'user@example.com',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.edit,
              color: Colors.white,
              size: 18,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(left: 8),
      child: Row(
        children: [
          Icon(
            icon,
            size: 18,
            color: const Color(0xFF2C3A2A).withOpacity(0.7),
          ),
          const SizedBox(width: 8),
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade700,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsCard(List<Widget> children) {
    return Container(
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
        children: children,
      ),
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Divider(
        color: Colors.grey.shade200,
        height: 1,
      ),
    );
  }

  Widget _buildListTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: const Color(0xFF2C3A2A).withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(
          icon,
          color: const Color(0xFF2C3A2A),
          size: 20,
        ),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w500,
          color: Color(0xFF2C3A2A),
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          fontSize: 12,
          color: Colors.grey.shade600,
        ),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios,
        color: Colors.grey.shade400,
        size: 14,
      ),
    );
  }

  Widget _buildNavigationTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: const Color(0xFF2C3A2A).withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(
          icon,
          color: const Color(0xFF2C3A2A),
          size: 20,
        ),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w500,
          color: Color(0xFF2C3A2A),
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          fontSize: 12,
          color: Colors.grey.shade600,
        ),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios,
        color: Colors.grey.shade400,
        size: 14,
      ),
    );
  }

  Widget _buildSwitchTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required Function(bool) onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: SwitchListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        secondary: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFF2C3A2A).withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            icon,
            color: const Color(0xFF2C3A2A),
            size: 20,
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: Color(0xFF2C3A2A),
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade600,
          ),
        ),
        value: value,
        onChanged: onChanged,
        activeColor: const Color(0xFF2C3A2A),
        activeTrackColor: const Color(0xFF2C3A2A).withOpacity(0.5),
        inactiveThumbColor: Colors.grey.shade400,
        inactiveTrackColor: Colors.grey.shade300,
      ),
    );
  }

  Widget _buildInfoTile({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF2C3A2A).withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              color: const Color(0xFF2C3A2A),
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF2C3A2A),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    Color? iconColor,
    Color? textColor,
  }) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: (iconColor ?? Colors.red).withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(
          icon,
          color: iconColor ?? Colors.red,
          size: 20,
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w500,
          color: textColor ?? Colors.red,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          fontSize: 12,
          color: Colors.grey.shade600,
        ),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios,
        color: Colors.grey.shade400,
        size: 14,
      ),
    );
  }
}