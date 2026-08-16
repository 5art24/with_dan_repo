import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:project1_collage/core/styles.dart';
import 'package:project1_collage/core/widgets/drawer_menu.dart';
import 'package:project1_collage/core/app_routes.dart';

class AppSettingsPage extends StatefulWidget {
  const AppSettingsPage({super.key});

  @override
  State<AppSettingsPage> createState() => _AppSettingsPageState();
}

class _AppSettingsPageState extends State<AppSettingsPage> {
  bool _notificationsEnabled = true;
  bool _darkModeEnabled = false;
  bool _locationEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Styles.background,
      drawer: DrawerMenu(
        userName: 'أحمد الزعبي',
        userEmail: 'ahmed@example.com',
        isServiceProvider: false,
        onServiceProviderToggle: (value) {},
        onLogout: () {
          GoRouter.of(context).go(AppRoutes.kLogin);
        },
      ),
      appBar: AppBar(
        backgroundColor: Styles.background,
        elevation: 0,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: Styles.primary),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        title: const Text(
          'إعدادات التطبيق',
          style: TextStyle(
            color: Styles.primary,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          _buildSectionTitle('عام'),
          _buildSettingsTile(
            title: 'الوضع الداكن',
            subtitle: 'تفعيل المظهر الداكن للتطبيق',
            leading: Icons.dark_mode,
            trailing: Switch(
              value: _darkModeEnabled,
              onChanged: (value) => setState(() => _darkModeEnabled = value),
              activeThumbColor: Styles.primary,
            ),
          ),
          _buildSettingsTile(
            title: 'اللغة',
            subtitle: 'العربية',
            leading: Icons.language,
            trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Styles.textSecondary),
            onTap: () {},
          ),
          const SizedBox(height: 24),
          _buildSectionTitle('الإشعارات'),
          _buildSettingsTile(
            title: 'الإشعارات العامة',
            subtitle: 'تلقي الإشعارات من التطبيق',
            leading: Icons.notifications,
            trailing: Switch(
              value: _notificationsEnabled,
              onChanged: (value) => setState(() => _notificationsEnabled = value),
              activeThumbColor: Styles.primary,
            ),
          ),
          _buildSettingsTile(
            title: 'إشعارات الحجوزات',
            subtitle: 'تذكيرات بالحجوزات القادمة',
            leading: Icons.event,
            trailing: Switch(
              value: true,
              onChanged: (value) {},
              activeThumbColor: Styles.primary,
            ),
          ),
          _buildSettingsTile(
            title: 'العروض والتخفيضات',
            subtitle: 'العروض الخاصة من مزودي الخدمة',
            leading: Icons.local_offer,
            trailing: Switch(
              value: true,
              onChanged: (value) {},
              activeThumbColor: Styles.primary,
            ),
          ),
          const SizedBox(height: 24),
          _buildSectionTitle('الخصوصية والأمان'),
          _buildSettingsTile(
            title: 'خدمات الموقع',
            subtitle: 'السماح للتطبيق بالوصول للموقع',
            leading: Icons.location_on,
            trailing: Switch(
              value: _locationEnabled,
              onChanged: (value) => setState(() => _locationEnabled = value),
              activeThumbColor: Styles.primary,
            ),
          ),
          _buildSettingsTile(
            title: 'تغيير كلمة المرور',
            subtitle: 'تحديث كلمة مرور الحساب',
            leading: Icons.lock,
            trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Styles.textSecondary),
            onTap: () {},
          ),
          _buildSettingsTile(
            title: 'إدارة الحساب',
            subtitle: 'حذف الحساب أو تعطيله مؤقتاً',
            leading: Icons.account_circle,
            trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Styles.error),
            onTap: () {},
            textColor: Styles.error,
          ),
          const SizedBox(height: 24),
          _buildSectionTitle('حول'),
          _buildSettingsTile(
            title: 'إصدار التطبيق',
            subtitle: '1.0.0',
            leading: Icons.info,
          ),
          _buildSettingsTile(
            title: 'الشروط والأحكام',
            subtitle: 'سياسة الاستخدام والخصوصية',
            leading: Icons.description,
            onTap: () {},
          ),
          _buildSettingsTile(
            title: 'تواصل معنا',
            subtitle: 'الدعم الفني والاستفسارات',
            leading: Icons.support,
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Styles.textPrimary,
        ),
      ),
    );
  }

  Widget _buildSettingsTile({
    required String title,
    required String subtitle,
    required IconData leading,
    Widget? trailing,
    VoidCallback? onTap,
    Color? textColor,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Styles.cardBackground,
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        leading: Icon(leading, color: textColor ?? Styles.primary, size: 24),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: textColor ?? Styles.textPrimary,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(
            fontSize: 13,
            color: Styles.textSecondary,
          ),
        ),
        trailing: trailing ?? const Icon(Icons.arrow_forward_ios, size: 16, color: Styles.textSecondary),
        onTap: onTap,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }
}