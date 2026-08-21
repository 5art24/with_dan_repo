import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:project1_collage/core/styles.dart';
import 'package:project1_collage/core/widgets/drawer_menu.dart';
import 'package:project1_collage/core/app_routes.dart';
import 'package:flutter/services.dart' show rootBundle;

class AppSettingsPage extends StatefulWidget {
  const AppSettingsPage({super.key});

  @override
  State<AppSettingsPage> createState() => _AppSettingsPageState();
}

class _AppSettingsPageState extends State<AppSettingsPage> {
  bool _notificationsEnabled = true;
  bool _darkModeEnabled = false;
  bool _locationEnabled = true;
  String? _termsContent;
  bool _termsLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTermsAndConditions();
  }

  Future<void> _loadTermsAndConditions() async {
    try {
      final content = await rootBundle.loadString(
        'lib/core/terms_and_conditions.md',
      );
      if (mounted) {
        setState(() {
          _termsContent = content;
          _termsLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _termsContent = 'تعذر تحميل الشروط والأحكام. يرجى المحاولة لاحقاً.';
          _termsLoading = false;
        });
      }
    }
  }

  void _showChangePasswordDialog() {
    final currentPasswordController = TextEditingController();
    final newPasswordController = TextEditingController();
    final confirmPasswordController = TextEditingController();
    bool obscureCurrent = true;
    bool obscureNew = true;
    bool obscureConfirm = true;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text(
            'تغيير كلمة المرور',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Styles.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: currentPasswordController,
                  obscureText: obscureCurrent,
                  decoration: InputDecoration(
                    labelText: 'كلمة المرور الحالية',
                    prefixIcon: const Icon(
                      Icons.lock_outline,
                      color: Styles.primary,
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        obscureCurrent
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: Styles.textSecondary,
                      ),
                      onPressed: () =>
                          setState(() => obscureCurrent = !obscureCurrent),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    filled: true,
                    fillColor: Styles.surface,
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: newPasswordController,
                  obscureText: obscureNew,
                  decoration: InputDecoration(
                    labelText: 'كلمة المرور الجديدة',
                    prefixIcon: const Icon(
                      Icons.lock_outline,
                      color: Styles.primary,
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        obscureNew ? Icons.visibility_off : Icons.visibility,
                        color: Styles.textSecondary,
                      ),
                      onPressed: () => setState(() => obscureNew = !obscureNew),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    filled: true,
                    fillColor: Styles.surface,
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: confirmPasswordController,
                  obscureText: obscureConfirm,
                  decoration: InputDecoration(
                    labelText: 'تأكيد كلمة المرور الجديدة',
                    prefixIcon: const Icon(
                      Icons.lock_outline,
                      color: Styles.primary,
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        obscureConfirm
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: Styles.textSecondary,
                      ),
                      onPressed: () =>
                          setState(() => obscureConfirm = !obscureConfirm),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    filled: true,
                    fillColor: Styles.surface,
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'إلغاء',
                style: TextStyle(color: Styles.textSecondary),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                if (currentPasswordController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('يرجى إدخال كلمة المرور الحالية'),
                      backgroundColor: Styles.error,
                    ),
                  );
                  return;
                }
                if (newPasswordController.text.length < 6) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('كلمة المرور يجب أن تكون 6 أحرف على الأقل'),
                      backgroundColor: Styles.error,
                    ),
                  );
                  return;
                }
                if (newPasswordController.text !=
                    confirmPasswordController.text) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('كلمتا المرور غير متطابقتين'),
                      backgroundColor: Styles.error,
                    ),
                  );
                  return;
                }
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('تم تغيير كلمة المرور بنجاح'),
                    backgroundColor: Styles.success,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Styles.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('حفظ التغييرات'),
            ),
          ],
        ),
      ),
    );
  }

  void _showTermsAndConditions() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.9,
        maxChildSize: 0.95,
        minChildSize: 0.5,
        builder: (context, scrollController) => Container(
          decoration: const BoxDecoration(
            color: Styles.background,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Styles.textSecondary.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        gradient: Styles.primaryGradient,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.description,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Text(
                        'الشروط والأحكام',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Styles.textPrimary,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(
                        Icons.close,
                        color: Styles.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: _termsLoading
                    ? const Center(
                        child: CircularProgressIndicator(color: Styles.primary),
                      )
                    : SingleChildScrollView(
                        controller: scrollController,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          _termsContent ?? '',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Styles.textSecondary,
                            height: 1.6,
                          ),
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showContactUs() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Styles.background,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: const EdgeInsets.only(bottom: 8),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Styles.textSecondary.withOpacity(0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: Styles.primaryGradient,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.support_agent,
                size: 36,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'تواصل معنا',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Styles.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'فريق الدعم جاهز لمساعدتك على مدار الساعة',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Styles.textSecondary),
            ),
            const SizedBox(height: 24),
            _buildContactItem(
              icon: Icons.phone,
              label: 'هاتف',
              value: '+963 11 123 4567',
              onTap: () {},
            ),
            const SizedBox(height: 12),
            _buildContactItem(
              icon: Icons.chat,
              label: 'واتساب',
              value: '+963 99 123 4567',
              onTap: () {},
            ),
            const SizedBox(height: 12),
            _buildContactItem(
              icon: Icons.email,
              label: 'البريد الإلكتروني',
              value: 'support@eva.app',
              onTap: () {},
            ),
            const SizedBox(height: 12),
            _buildContactItem(
              icon: Icons.location_on,
              label: 'العنوان',
              value: 'دمشق، سوريا - مبنى إيفا، الطابق 3',
              onTap: () {},
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Styles.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Text(
                  'إغلاق',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactItem({
    required IconData icon,
    required String label,
    required String value,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Styles.cardBackground,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Styles.primary.withOpacity(0.1)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Styles.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: Styles.primary, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(fontSize: 12, color: Styles.textSecondary),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Styles.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Styles.textSecondary,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Styles.background,
      drawer: DrawerMenu(
        NormalUserName: 'أحمد الزعبي',
        NormalUserEmail: 'ahmed@example.com',
        isServiceProvider: false,
        onServiceProviderToggle: (value) {},
        onLogout: () {
          //see GoRouter.of(context).go(AppRoutes.kLogin);
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
            trailing: const Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Styles.textSecondary,
            ),
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
              onChanged: (value) =>
                  setState(() => _notificationsEnabled = value),
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
            trailing: const Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Styles.textSecondary,
            ),
            onTap: _showChangePasswordDialog,
          ),
          _buildSettingsTile(
            title: 'إدارة الحساب',
            subtitle: 'حذف الحساب أو تعطيله مؤقتاً',
            leading: Icons.account_circle,
            trailing: const Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Styles.error,
            ),
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
            onTap: _showTermsAndConditions,
          ),
          _buildSettingsTile(
            title: 'تواصل معنا',
            subtitle: 'الدعم الفني والاستفسارات',
            leading: Icons.support,
            onTap: _showContactUs,
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
          style: const TextStyle(fontSize: 13, color: Styles.textSecondary),
        ),
        trailing:
            trailing ??
            const Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Styles.textSecondary,
            ),
        onTap: onTap,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }
}
