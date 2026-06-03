import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/theme_provider.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_text_styles.dart';
import '../../widgets/custom_button.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  bool _allowNotifications = true;
  bool _emailNotifications = false;
  bool _orderNotifications = false;
  bool _generalNotifications = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back, color: AppColors.textDark),
        ),
        title: Text('Notifications', style: AppTextStyles.heading3),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Notification items
            Container(
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                children: [
                  _NotificationItem(
                    title: 'Allow Notifications',
                    value: _allowNotifications,
                    onChanged: (v) => setState(() => _allowNotifications = v),
                  ),
                  const Divider(height: 1),
                  _NotificationItem(
                    title: 'Email Notifications',
                    value: _emailNotifications,
                    onChanged: (v) => setState(() => _emailNotifications = v),
                  ),
                  const Divider(height: 1),
                  _NotificationItem(
                    title: 'Order Notifications',
                    value: _orderNotifications,
                    onChanged: (v) => setState(() => _orderNotifications = v),
                  ),
                  const Divider(height: 1),
                  _NotificationItem(
                    title: 'General Notifications',
                    value: _generalNotifications,
                    onChanged: (v) => setState(() => _generalNotifications = v),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
              ),
              child: Consumer<ThemeProvider>(
                builder: (_, themeProvider, __) => _NotificationItem(
                  title: 'Dark Mode',
                  value: themeProvider.isDark,
                  onChanged: (_) => themeProvider.toggleTheme(),
                ),
              ),
            ),

            const Spacer(),

            CustomButton(
              text: 'Save settings',
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }
}

class _NotificationItem extends StatelessWidget {
  final String title;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _NotificationItem({
    required this.title,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.bodyLarge.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Lorem ipsum dolor sit amet, consetetur sadi pscing elitr, sed diam nonumym',
                  style: AppTextStyles.bodySmall.copyWith(height: 1.5),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
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
