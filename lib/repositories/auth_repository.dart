import '../models/auth_requests.dart';
import '../models/user_model.dart';

abstract class AuthRepository {
  Future<UserModel> login(LoginRequest request);
  Future<UserModel> register(RegisterRequest request);
  Future<String> sendPasswordResetCode(String identifier);
  Future<void> resetPassword(ResetPasswordRequest request);
}