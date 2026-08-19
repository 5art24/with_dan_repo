import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:project1_collage/core/styles.dart';
import 'package:project1_collage/core/widgets/drawer_menu.dart';
import 'package:project1_collage/core/app_routes.dart';

class WalletPage extends StatefulWidget {
  const WalletPage({super.key});

  @override
  State<WalletPage> createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {
  double _balance = 125000.0;

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
          'المحفظة',
          style: TextStyle(
            color: Styles.primary,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // رصيد المحفظة
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                gradient: Styles.primaryGradient,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                children: [
                  const Text(
                    'الرصيد الحالي',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${_balance.toStringAsFixed(0)} ل.س',
                    style: const TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // أزرار الإجراءات
            Row(
              children: [
                Expanded(
                  child: _buildActionButton(
                    icon: Icons.add_circle_outline,
                    label: 'إيداع',
                    color: Styles.success,
                    onTap: () {
                      _showDepositDialog(context);
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildActionButton(
                    icon: Icons.remove_circle_outline,
                    label: 'سحب',
                    color: Styles.error,
                    onTap: () {
                      _showWithdrawDialog(context);
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            // سجل المعاملات
            const Align(
              alignment: Alignment.centerRight,
              child: Text(
                'سجل المعاملات',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Styles.textPrimary,
                ),
              ),
            ),
            const SizedBox(height: 16),
            ..._buildTransactions(),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: Styles.cardBackground,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Icon(icon, size: 32, color: color),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildTransactions() {
    final transactions = [
      {'title': 'حجز صالة الأفراح الذهبية', 'amount': -50000, 'date': '2026-01-15', 'type': 'expense'},
      {'title': 'إيداع رصيد', 'amount': 100000, 'date': '2026-01-10', 'type': 'income'},
      {'title': 'حجز خدمات إضاءة', 'amount': -25000, 'date': '2026-01-05', 'type': 'expense'},
      {'title': 'استرداد مبلغ', 'amount': 15000, 'date': '2026-01-01', 'type': 'refund'},
    ];

    return transactions.map((tx) {
      final isIncome = tx['type'] == 'income' || tx['type'] == 'refund';
      return Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Styles.cardBackground,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: (isIncome ? Styles.success : Styles.error).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                isIncome ? Icons.arrow_downward : Icons.arrow_upward,
                color: isIncome ? Styles.success : Styles.error,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    tx['title'] as String,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Styles.textPrimary,
                    ),
                  ),
                  Text(
                    tx['date'] as String,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Styles.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              '${isIncome ? '+' : ''}${tx['amount']} ل.س',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isIncome ? Styles.success : Styles.error,
              ),
            ),
          ],
        ),
      );
    }).toList();
  }

  void _showDepositDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _DepositBottomSheet(
        onDeposit: (amount) {
          setState(() => _balance += amount);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('تم إيداع $amount ل.س بنجاح')),
          );
        },
      ),
    );
  }

  void _showWithdrawDialog(BuildContext context) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('سحب رصيد'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'المبلغ (ل.س)',
            hintText: 'أدخل المبلغ',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              final amount = double.tryParse(controller.text) ?? 0;
              if (amount > 0 && amount <= _balance) {
                setState(() => _balance -= amount);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('تم سحب $amount ل.س بنجاح')),
                );
              } else if (amount > _balance) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('الرصيد غير كافي')),
                );
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Styles.error),
            child: const Text('سحب'),
          ),
        ],
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════
// ويدجت إيداع الرصيد - Bottom Sheet مع محافظ مدعومة
// ═══════════════════════════════════════════════════════════
class _DepositBottomSheet extends StatefulWidget {
  final Function(double) onDeposit;

  const _DepositBottomSheet({required this.onDeposit});

  @override
  State<_DepositBottomSheet> createState() => _DepositBottomSheetState();
}

class _DepositBottomSheetState extends State<_DepositBottomSheet> {
  final _amountController = TextEditingController();
  final _transferNumberController = TextEditingController();
  bool _isSubmitting = false;

  // المحافظ المدعومة
  final List<Map<String, String>> _supportedWallets = [
    {
      'name': 'شام كاش',
      'number': '0987654321',
      'owner': 'شركة شام كاش',
    },
    {
      'name': 'سيريتل كاش',
      'number': '0991234567',
      'owner': 'سيريتل',
    },
    {
      'name': 'بيمو كاش',
      'number': '0945678901',
      'owner': 'بيمو بنك',
    },
  ];

  @override
  void dispose() {
    _amountController.dispose();
    _transferNumberController.dispose();
    super.dispose();
  }

  void _submitDeposit() {
    final amount = double.tryParse(_amountController.text) ?? 0;
    final transferNumber = _transferNumberController.text.trim();

    if (amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('الرجاء إدخال مبلغ صحيح'), backgroundColor: Styles.error),
      );
      return;
    }

    if (transferNumber.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('الرجاء إدخال رقم التحويل'), backgroundColor: Styles.error),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    // محاكاة إرسال طلب الإيداع للأدمن
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() => _isSubmitting = false);
        widget.onDeposit(amount);
        Navigator.pop(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle bar
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Styles.textHint,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Title
            const Text(
              'إيداع رصيد',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Styles.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'اختر محفظة وأرسل المبلغ، ثم أدخل رقم التحويل',
              style: TextStyle(
                fontSize: 14,
                color: Styles.textSecondary,
              ),
            ),
            const SizedBox(height: 24),

            // Supported Wallets
            const Text(
              'المحافظ المدعومة',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Styles.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            ..._supportedWallets.map((wallet) => _buildWalletCard(wallet)).toList(),

            const SizedBox(height: 24),

            // Amount Field
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'المبلغ (ل.س)',
                hintText: 'مثال: 50000',
                prefixIcon: const Icon(Icons.attach_money, color: Styles.primary),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Styles.surface,
                contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              ),
            ),
            const SizedBox(height: 16),

            // Transfer Number Field
            TextField(
              controller: _transferNumberController,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                labelText: 'رقم التحويل / وصل الإيداع',
                hintText: 'أدخل رقم التحويل أو انسخ من التطبيق',
                prefixIcon: const Icon(Icons.receipt_long, color: Styles.primary),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Styles.surface,
                contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              ),
            ),
            const SizedBox(height: 16),

            // Receipt Image Upload (optional)
            _buildReceiptUploadSection(),

            const SizedBox(height: 24),

            // Submit Button
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _isSubmitting ? null : _submitDeposit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Styles.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                ),
                child: _isSubmitting
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Text(
                        'إرسال طلب الإيداع',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 16),

            // Note
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Styles.warning.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Styles.warning.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: Styles.warning, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'سيتم مراجعة طلبك من قبل الإدارة ورفع الرصيد خلال فترة قصيرة. احتفظ برقم التحويل للمراجعة.',
                      style: TextStyle(
                        fontSize: 12,
                        color: Styles.warning,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWalletCard(Map<String, String> wallet) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Styles.cardBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Styles.primary.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Styles.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.account_balance_wallet, color: Styles.primary, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  wallet['name']!,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Styles.textPrimary,
                  ),
                ),
                Text(
                  wallet['owner']!,
                  style: TextStyle(
                    fontSize: 12,
                    color: Styles.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                wallet['number']!,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Styles.textPrimary,
                ),
              ),
              const SizedBox(height: 4),
              InkWell(
                onTap: () {
                  // Copy to clipboard
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('تم نسخ ${wallet['number']}')),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Styles.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.copy, size: 14, color: Styles.primary),
                      const SizedBox(width: 4),
                      Text(
                        'نسخ',
                        style: TextStyle(
                          fontSize: 12,
                          color: Styles.primary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildReceiptUploadSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'صورة وصل التحويل (اختياري)',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Styles.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          height: 120,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Styles.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Styles.textHint.withOpacity(0.3), style: BorderStyle.solid),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.cloud_upload_outlined, size: 40, color: Styles.textSecondary),
              const SizedBox(height: 8),
              Text(
                'اضغط لاختيار صورة الوصل',
                style: TextStyle(
                  fontSize: 14,
                  color: Styles.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}