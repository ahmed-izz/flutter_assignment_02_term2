class LoginRequest {
  final String identifier; // المعرف الأكاديمي أو البريد الجامعي
  final String password;
  final bool rememberMe;

  const LoginRequest({
    required this.identifier,
    required this.password,
    this.rememberMe = false,
  });
}

class RegisterRequest {
  final String fullName;
  final String academicId;
  final String email;
  final String password;

  const RegisterRequest({
    required this.fullName,
    required this.academicId,
    required this.email,
    required this.password,
  });
}

class ResetPasswordRequest {
  final String identifier;
  final String otpCode;
  final String newPassword;

  const ResetPasswordRequest({
    required this.identifier,
    required this.otpCode,
    required this.newPassword,
  });
}