import 'package:flutter/material.dart';

import '../../controllers/auth_controller.dart';
import '../../utils/form_validators.dart';
import 'forgot_password_page.dart';
import 'register_page.dart';

class LoginPage extends StatefulWidget {
  final AuthController controller;

  const LoginPage({super.key, required this.controller});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _identifierController;
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    _identifierController = TextEditingController(
      text: widget.controller.rememberedIdentifier ?? '',
    );
  }

  @override
  void dispose() {
    _identifierController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submitLogin() async {
    FocusScope.of(context).unfocus();
    widget.controller.clearError();

    if (!_formKey.currentState!.validate()) return;

    final success = await widget.controller.login(
      identifier: _identifierController.text,
      password: _passwordController.text,
    );

    if (!mounted) return;

    if (success) {
      final user = widget.controller.currentUser!;
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('تم تسجيل الدخول بنجاح'),
          content: Text(
            'مرحباً بك يا ${user.fullName}\n'
            'الرقم الأكاديمي: ${user.academicId}\n'
            'البريد الجامعي: ${user.email}',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('حسناً'),
            ),
          ],
        ),
      );
    } else if (widget.controller.errorMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(widget.controller.errorMessage!),
          backgroundColor: Colors.red.shade700,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('تسجيل الدخول الطلابي'),
        centerTitle: true,
      ),
      body: ListenableBuilder(
        listenable: widget.controller,
        builder: (context, _) {
          final isLoading = widget.controller.isLoading;

          return SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Icon(
                      Icons.school_rounded,
                      size: 72,
                      color: Colors.indigo,
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'البوابة الأكاديمية للطلاب',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'حساب تجريبي: 202410001 | كلمة المرور: Password1',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 28),

                    // المعرف الأكاديمي أو البريد
                    TextFormField(
                      controller: _identifierController,
                      enabled: !isLoading,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      validator: FormValidators.validateIdentifier,
                      decoration: const InputDecoration(
                        labelText: 'المعرف الأكاديمي أو البريد الجامعي',
                        hintText: 'مثال: 202410001 أو student@univ.edu',
                        prefixIcon: Icon(Icons.person_outline),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // كلمة المرور مع زر الإظهار/الإخفاء
                    TextFormField(
                      controller: _passwordController,
                      enabled: !isLoading,
                      obscureText: _obscurePassword,
                      textInputAction: TextInputAction.done,
                      validator: FormValidators.validateLoginPassword,
                      onFieldSubmitted: (_) =>
                          isLoading ? null : _submitLogin(),
                      decoration: InputDecoration(
                        labelText: 'كلمة المرور',
                        prefixIcon: const Icon(Icons.lock_outline),
                        border: const OutlineInputBorder(),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),

                    // تذكرني + نسيت كلمة المرور
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Checkbox(
                              value: widget.controller.rememberMe,
                              onChanged: isLoading
                                  ? null
                                  : widget.controller.toggleRememberMe,
                            ),
                            const Text('تذكرني'),
                          ],
                        ),
                        TextButton(
                          onPressed: isLoading
                              ? null
                              : () {
                                  widget.controller.clearError();
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (_) => ForgotPasswordPage(
                                        controller: widget.controller,
                                      ),
                                    ),
                                  );
                                },
                          child: const Text('نسيت كلمة المرور؟'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // زر تسجيل الدخول
                    SizedBox(
                      height: 48,
                      child: ElevatedButton(
                        onPressed: isLoading ? null : _submitLogin,
                        child: isLoading
                            ? const SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.5,
                                ),
                              )
                            : const Text(
                                'تسجيل الدخول',
                                style: TextStyle(fontSize: 16),
                              ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // رابط إنشاء حساب جديد
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('ليس لديك حساب جامعي؟'),
                        TextButton(
                          onPressed: isLoading
                              ? null
                              : () {
                                  widget.controller.clearError();
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (_) => RegisterPage(
                                        controller: widget.controller,
                                      ),
                                    ),
                                  );
                                },
                          child: const Text('إنشاء حساب جديد'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
