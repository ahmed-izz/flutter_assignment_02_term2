class FormValidators {
  FormValidators._();

  static final RegExp _emailRegex = RegExp(
    r'^[\w\.\-]+@([\w\-]+\.)+[\w\-]{2,}$',
  );
  static final RegExp _academicIdRegex = RegExp(r'^\d{9,10}$');
  static final RegExp _otpRegex = RegExp(r'^\d{6}$');
  static final RegExp _upperCaseRegex = RegExp(r'[A-Z]');
  static final RegExp _digitRegex = RegExp(r'\d');

  /// التحقق من المعرف الأكاديمي أو البريد في شاشة الدخول والاستعادة (≥ 5 خانات)
  static String? validateIdentifier(String? value) {
    final trimmed = value?.trim() ?? '';
    if (trimmed.isEmpty) {
      return 'يرجى إدخال المعرف الأكاديمي أو البريد الإلكتروني';
    }
    if (trimmed.length < 5) {
      return 'يجب أن لا يقل المعرف عن 5 خانات';
    }
    if (trimmed.contains('@') && !_emailRegex.hasMatch(trimmed)) {
      return 'صيغة البريد الإلكتروني غير صحيحة';
    }
    if (trimmed.contains(' ')) {
      return 'يجب ألا يحتوي المعرف على مسافات';
    }
    return null;
  }

  /// التحقق من كلمة المرور في تسجيل الدخول (≥ 6 محارف)
  static String? validateLoginPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'يرجى إدخال كلمة المرور';
    }
    if (value.length < 6) {
      return 'كلمة المرور يجب أن تكون 6 محارف على الأقل';
    }
    return null;
  }

  /// التحقق من الاسم الكامل (≥ 3 محارف)
  static String? validateFullName(String? value) {
    final trimmed = value?.trim() ?? '';
    if (trimmed.isEmpty) {
      return 'يرجى إدخال الاسم الكامل';
    }
    if (trimmed.length < 3) {
      return 'الاسم الكامل يجب أن يكون 3 محارف على الأقل';
    }
    return null;
  }

  /// التحقق من الرقم الأكاديمي (أرقام حصراً، 9-10 خانات)
  static String? validateAcademicId(String? value) {
    final trimmed = value?.trim() ?? '';
    if (trimmed.isEmpty) {
      return 'يرجى إدخال الرقم الأكاديمي';
    }
    if (!_academicIdRegex.hasMatch(trimmed)) {
      return 'الرقم الأكاديمي يجب أن يتكون من 9 إلى 10 أرقام حصراً';
    }
    return null;
  }

  /// التحقق من البريد الجامعي (صيغة Regex قياسية)
  static String? validateEmail(String? value) {
    final trimmed = value?.trim() ?? '';
    if (trimmed.isEmpty) {
      return 'يرجى إدخال البريد الجامعي';
    }
    if (!_emailRegex.hasMatch(trimmed)) {
      return 'يرجى إدخال بريد إلكتروني صحيح';
    }
    return null;
  }

  /// التحقق من كلمة المرور القوية (≥ 8 محارف + حرف كبير + رقم)
  static String? validateStrongPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'يرجى إدخال كلمة المرور';
    }
    if (value.length < 8) {
      return 'كلمة المرور يجب أن تكون 8 محارف على الأقل';
    }
    if (!_upperCaseRegex.hasMatch(value)) {
      return 'يجب أن تحتوي كلمة المرور على حرف كبير واحد على الأقل (A-Z)';
    }
    if (!_digitRegex.hasMatch(value)) {
      return 'يجب أن تحتوي كلمة المرور على رقم واحد على الأقل (0-9)';
    }
    return null;
  }

  /// التحقق من مطابقة كلمة المرور 100%
  static String? validateConfirmPassword(String? value, String original) {
    if (value == null || value.isEmpty) {
      return 'يرجى تأكيد كلمة المرور';
    }
    if (value != original) {
      return 'كلمة المرور غير متطابقة';
    }
    return null;
  }

  /// التحقق من رمز التحقق OTP (6 أرقام حصراً)
  static String? validateOtp(String? value) {
    final trimmed = value?.trim() ?? '';
    if (trimmed.isEmpty) {
      return 'يرجى إدخال رمز التحقق';
    }
    if (!_otpRegex.hasMatch(trimmed)) {
      return 'رمز التحقق يجب أن يتكون من 6 أرقام حصراً';
    }
    return null;
  }
}