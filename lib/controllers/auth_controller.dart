import 'package:flutter/foundation.dart';
import '../models/auth_requests.dart';
import '../models/user_model.dart';
import '../repositories/auth_repository.dart';

class AuthController extends ChangeNotifier {
  final AuthRepository _repository;

  AuthController({required AuthRepository repository}) : _repository = repository;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _rememberMe = false;
  bool get rememberMe => _rememberMe;

  String? _rememberedIdentifier;
  String? get rememberedIdentifier => _rememberedIdentifier;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  UserModel? _currentUser;
  UserModel? get currentUser => _currentUser;

  String _resetIdentifier = '';
  String get resetIdentifier => _resetIdentifier;

  String? _lastGeneratedOtp;
  String? get lastGeneratedOtp => _lastGeneratedOtp;

  void toggleRememberMe(bool? value) {
    _rememberMe = value ?? false;
    if (!_rememberMe) {
      _rememberedIdentifier = null;
    }
    notifyListeners();
  }

  void clearError() {
    if (_errorMessage != null) {
      _errorMessage = null;
      notifyListeners();
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  String _extractErrorMessage(Object error) {
    return error.toString().replaceFirst('Exception: ', '');
  }

  Future<bool> login({
    required String identifier,
    required String password,
  }) async {
    _errorMessage = null;
    _setLoading(true);

    try {
      final user = await _repository.login(
        LoginRequest(
          identifier: identifier,
          password: password,
          rememberMe: _rememberMe,
        ),
      );
      _currentUser = user;
      if (_rememberMe) {
        _rememberedIdentifier = identifier.trim();
      }
      _setLoading(false);
      return true;
    } catch (e) {
      _errorMessage = _extractErrorMessage(e);
      _setLoading(false);
      return false;
    }
  }

  Future<bool> register({
    required String fullName,
    required String academicId,
    required String email,
    required String password,
  }) async {
    _errorMessage = null;
    _setLoading(true);

    try {
      await _repository.register(
        RegisterRequest(
          fullName: fullName,
          academicId: academicId,
          email: email,
          password: password,
        ),
      );
      _setLoading(false);
      return true;
    } catch (e) {
      _errorMessage = _extractErrorMessage(e);
      _setLoading(false);
      return false;
    }
  }

  Future<bool> sendPasswordResetCode({required String identifier}) async {
    _errorMessage = null;
    _setLoading(true);

    try {
      final otp = await _repository.sendPasswordResetCode(identifier);
      _resetIdentifier = identifier.trim();
      _lastGeneratedOtp = otp;
      _setLoading(false);
      return true;
    } catch (e) {
      _errorMessage = _extractErrorMessage(e);
      _setLoading(false);
      return false;
    }
  }

  Future<bool> resetPassword({
    required String otpCode,
    required String newPassword,
  }) async {
    _errorMessage = null;
    _setLoading(true);

    try {
      await _repository.resetPassword(
        ResetPasswordRequest(
          identifier: _resetIdentifier,
          otpCode: otpCode,
          newPassword: newPassword,
        ),
      );
      _lastGeneratedOtp = null;
      _setLoading(false);
      return true;
    } catch (e) {
      _errorMessage = _extractErrorMessage(e);
      _setLoading(false);
      return false;
    }
  }
}