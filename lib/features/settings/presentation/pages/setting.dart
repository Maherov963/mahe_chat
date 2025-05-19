import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:mahe_chat/features/chat/presentation/components/search_bar.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _notificationsEnabled = true;

  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  // Theme mode options
  ThemeMode _selectedTheme = ThemeMode.system;
  final List<Map<String, dynamic>> _themeOptions = [
    {
      'value': ThemeMode.light,
      'label': 'Light',
      'icon': Icons.light_mode_outlined
    },
    {
      'value': ThemeMode.dark,
      'label': 'Dark',
      'icon': Icons.dark_mode_outlined
    },
    {
      'value': ThemeMode.system,
      'label': 'System',
      'icon': Icons.phone_android_outlined
    },
  ];

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: Stack(
        children: [
          // Background gradient
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.blue.shade900.withOpacity(0.8),
                  const Color(0xFF121212),
                ],
                stops: const [0.0, 0.6],
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomSearchBar(
                    hint: "hint",
                    title: "Settings",
                    leading: BackButton(),
                    trailing: SizedBox.shrink(),
                  ),
                  // Account Settings Section
                  _buildSectionHeader('Account Settings'),
                  _buildSettingCard(
                    children: [
                      _buildListTile(
                        leading: const Icon(Icons.lock_outline),
                        title: 'Change Password',
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () => _showPasswordDialog(),
                      ),
                      _buildDivider(),
                      _buildListTile(
                        leading: const Icon(Icons.person_outline),
                        title: 'Privacy Settings',
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () {
                          // Navigate to privacy settings
                        },
                      ),
                    ],
                  ).animate().fadeIn(delay: 100.ms).slideX(begin: -0.1),

                  const SizedBox(height: 24),

                  // App Settings Section
                  _buildSectionHeader('App Settings'),
                  _buildSettingCard(
                    children: [
                      _buildListTile(
                        leading: const Icon(Icons.color_lens_outlined),
                        title: 'App Theme',
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              _themeOptions.firstWhere((opt) =>
                                  opt['value'] == _selectedTheme)['label'],
                              style: TextStyle(
                                color: isDarkMode
                                    ? Colors.grey.shade400
                                    : Colors.grey.shade600,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Icon(
                              Icons.chevron_right,
                              color: isDarkMode
                                  ? Colors.grey.shade400
                                  : Colors.grey.shade600,
                            ),
                          ],
                        ),
                        onTap: () => _showThemeSelector(context),
                      ),
                      _buildDivider(),
                      _buildListTile(
                        leading: const Icon(Icons.language_outlined),
                        title: 'Language',
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'English',
                              style: TextStyle(color: Colors.grey.shade400),
                            ),
                            const Icon(Icons.chevron_right),
                          ],
                        ),
                        onTap: () {
                          // Navigate to language settings
                        },
                      ),
                    ],
                  ).animate().fadeIn(delay: 200.ms).slideX(begin: -0.1),

                  const SizedBox(height: 24),

                  // Notification Settings Section
                  _buildSectionHeader('Notifications'),
                  _buildSettingCard(
                    children: [
                      _buildListTile(
                        leading: const Icon(Icons.notifications_none_outlined),
                        title: 'Enable Notifications',
                        trailing: Switch(
                          value: _notificationsEnabled,
                          activeColor: Colors.blue,
                          onChanged: (value) {
                            setState(() => _notificationsEnabled = value);
                          },
                        ),
                      ),
                    ],
                  ).animate().fadeIn(delay: 300.ms).slideX(begin: -0.1),

                  const SizedBox(height: 24),

                  // App Info Section
                  _buildSectionHeader('About'),
                  _buildSettingCard(
                    children: [
                      _buildListTile(
                        leading: const Icon(Icons.info_outline),
                        title: 'Version',
                        trailing: Text(
                          '1.0.0',
                          style: TextStyle(color: Colors.grey.shade400),
                        ),
                      ),
                      _buildDivider(),
                      _buildListTile(
                        leading: const Icon(Icons.star_border_outlined),
                        title: 'Rate MaheChat',
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () {
                          // Open app store
                        },
                      ),
                      _buildDivider(),
                      _buildListTile(
                        leading: const Icon(Icons.share_outlined),
                        title: 'Share App',
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () {
                          // Share app
                        },
                      ),
                    ],
                  ).animate().fadeIn(delay: 400.ms).slideX(begin: -0.1),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, bottom: 8),
      child: Text(
        title,
        style: TextStyle(
          color: Colors.blue.shade300,
          fontWeight: FontWeight.w500,
          fontSize: 14,
          letterSpacing: 1,
        ),
      ),
    ).animate().fadeIn();
  }

  Widget _buildSettingCard({required List<Widget> children}) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        children: children,
      ),
    );
  }

  Widget _buildListTile({
    required Widget leading,
    required String title,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return ListTile(
      leading: leading,
      title: Text(
        title,
        style: const TextStyle(color: Colors.white),
      ),
      trailing: trailing,
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
      minLeadingWidth: 24,
    );
  }

  Widget _buildDivider() {
    return Divider(
      height: 1,
      thickness: 1,
      indent: 16,
      endIndent: 16,
      color: Colors.grey.shade800,
    );
  }

  void _showPasswordDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1E1E1E),
          title: const Text(
            'Change Password',
            style: TextStyle(color: Colors.white),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _currentPasswordController,
                obscureText: true,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Current Password',
                  labelStyle: TextStyle(color: Colors.grey.shade400),
                  filled: true,
                  fillColor: const Color(0xFF2D2D2D),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _newPasswordController,
                obscureText: true,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'New Password',
                  labelStyle: TextStyle(color: Colors.grey.shade400),
                  filled: true,
                  fillColor: const Color(0xFF2D2D2D),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _confirmPasswordController,
                obscureText: true,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Confirm New Password',
                  labelStyle: TextStyle(color: Colors.grey.shade400),
                  filled: true,
                  fillColor: const Color(0xFF2D2D2D),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                // Validate and change password
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('Password changed successfully')),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade700,
              ),
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _showThemeSelector(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
          title: Text(
            'Select Theme',
            style: TextStyle(
              color: isDarkMode ? Colors.white : Colors.black,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: _themeOptions.map((theme) {
              return RadioListTile<ThemeMode>(
                title: Row(
                  children: [
                    Icon(
                      theme['icon'],
                      color: isDarkMode ? Colors.white : Colors.black,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      theme['label'],
                      style: TextStyle(
                        color: isDarkMode ? Colors.white : Colors.black,
                      ),
                    ),
                  ],
                ),
                value: theme['value'],
                groupValue: _selectedTheme,
                onChanged: (value) {
                  setState(() => _selectedTheme = value!);
                  // Here you would update the app theme using a provider
                  Navigator.pop(context);
                },
                activeColor: Colors.blue,
              );
            }).toList(),
          ),
        );
      },
    );
  }
}
