import 'package:flutter/material.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  bool _pushEnabled = true;
  bool _emailEnabled = true;
  bool _assessmentReminders = true;
  bool _careerAlerts = true;
  bool _tipsAndTricks = true;
  bool _communityUpdates = false;
  bool _promotionalEmails = false;
  
  String _quietHoursStart = '22:00';
  String _quietHoursEnd = '08:00';
  bool _quietHoursEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F0),
      appBar: AppBar(
        title: const Text(
          'Notifications',
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
              // Push Notifications
              _buildSectionHeader('Push Notifications', Icons.notifications_active_outlined),
              const SizedBox(height: 12),
              _buildSettingsCard([
                _buildSwitchTile(
                  icon: Icons.notifications_on_outlined,
                  title: 'Enable Push Notifications',
                  subtitle: 'Receive alerts on your device',
                  value: _pushEnabled,
                  onChanged: (value) => setState(() => _pushEnabled = value),
                ),
                _buildDivider(),
                _buildSwitchTile(
                  icon: Icons.assignment_outlined,
                  title: 'Assessment Reminders',
                  subtitle: 'Get reminded to complete assessments',
                  value: _assessmentReminders,
                  onChanged: (value) => setState(() => _assessmentReminders = value),
                  enabled: _pushEnabled,
                ),
                _buildDivider(),
                _buildSwitchTile(
                  icon: Icons.work_outline,
                  title: 'Career Alerts',
                  subtitle: 'New career matches and opportunities',
                  value: _careerAlerts,
                  onChanged: (value) => setState(() => _careerAlerts = value),
                  enabled: _pushEnabled,
                ),
                _buildDivider(),
                _buildSwitchTile(
                  icon: Icons.lightbulb_outline,
                  title: 'Tips & Tricks',
                  subtitle: 'Career advice and guidance',
                  value: _tipsAndTricks,
                  onChanged: (value) => setState(() => _tipsAndTricks = value),
                  enabled: _pushEnabled,
                ),
              ]),
              
              const SizedBox(height: 20),
              
              // Email Notifications
              _buildSectionHeader('Email Notifications', Icons.email_outlined),
              const SizedBox(height: 12),
              _buildSettingsCard([
                _buildSwitchTile(
                  icon: Icons.email_outlined,
                  title: 'Enable Email Notifications',
                  subtitle: 'Receive updates via email',
                  value: _emailEnabled,
                  onChanged: (value) => setState(() => _emailEnabled = value),
                ),
                _buildDivider(),
                _buildSwitchTile(
                  icon: Icons.people_outline,
                  title: 'Community Updates',
                  subtitle: 'News and community events',
                  value: _communityUpdates,
                  onChanged: (value) => setState(() => _communityUpdates = value),
                  enabled: _emailEnabled,
                ),
                _buildDivider(),
                _buildSwitchTile(
                  icon: Icons.local_offer_outlined,
                  title: 'Promotional Emails',
                  subtitle: 'Special offers and promotions',
                  value: _promotionalEmails,
                  onChanged: (value) => setState(() => _promotionalEmails = value),
                  enabled: _emailEnabled,
                ),
              ]),
              
              const SizedBox(height: 20),
              
              // Quiet Hours
              _buildSectionHeader('Quiet Hours', Icons.nightlight_outlined),
              const SizedBox(height: 12),
              _buildSettingsCard([
                _buildSwitchTile(
                  icon: Icons.do_not_disturb_outlined,
                  title: 'Enable Quiet Hours',
                  subtitle: 'Mute notifications during specific times',
                  value: _quietHoursEnabled,
                  onChanged: (value) => setState(() => _quietHoursEnabled = value),
                ),
                if (_quietHoursEnabled) ...[
                  _buildDivider(),
                  _buildTimeRangeTile(),
                ],
              ]),
              
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
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
    bool enabled = true,
  }) {
    return SwitchListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      secondary: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: (enabled ? const Color(0xFF2C3A2A) : Colors.grey).withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(
          icon,
          color: enabled ? const Color(0xFF2C3A2A) : Colors.grey,
          size: 20,
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w500,
          color: enabled ? const Color(0xFF2C3A2A) : Colors.grey,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          fontSize: 12,
          color: enabled ? Colors.grey.shade600 : Colors.grey.shade400,
        ),
      ),
      value: value,
      onChanged: enabled ? onChanged : null,
      activeColor: const Color(0xFF2C3A2A),
    );
  }

  Widget _buildTimeRangeTile() {
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
            child: const Icon(
              Icons.access_time,
              color: Color(0xFF2C3A2A),
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Quiet Hours',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF2C3A2A),
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Expanded(
                      child: _buildTimePicker(
                        label: 'From',
                        time: _quietHoursStart,
                        onTap: () async {
                          final time = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay(
                              hour: int.parse(_quietHoursStart.split(':')[0]),
                              minute: int.parse(_quietHoursStart.split(':')[1]),
                            ),
                          );
                          if (time != null) {
                            setState(() {
                              _quietHoursStart = '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
                            });
                          }
                        },
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: Text('to'),
                    ),
                    Expanded(
                      child: _buildTimePicker(
                        label: 'To',
                        time: _quietHoursEnd,
                        onTap: () async {
                          final time = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay(
                              hour: int.parse(_quietHoursEnd.split(':')[0]),
                              minute: int.parse(_quietHoursEnd.split(':')[1]),
                            ),
                          );
                          if (time != null) {
                            setState(() {
                              _quietHoursEnd = '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
                            });
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimePicker({
    required String label,
    required String time,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              time,
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
}