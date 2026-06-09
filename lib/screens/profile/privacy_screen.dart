import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_text_styles.dart';
import '../../widgets/custom_button.dart';

class PrivacyScreen extends StatefulWidget {
  const PrivacyScreen({super.key});

  @override
  State<PrivacyScreen> createState() => _PrivacyScreenState();
}

class _PrivacyScreenState extends State<PrivacyScreen> {
  bool _shareAnalytics  = true;
  bool _shareCrashLogs  = true;
  bool _personalisedAds = false;
  bool _locationAccess  = false;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _shareAnalytics  = prefs.getBool('share_analytics')  ?? true;
      _shareCrashLogs  = prefs.getBool('share_crash_logs') ?? true;
      _personalisedAds = prefs.getBool('personalised_ads') ?? false;
      _locationAccess  = prefs.getBool('location_access')  ?? false;
    });
  }

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('share_analytics',  _shareAnalytics);
    await prefs.setBool('share_crash_logs', _shareCrashLogs);
    await prefs.setBool('personalised_ads', _personalisedAds);
    await prefs.setBool('location_access',  _locationAccess);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back, color: AppColors.textDark),
        ),
        title: Text('Privacy Settings', style: AppTextStyles.heading3),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                children: [
                  _PrivacyItem(
                    icon: Icons.analytics_outlined,
                    title: 'Share Analytics',
                    subtitle: 'Help us improve the app',
                    value: _shareAnalytics,
                    onChanged: (v) =>
                        setState(() => _shareAnalytics = v),
                  ),
                  const Divider(height: 1),
                  _PrivacyItem(
                    icon: Icons.bug_report_outlined,
                    title: 'Share Crash Logs',
                    subtitle: 'Help us fix bugs faster',
                    value: _shareCrashLogs,
                    onChanged: (v) =>
                        setState(() => _shareCrashLogs = v),
                  ),
                  const Divider(height: 1),
                  _PrivacyItem(
                    icon: Icons.ads_click_outlined,
                    title: 'Personalised Ads',
                    subtitle: 'Show ads based on your interests',
                    value: _personalisedAds,
                    onChanged: (v) =>
                        setState(() => _personalisedAds = v),
                  ),
                  const Divider(height: 1),
                  _PrivacyItem(
                    icon: Icons.location_on_outlined,
                    title: 'Location Access',
                    subtitle: 'For accurate delivery',
                    value: _locationAccess,
                    onChanged: (v) =>
                        setState(() => _locationAccess = v),
                  ),
                ],
              ),
            ),

            const Spacer(),

            CustomButton(
              text: 'Save Settings',
              onPressed: () async {
                await _saveSettings();
                if (mounted) Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _PrivacyItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _PrivacyItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            width: 40, height: 40,
            decoration: const BoxDecoration(
              color: AppColors.primaryLight,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: AppColors.primary, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(subtitle, style: AppTextStyles.bodySmall),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: AppColors.primary,
          ),
        ],
      ),
    );
  }
}