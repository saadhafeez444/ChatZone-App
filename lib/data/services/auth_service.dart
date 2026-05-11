import 'dart:async';

/// Base class for all services to handle common logic
abstract class BaseService {
  // Common logging or error handling can go here
}

class AuthService extends BaseService {
  // Mocking auth status
  bool _isAuthenticated = false;
  bool get isAuthenticated => _isAuthenticated;

  Future<bool> login(String email, String password) async {
    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));
    if (email == "test@example.com" && password == "password") {
      _isAuthenticated = true;
      return true;
    }
    return false;
  }

  void logout() {
    _isAuthenticated = false;
  }
}
