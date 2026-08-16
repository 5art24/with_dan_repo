import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:project1_collage/core/styles.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/custom_button.dart';
import 'package:project1_collage/core/app_routes.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  final _usernameController = TextEditingController();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _workStudyController = TextEditingController();
  final _cityController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;

  // قائمة المحافظات السورية
  String? _selectedGovernorate;
  final List<String> _governorates = [
    'دمشق',
    'ريف دمشق',
    'حلب',
    'حمص',
    'حماة',
    'اللاذقية',
    'طرطوس',
    'درعا',
    'السويداء',
    'القنيطرة',
    'الرقة',
    'دير الزور',
    'الحسكة',
    'إدلب',
  ];

  @override
  void dispose() {
    _usernameController.dispose();
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _workStudyController.dispose();
    _cityController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _register() {
    if (_formKey.currentState!.validate()) {
      if (_selectedGovernorate == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('الرجاء اختيار المحافظة'),
            backgroundColor: Styles.error,
          ),
        );
        return;
      }

      setState(() => _isLoading = true);
      // محاكاة التسجيل
      Future.delayed(const Duration(seconds: 2), () {
        if (!mounted) return;
        setState(() => _isLoading = false);
        GoRouter.of(context).go(AppRoutes.kHomeView);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Styles.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Styles.textPrimary),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // ═══════════════════════════════════════════
                // شعار التطبيق
                // ═══════════════════════════════════════════
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    gradient: Styles.primaryGradient,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.person_add,
                    size: 40,
                    color: Colors.white,
                  ),
                ),

                const SizedBox(height: 16),

                // عنوان الصفحة
                const Text(
                  'إنشاء حساب جديد',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Styles.textPrimary,
                  ),
                ),

                const SizedBox(height: 8),

                const Text(
                  'انضم إلى عائلة إيفا',
                  style: TextStyle(
                    fontSize: 14,
                    color: Styles.textSecondary,
                  ),
                ),

                const SizedBox(height: 32),

                // ═══════════════════════════════════════════
                // 1. اسم المستخدم الفريد
                // ═══════════════════════════════════════════
                CustomTextField(
                  hintText: 'اسم المستخدم الفريد *',
                  prefixIcon: Icons.alternate_email,
                  controller: _usernameController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'الرجاء إدخال اسم المستخدم';
                    }
                    if (value.length < 3) {
                      return 'اسم المستخدم يجب أن يكون 3 أحرف على الأقل';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 16),

                // ═══════════════════════════════════════════
                // 2. الاسم الثلاثي
                // ═══════════════════════════════════════════
                CustomTextField(
                  hintText: 'الاسم الثلاثي *',
                  prefixIcon: Icons.person_outline,
                  controller: _fullNameController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'الرجاء إدخال الاسم الثلاثي';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 16),

                // ═══════════════════════════════════════════
                // 3. البريد الإلكتروني
                // ═══════════════════════════════════════════
                CustomTextField(
                  hintText: 'البريد الإلكتروني *',
                  prefixIcon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                  controller: _emailController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'الرجاء إدخال البريد الإلكتروني';
                    }
                    if (!value.contains('@')) {
                      return 'الرجاء إدخال بريد إلكتروني صحيح';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 16),

                // ═══════════════════════════════════════════
                // 4. رقم الهاتف
                // ═══════════════════════════════════════════
                CustomTextField(
                  hintText: 'رقم الهاتف *',
                  prefixIcon: Icons.phone_android,
                  keyboardType: TextInputType.phone,
                  controller: _phoneController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'الرجاء إدخال رقم الهاتف';
                    }
                    if (value.length < 10) {
                      return 'رقم الهاتف غير صحيح';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 16),

                // ═══════════════════════════════════════════
                // 5. نوع الدراسة أو العمل
                // ═══════════════════════════════════════════
                CustomTextField(
                  hintText: 'نوع الدراسة أو العمل',
                  prefixIcon: Icons.school_outlined,
                  controller: _workStudyController,
                ),

                const SizedBox(height: 16),

                // ═══════════════════════════════════════════
                // 6. مكان الإقامة - المحافظة (Dropdown)
                // ═══════════════════════════════════════════
                Container(
                  decoration: BoxDecoration(
                    color: Styles.cardBackground,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: DropdownButtonFormField<String>(
                    value: _selectedGovernorate,
                    hint: const Text(
                      'اختر المحافظة *',
                      style: TextStyle(
                        color: Styles.textHint,
                        fontSize: 14,
                      ),
                    ),
                    icon: const Icon(
                      Icons.arrow_drop_down,
                      color: Styles.primaryLight,
                    ),
                    decoration: InputDecoration(
                      prefixIcon: const Icon(
                        Icons.location_city,
                        color: Styles.primaryLight,
                        size: 20,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Styles.cardBackground,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 16,
                      ),
                    ),
                    items: _governorates.map((String governorate) {
                      return DropdownMenuItem<String>(
                        value: governorate,
                        child: Text(
                          governorate,
                          textAlign: TextAlign.right,
                          style: const TextStyle(
                            color: Styles.textPrimary,
                            fontSize: 14,
                          ),
                        ),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedGovernorate = newValue;
                      });
                    },
                  ),
                ),

                const SizedBox(height: 16),

                // البلدة (Text)
                CustomTextField(
                  hintText: 'البلدة / المنطقة',
                  prefixIcon: Icons.location_on_outlined,
                  controller: _cityController,
                ),

                const SizedBox(height: 16),

                // ═══════════════════════════════════════════
                // 7. كلمة المرور
                // ═══════════════════════════════════════════
                CustomTextField(
                  hintText: 'كلمة المرور *',
                  prefixIcon: Icons.lock_outline,
                  suffixIcon: _obscurePassword
                      ? Icons.visibility_off
                      : Icons.visibility,
                  obscureText: _obscurePassword,
                  controller: _passwordController,
                  onSuffixTap: () {
                    setState(() => _obscurePassword = !_obscurePassword);
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'الرجاء إدخال كلمة المرور';
                    }
                    if (value.length < 6) {
                      return 'كلمة المرور يجب أن تكون 6 أحرف على الأقل';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 16),

                // ═══════════════════════════════════════════
                // 8. تأكيد كلمة المرور
                // ═══════════════════════════════════════════
                CustomTextField(
                  hintText: 'تأكيد كلمة المرور *',
                  prefixIcon: Icons.lock_outline,
                  suffixIcon: _obscureConfirmPassword
                      ? Icons.visibility_off
                      : Icons.visibility,
                  obscureText: _obscureConfirmPassword,
                  controller: _confirmPasswordController,
                  onSuffixTap: () {
                    setState(() =>
                        _obscureConfirmPassword = !_obscureConfirmPassword);
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'الرجاء تأكيد كلمة المرور';
                    }
                    if (value != _passwordController.text) {
                      return 'كلمتا المرور غير متطابقتين';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 32),

                // ═══════════════════════════════════════════
                // زر إنشاء الحساب
                // ════════════════════════════════════════════
                CustomButton(
                  text: 'إنشاء حساب',
                  onPressed: _register,
                  isLoading: _isLoading,
                ),

                const SizedBox(height: 24),

                // ═══════════════════════════════════════════
                // لديك حساب؟
                // ═══════════════════════════════════════════
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'لديك حساب؟',
                      style: TextStyle(
                        color: Styles.textSecondary,
                        fontSize: 14,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        context.pop();
                      },
                      child: const Text(
                        'سجل دخول',
                        style: TextStyle(
                          color: Styles.primaryLight,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}