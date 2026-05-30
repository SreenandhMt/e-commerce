abstract interface class AuthService {
  Future<void> login({required String email, required String password});
}

class MockAuthService implements AuthService {
  @override
  Future<void> login({required String email, required String password}) async {
    await Future.delayed(const Duration(milliseconds: 1500));

    if (email.trim() == 'fail@example.com') {
      throw Exception(
        'Invalid email or password. Please try again with a different email.',
      );
    }
  }
}
