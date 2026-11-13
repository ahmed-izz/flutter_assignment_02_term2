import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../controllers/auth_controller.dart';
import '../../utils/form_validators.dart';

class RegisterPage extends StatefulWidget {
  final AuthController controller;

  const RegisterPage({super.key, required this.controller});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _academicIdController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _acceptedTerms = false;
  bool _showTermsError = false;

  @override
  void dispose() {
    _fullNameController.dispose();
    _academicIdController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _submitRegister() async {
    FocusScope.of(context).unfocus();
    widget.controller.clearError();

    final isFormValid = _formKey.currentState!.validate();
    setState(() {
      _showTermsError = !_acceptedTerms;
    });

    if (!isFormValid || !_acceptedTerms) return;

    final success = await widget.controller.register(
      fullName: _fullNameController.text,
      academicId: _academicIdController.text,
      email: _emailController.text,
      password: _passwordController.text,
    );

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('تم إنشاء الحساب بنجاح! يمكنك تسجيل الدخول الآن.'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.of(context).pop();
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
        title: const Text('إنشاء حساب طلابي'),
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
                    // الاسم الكامل
                    TextFormField(
                      controller: _fullNameController,
                      enabled: !isLoading,
                      textInputAction: TextInputAction.next,
                      validator: FormValidators.validateFullName,
                      decoration: const InputDecoration(
                        labelText: 'الاسم الكامل',
                        prefixIcon: Icon(Icons.badge_outlined),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 14),

                    // الرقم الأكاديمي
                    TextFormField(
                      controller: _academicIdController,
                      enabled: !isLoading,
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(10),
                      ],
                      validator: FormValidators.validateAcademicId,
                      decoration: const InputDecoration(
                        labelText: 'الرقم الأكاديمي (9 - 10 أرقام)',
                        prefixIcon: Icon(Icons.numbers_outlined),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 14),

                    // البريد الجامعي
                    TextFormField(
                      controller: _emailController,
                      enabled: !isLoading,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      validator: FormValidators.validateEmail,
                      decoration: const InputDecoration(
                        labelText: 'البريد الجامعي',
                        hintText: 'student@univ.edu',
                        prefixIcon: Icon(Icons.email_outlined),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 14),

                    // كلمة المرور القوية
                    TextFormField(
                      controller: _passwordController,
                      enabled: !isLoading,
                      obscureText: _obscurePassword,
                      textInputAction: TextInputAction.next,
                      validator: FormValidators.validateStrongPassword,
                      decoration: InputDecoration(
                        labelText: 'كلمة المرور',
                        helperText: '8 محارف على الأقل، تتضمن حرفاً كبيراً ورقماً',
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
                    const SizedBox(height: 14),

                    // تأكيد كلمة المرور
                    TextFormField(
                      controller: _confirmPasswordController,
                      enabled: !isLoading,
                      obscureText: _obscureConfirmPassword,
                      textInputAction: TextInputAction.done,
                      validator: (val) => FormValidators.validateConfirmPassword(
                        val,
                        _passwordController.text,
                      ),
                      decoration: InputDecoration(
                        labelText: 'تأكيد كلمة المرور',
                        prefixIcon: const Icon(Icons.lock_reset_outlined),
                        border: const OutlineInputBorder(),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureConfirmPassword
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscureConfirmPassword = !_obscureConfirmPassword;
                            });
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // الموافقة على اللوائح والشروط الأكاديمية
                    CheckboxListTile(
                      contentPadding: EdgeInsets.zero,
                      controlAffinity: ListTileControlAffinity.leading,
                      value: _acceptedTerms,
                      onChanged: isLoading
                          ? null
                          : (value) {
                              setState(() {
                                _acceptedTerms = value ?? false;
                                if (_acceptedTerms) {
                                  _showTermsError = false;
                                }
                              });
                            },
                      title: const Text(
                        'أوافق على اللوائح والشروط الأكاديمية للجامعة',
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                    if (_showTermsError)
                      Padding(
                        padding: const EdgeInsets.only(right: 12, bottom: 8),
                        child: Text(
                          'يجب الموافقة على اللوائح والشروط الأكاديمية للمتابعة',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.error,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    const SizedBox(height: 16),

                    // زر إنشاء الحساب
                    SizedBox(
                      height: 48,
                      child: ElevatedButton(
                        onPressed: isLoading ? null : _submitRegister,
                        child: isLoading
                            ? const SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(strokeWidth: 2.5),
                              )
                            : const Text(
                                'إنشاء الحساب',
                                style: TextStyle(fontSize: 16),
                              ),
                      ),
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