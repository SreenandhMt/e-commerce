import '../services/auth_service.dart';

abstract interface class AuthRepository {
  Future<void> login({required String email, required String password});
}

class AuthRepositoryImpl implements AuthRepository {
  final AuthService _authService;

  AuthRepositoryImpl({required AuthService authService}) : _authService = authService;

  @override
  Future<void> login({required String email, required String password}) async {
    try {
      await _authService.login(email: email, password: password);
    } catch (e) {
      // Catch backend exceptions and map them to domain-level exceptions
      throw Exception(e.toString().replaceFirst('Exception: ', ''));
    }
  }
}
