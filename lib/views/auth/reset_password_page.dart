import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../controllers/auth_controller.dart';
import '../../utils/form_validators.dart';

class ResetPasswordPage extends StatefulWidget {
  final AuthController controller;

  const ResetPasswordPage({super.key, required this.controller});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _otpController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmNewPasswordController = TextEditingController();

  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _otpController.dispose();
    _newPasswordController.dispose();
    _confirmNewPasswordController.dispose();
    super.dispose();
  }

  Future<void> _submitReset() async {
    FocusScope.of(context).unfocus();
    widget.controller.clearError();

    if (!_formKey.currentState!.validate()) return;

    final success = await widget.controller.resetPassword(
      otpCode: _otpController.text,
      newPassword: _newPasswordController.text,
    );

    if (!mounted) return;

    if (success) {
      await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (ctx) => AlertDialog(
          icon: const Icon(
            Icons.check_circle_outline,
            color: Colors.green,
            size: 48,
          ),
          title: const Text('تم التحديث بنجاح'),
          content: const Text(
            'تم تحديث كلمة المرور بنجاح. يمكنك الآن تسجيل الدخول باستخدام كلمة المرور الجديدة.',
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(ctx).pop();
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
              child: const Text('الانتقال لتسجيل الدخول'),
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
        title: const Text('تعيين كلمة المرور الجديدة'),
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
                    Text(
                      'الحساب المستهدف: ${widget.controller.resetIdentifier}',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.grey.shade700,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // رمز التحقق OTP (6 أرقام حصراً)
                    TextFormField(
                      controller: _otpController,
                      enabled: !isLoading,
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(6),
                      ],
                      validator: FormValidators.validateOtp,
                      decoration: const InputDecoration(
                        labelText: 'رمز التحقق (6 أرقام)',
                        hintText: '123456',
                        prefixIcon: Icon(Icons.pin_outlined),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // كلمة المرور الجديدة
                    TextFormField(
                      controller: _newPasswordController,
                      enabled: !isLoading,
                      obscureText: _obscureNewPassword,
                      textInputAction: TextInputAction.next,
                      validator: FormValidators.validateStrongPassword,
                      decoration: InputDecoration(
                        labelText: 'كلمة المرور الجديدة',
                        helperText: '8 محارف على الأقل، تتضمن حرفاً كبيراً ورقماً',
                        prefixIcon: const Icon(Icons.lock_outline),
                        border: const OutlineInputBorder(),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureNewPassword
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscureNewPassword = !_obscureNewPassword;
                            });
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // تأكيد كلمة المرور الجديدة
                    TextFormField(
                      controller: _confirmNewPasswordController,
                      enabled: !isLoading,
                      obscureText: _obscureConfirmPassword,
                      textInputAction: TextInputAction.done,
                      validator: (val) => FormValidators.validateConfirmPassword(
                        val,
                        _newPasswordController.text,
                      ),
                      decoration: InputDecoration(
                        labelText: 'تأكيد كلمة المرور الجديدة',
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
                    const SizedBox(height: 24),

                    // زر تحديث كلمة المرور
                    SizedBox(
                      height: 48,
                      child: ElevatedButton(
                        onPressed: isLoading ? null : _submitReset,
                        child: isLoading
                            ? const SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(strokeWidth: 2.5),
                              )
                            : const Text(
                                'تحديث كلمة المرور',
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