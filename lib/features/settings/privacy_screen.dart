import 'package:flutter/material.dart';

class PrivacyScreen extends StatefulWidget {
  const PrivacyScreen({super.key});

  @override
  State<PrivacyScreen> createState() => _PrivacyScreenState();
}

class _PrivacyScreenState extends State<PrivacyScreen> {
  bool _shareData = true;
  bool _profileVisible = true;
  bool _activityVisible = false;
  bool _dataForResearch = true;
  String _dataRetention = '1 year';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F0),
      appBar: AppBar(
        title: const Text(
          'Privacy & Security',
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
              // Data Sharing
              _buildSectionHeader('Data & Sharing', Icons.share_outlined),
              const SizedBox(height: 12),
              _buildSettingsCard([
                _buildSwitchTile(
                  icon: Icons.share_outlined,
                  title: 'Share Usage Data',
                  subtitle: 'Help improve Bekon with anonymous data',
                  value: _shareData,
                  onChanged: (value) => setState(() => _shareData = value),
                ),
                _buildDivider(),
                _buildSwitchTile(
                  icon: Icons.science_outlined,
                  title: 'Research Participation',
                  subtitle: 'Allow data for career research',
                  value: _dataForResearch,
                  onChanged: (value) => setState(() => _dataForResearch = value),
                ),
              ]),
              
              const SizedBox(height: 20),
              
              // Profile Visibility
              _buildSectionHeader('Profile Visibility', Icons.visibility_outlined),
              const SizedBox(height: 12),
              _buildSettingsCard([
                _buildSwitchTile(
                  icon: Icons.person_outline,
                  title: 'Public Profile',
                  subtitle: 'Allow others to see your profile',
                  value: _profileVisible,
                  onChanged: (value) => setState(() => _profileVisible = value),
                ),
                _buildDivider(),
                _buildSwitchTile(
                  icon: Icons.history_outlined,
                  title: 'Show Activity',
                  subtitle: 'Display your recent activity',
                  value: _activityVisible,
                  onChanged: (value) => setState(() => _activityVisible = value),
                ),
              ]),
              
              const SizedBox(height: 20),
              
              // Data Retention
              _buildSectionHeader('Data Retention', Icons.data_usage_outlined),
              const SizedBox(height: 12),
              _buildSettingsCard([
                _buildListTile(
                  icon: Icons.timer_outlined,
                  title: 'Retention Period',
                  subtitle: _dataRetention,
                  onTap: () => _showRetentionDialog(),
                ),
                _buildDivider(),
                _buildActionTile(
                  icon: Icons.download_outlined,
                  title: 'Download My Data',
                  subtitle: 'Export all your personal data',
                  onTap: () {},
                ),
                _buildDivider(),
                _buildActionTile(
                  icon: Icons.delete_outline,
                  title: 'Delete My Data',
                  subtitle: 'Permanently delete all data',
                  iconColor: Colors.red,
                  textColor: Colors.red,
                  onTap: () {},
                ),
              ]),
              
              const SizedBox(height: 20),
              
              // Security
              _buildSectionHeader('Security', Icons.security_outlined),
              const SizedBox(height: 12),
              _buildSettingsCard([
                _buildListTile(
                  icon: Icons.lock_outline,
                  title: 'Change Password',
                  subtitle: 'Update your account password',
                  onTap: () {},
                ),
                _buildDivider(),
                _buildSwitchTile(
                  icon: Icons.fingerprint,
                  title: 'Biometric Login',
                  subtitle: 'Use fingerprint or face ID',
                  value: false,
                  onChanged: (value) {},
                ),
                _buildDivider(),
                _buildListTile(
                  icon: Icons.devices_outlined,
                  title: 'Active Sessions',
                  subtitle: 'Manage logged-in devices',
                  onTap: () {},
                ),
              ]),
              
              const SizedBox(height: 30),
              
              // Privacy Policy Link
              TextButton(
                onPressed: () {},
                child: const Text(
                  'Read our Privacy Policy',
                  style: TextStyle(
                    color: Color(0xFF2C3A2A),
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showRetentionDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Data Retention Period'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildRetentionOption('30 days'),
              _buildRetentionOption('3 months'),
              _buildRetentionOption('6 months'),
              _buildRetentionOption('1 year', isSelected: true),
              _buildRetentionOption('2 years'),
              _buildRetentionOption('Forever'),
            ],
          ),
        );
      },
    );
  }

  Widget _buildRetentionOption(String period, {bool isSelected = false}) {
    return RadioListTile(
      title: Text(period),
      value: period,
      groupValue: _dataRetention,
      activeColor: const Color(0xFF2C3A2A),
      onChanged: (value) {
        setState(() => _dataRetention = value as String);
        Navigator.pop(context);
      },
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(left: 8),
      child: Row(
        children: [
          Icon(icon, size: 18, color: const Color(0xFF2C3A2A).withOpacity(0.7)),
          const SizedBox(width: 8),
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade700,
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
      child: Column(children: children),
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Divider(color: Colors.grey.shade200, height: 1),
    );
  }

  Widget _buildSwitchTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required Function(bool) onChanged,
  }) {
    return SwitchListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      secondary: Container(
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
          fontWeight: FontWeight.w500,
          color: Color(0xFF2C3A2A),
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
      ),
      value: value,
      onChanged: onChanged,
      activeColor: const Color(0xFF2C3A2A),
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
        child: Icon(icon, color: const Color(0xFF2C3A2A), size: 20),
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
        style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
      ),
      trailing: Icon(Icons.arrow_forward_ios, color: Colors.grey.shade400, size: 14),
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
        child: Icon(icon, color: iconColor ?? Colors.red, size: 20),
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
        style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
      ),
      trailing: Icon(Icons.arrow_forward_ios, color: Colors.grey.shade400, size: 14),
    );
  }
}