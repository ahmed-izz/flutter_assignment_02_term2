import 'package:flutter/material.dart';
import '../../controllers/auth_controller.dart';
import '../../utils/form_validators.dart';
import 'reset_password_page.dart';

class ForgotPasswordPage extends StatefulWidget {
  final AuthController controller;

  const ForgotPasswordPage({super.key, required this.controller});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _identifierController = TextEditingController();

  @override
  void dispose() {
    _identifierController.dispose();
    super.dispose();
  }

  Future<void> _sendResetCode() async {
    FocusScope.of(context).unfocus();
    widget.controller.clearError();

    if (!_formKey.currentState!.validate()) return;

    final success = await widget.controller.sendPasswordResetCode(
      identifier: _identifierController.text,
    );

    if (!mounted) return;

    if (success) {
      final otpHint = widget.controller.lastGeneratedOtp ?? '123456';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('تم إرسال رمز التحقق بنجاح (رمز التجربة: $otpHint)'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => ResetPasswordPage(controller: widget.controller),
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
        title: const Text('استعادة كلمة المرور'),
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
                    // بطاقة توجيهية أعلى الشاشة
                    Card(
                      color: Colors.indigo.shade50,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(color: Colors.indigo.shade200),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.all(16),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(Icons.info_outline, color: Colors.indigo),
                            SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'أدخل بريدك الجامعي أو رقمك الأكاديمي المسجل، وسنقوم بإرسال رمز تحقق مكون من 6 أرقام لتعيين كلمة مرور جديدة.',
                                style: TextStyle(height: 1.5),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // حقل البريد أو الرقم الأكاديمي
                    TextFormField(
                      controller: _identifierController,
                      enabled: !isLoading,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.done,
                      validator: FormValidators.validateIdentifier,
                      onFieldSubmitted: (_) => isLoading ? null : _sendResetCode(),
                      decoration: const InputDecoration(
                        labelText: 'البريد الجامعي أو الرقم الأكاديمي',
                        prefixIcon: Icon(Icons.mark_email_read_outlined),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // زر إرسال رمز التحقق
                    SizedBox(
                      height: 48,
                      child: ElevatedButton(
                        onPressed: isLoading ? null : _sendResetCode,
                        child: isLoading
                            ? const SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(strokeWidth: 2.5),
                              )
                            : const Text(
                                'إرسال رمز التحقق',
                                style: TextStyle(fontSize: 16),
                              ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // زر العودة لتسجيل الدخول
                    TextButton(
                      onPressed: isLoading ? null : () => Navigator.of(context).pop(),
                      child: const Text('العودة لتسجيل الدخول'),
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