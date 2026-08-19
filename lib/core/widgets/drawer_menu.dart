import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:project1_collage/core/styles.dart';
import 'package:project1_collage/core/app_routes.dart';

class DrawerMenu extends StatefulWidget {
  final String userName;
  final String userEmail;
  final String? userImage;
  final bool isServiceProvider;
  final Function(bool) onServiceProviderToggle;
  final VoidCallback onLogout;

  const DrawerMenu({
    super.key,
    required this.userName,
    required this.userEmail,
    this.userImage,
    this.isServiceProvider = false,
    required this.onServiceProviderToggle,
    required this.onLogout,
  });

  @override
  State<DrawerMenu> createState() => _DrawerMenuState();
}

class _DrawerMenuState extends State<DrawerMenu> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Styles.background,
        child: Column(
          children: [
            // ═══════════════════════════════════════════
            // رأس القائمة - معلومات المستخدم
            // ═══════════════════════════════════════════
            Container(
              padding: const EdgeInsets.only(
                top: 50,
                bottom: 20,
                left: 20,
                right: 20,
              ),
              decoration: const BoxDecoration(
                gradient: Styles.primaryGradient,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Column(
                children: [
                  // صورة المستخدم
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 3),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
child: widget.userImage != null
                        ? ClipOval(
                            child: Image.network(
                              widget.userImage!,
                              fit: BoxFit.cover,
                            ),
                          )
                          : const Icon(
                              Icons.person,
                              size: 40,
                              color: Styles.primary,
                            ),
                  ),
                  const SizedBox(height: 12),
                  // اسم المستخدم
                  Text(
                    widget.userName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 4),
                  // البريد الإلكتروني
                  Text(
                    widget.userEmail,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // ═══════════════════════════════════════════
            // عناصر القائمة
            // ═══════════════════════════════════════════
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  // البروفايل
                  _buildMenuItem(
                    icon: Icons.person_outline,
                    title: 'البروفايل',
                    onTap: () {
                      Navigator.pop(context);
                      GoRouter.of(context).push(AppRoutes.kProfile);
                    },
                  ),

                  const SizedBox(height: 8),

                  // كن مزود خدمة
                  _buildMenuItem(
                    icon: Icons.business_center_outlined,
                    title: 'كن مزود خدمة',
                    onTap: () {
                      Navigator.pop(context);
                      GoRouter.of(context).push(AppRoutes.kBecomeProvider);
                    },
                  ),

                  // Toggle Switch - وضع مزود الخدمة (يظهر بعد التفعيل)
                  if (widget.isServiceProvider)
                    Container(
                      margin: const EdgeInsets.only(top: 8, bottom: 8),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: Styles.cardBackground,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.toggle_on,
                            color: Styles.primary,
                            size: 28,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'وضع مزود الخدمة',
                              style: TextStyle(
                                color: Styles.textPrimary,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Switch(
                            value: widget.isServiceProvider,
                            onChanged: widget.onServiceProviderToggle,
                            activeColor: Styles.primary,
                            activeTrackColor: Styles.primary.withValues(alpha: 0.3),
                          ),
                        ],
                      ),
                    ),

                  const SizedBox(height: 8),

                  // المحفظة
                  _buildMenuItem(
                    icon: Icons.account_balance_wallet_outlined,
                    title: 'المحفظة',
                    onTap: () {
                      Navigator.pop(context);
                      GoRouter.of(context).push(AppRoutes.kWallet);
                    },
                  ),

                  const SizedBox(height: 8),

                  // ═══════════════════════════════════════════
                  // حول التطبيق (قبل تسجيل الخروج)
                  // ═══════════════════════════════════════════
                  _buildMenuItem(
                    icon: Icons.info_outline,
                    title: 'حول التطبيق',
                    onTap: () {
                      Navigator.pop(context);
                      _showAboutDialog(context);
                    },
                  ),

                  const SizedBox(height: 8),

                  // إعدادات التطبيق
                  _buildMenuItem(
                    icon: Icons.settings_outlined,
                    title: 'إعدادات التطبيق',
                    onTap: () {
                      Navigator.pop(context);
                      GoRouter.of(context).push(AppRoutes.kAppSettings);
                    },
                  ),

                  const SizedBox(height: 20),

                  // فاصل
                  Divider(
                    color: Styles.textSecondary.withValues(alpha: 0.3),
                    thickness: 1,
                  ),

                  const SizedBox(height: 20),

                  // ═══════════════════════════════════════════
                  // تسجيل الخروج (آخر شيء)
                  // ═══════════════════════════════════════════
                  _buildMenuItem(
                    icon: Icons.logout,
                    title: 'تسجيل الخروج',
                    textColor: Styles.error,
                    iconColor: Styles.error,
                    onTap: () {
                      Navigator.pop(context);
                      _showLogoutConfirmation(context);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════
  // عنصر القائمة
  // ═══════════════════════════════════════════
  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color? textColor,
    Color? iconColor,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Styles.cardBackground,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: iconColor ?? Styles.primary,
          size: 24,
        ),
        title: Text(
          title,
          style: TextStyle(
            color: textColor ?? Styles.textPrimary,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.right,
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          color: Styles.textSecondary,
          size: 16,
        ),
        onTap: onTap,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════
  // نافذة حول التطبيق
  // ═══════════════════════════════════════════
  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Text(
          'حول التطبيق',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Styles.primary,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // شعار التطبيق
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                gradient: Styles.primaryGradient,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.event,
                size: 40,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'eva (إيفا)',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Styles.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'تطبيق إدارة الفعاليات والخدمات',
              style: TextStyle(
                fontSize: 14,
                color: Styles.textSecondary,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Styles.surface,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                'الإصدار: 1.0.0',
                style: TextStyle(
                  fontSize: 12,
                  color: Styles.textSecondary,
                ),
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'جامعة دمشق - كلية الهندسة المعلوماتية',
              style: TextStyle(
                fontSize: 12,
                color: Styles.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            const Text(
              'مشروع 1, 2026',
              style: TextStyle(
                fontSize: 12,
                color: Styles.textSecondary,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              '© 2026 eva. جميع الحقوق محفوظة.',
              style: TextStyle(
                fontSize: 11,
                color: Styles.textHint,
              ),
            ),
          ],
        ),
        actions: [
          Center(
            child: TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'حسناً',
                style: TextStyle(
                  color: Styles.primary,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════
  // تأكيد تسجيل الخروج
  // ═══════════════════════════════════════════
  void _showLogoutConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.logout, color: Styles.error),
            SizedBox(width: 8),
            Text(
              'تسجيل الخروج',
              style: TextStyle(
                color: Styles.error,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        content: const Text(
          'هل أنت متأكد أنك تريد تسجيل الخروج؟',
          textAlign: TextAlign.center,
          style: TextStyle(color: Styles.textPrimary),
        ),
        actions: [
          Row(
            children: [
              Expanded(
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text(
                    'إلغاء',
                    style: TextStyle(color: Styles.textSecondary),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    widget.onLogout();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Styles.error,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('تسجيل الخروج'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}