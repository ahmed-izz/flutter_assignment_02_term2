import 'package:flutter/material.dart';

import 'controllers/auth_controller.dart';
import 'repositories/auth_repository_impl.dart';
import 'views/auth/login_page.dart';

void main() {
  final authRepository = AuthRepositoryImpl();
  final authController = AuthController(repository: authRepository);

  runApp(StudentAuthApp(authController: authController));
}

class StudentAuthApp extends StatelessWidget {
  final AuthController authController;

  const StudentAuthApp({super.key, required this.authController});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'نظام المصادقة الطلابي',
      theme: ThemeData(colorSchemeSeed: Colors.indigo, useMaterial3: true),
      // دعم اتجاه الواجهة العربي RTL بدون حزم خارجية
      builder: (context, child) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: child ?? const SizedBox.shrink(),
        );
      },
      home: LoginPage(controller: authController),
    );
  }
}
