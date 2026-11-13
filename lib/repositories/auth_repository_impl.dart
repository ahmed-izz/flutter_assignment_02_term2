import '../models/auth_requests.dart';
import '../models/user_model.dart';
import 'auth_repository.dart';

class _StoredUser {
  final UserModel user;
  String password;

  _StoredUser({required this.user, required this.password});
}

class AuthRepositoryImpl implements AuthRepository {
  // محاكاة قاعدة بيانات محلية في الذاكرة مع حساب طالب افتراضي للتجربة
  final List<_StoredUser> _users = [
    _StoredUser(
      user: const UserModel(
        id: '1',
        fullName: 'أحمد محمد علي',
        academicId: '202410001',
        email: 'student@univ.edu',
      ),
      password: 'Password1',
    ),
  ];

  final Map<String, String> _otpCodes = {};

  @override
  Future<UserModel> login(LoginRequest request) async {
    await Future.delayed(const Duration(seconds: 1));

    final key = request.identifier.trim().toLowerCase();
    final matched = _users.where(
      (entry) =>
          entry.user.email.toLowerCase() == key ||
          entry.user.academicId == request.identifier.trim(),
    );

    if (matched.isEmpty) {
      throw Exception('الحساب غير موجود. يرجى التحقق من المعرف أو إنشاء حساب.');
    }

    final account = matched.first;
    if (account.password != request.password) {
      throw Exception('كلمة المرور غير صحيحة.');
    }

    return account.user;
  }

  @override
  Future<UserModel> register(RegisterRequest request) async {
    await Future.delayed(const Duration(seconds: 1));

    final emailExists = _users.any(
      (entry) => entry.user.email.toLowerCase() == request.email.trim().toLowerCase(),
    );
    if (emailExists) {
      throw Exception('البريد الجامعي مسجل مسبقاً.');
    }

    final academicIdExists = _users.any(
      (entry) => entry.user.academicId == request.academicId.trim(),
    );
    if (academicIdExists) {
      throw Exception('الرقم الأكاديمي مسجل مسبقاً.');
    }

    final newUser = UserModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      fullName: request.fullName.trim(),
      academicId: request.academicId.trim(),
      email: request.email.trim(),
    );

    _users.add(_StoredUser(user: newUser, password: request.password));
    return newUser;
  }

  @override
  Future<String> sendPasswordResetCode(String identifier) async {
    await Future.delayed(const Duration(seconds: 1));

    final key = identifier.trim().toLowerCase();
    final matched = _users.where(
      (entry) =>
          entry.user.email.toLowerCase() == key ||
          entry.user.academicId == identifier.trim(),
    );

    if (matched.isEmpty) {
      throw Exception('لم يتم العثور على حساب مرتبط بهذا المعرف.');
    }

    // رمز تحقق محاكى ثابت لتسهيل الاختبار
    const simulatedOtp = '123456';
    _otpCodes[matched.first.user.academicId] = simulatedOtp;
    return simulatedOtp;
  }

  @override
  Future<void> resetPassword(ResetPasswordRequest request) async {
    await Future.delayed(const Duration(seconds: 1));

    final key = request.identifier.trim().toLowerCase();
    final matched = _users.where(
      (entry) =>
          entry.user.email.toLowerCase() == key ||
          entry.user.academicId == request.identifier.trim(),
    );

    if (matched.isEmpty) {
      throw Exception('تعذر العثور على الحساب المطلوب.');
    }

    final account = matched.first;
    final expectedOtp = _otpCodes[account.user.academicId];

    if (expectedOtp == null || expectedOtp != request.otpCode.trim()) {
      throw Exception('رمز التحقق غير صحيح أو منتهي الصلاحية.');
    }

    account.password = request.newPassword;
    _otpCodes.remove(account.user.academicId);
  }
}