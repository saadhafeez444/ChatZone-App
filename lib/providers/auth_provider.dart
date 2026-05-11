import 'package:flutter/material.dart';
import '../data/models/user_model.dart';
import '../data/repositories/auth_repository.dart';

class AuthProvider extends ChangeNotifier {
  final AuthRepository _authRepository;
  UserModel? _user;
  bool _isLoading = false;

  AuthProvider(this._authRepository);

  UserModel? get user => _user;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _user != null;

  Future<bool> login(String email, String password) async {
    if (_isLoading) return false; // Prevent multiple simultaneous login calls
    
    _isLoading = true;
    notifyListeners();
    try {
      _user = await _authRepository.login(email, password);
      return _user != null;
    } catch (e) {
      print('Login error: $e');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> signup(String username, String email, String password) async {
    _isLoading = true;
    notifyListeners();
    try {
      return await _authRepository.signup(username, email, password);
    } catch (e) {
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    await _authRepository.logout();
    _user = null;
    notifyListeners();
  }

  List<UserModel> _searchResults = [];
  List<UserModel> get searchResults => _searchResults;

  Future<void> searchUsers(String query) async {
    if (query.isEmpty) {
      _searchResults = [];
      notifyListeners();
      return;
    }
    
    _isLoading = true;
    notifyListeners();
    try {
      _searchResults = await _authRepository.searchUsers(query);
    } catch (e) {
      print('DEBUG: searchUsers error: $e');
      _searchResults = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> checkAuth() async {
    final userId = await _authRepository.getUserId();
    final username = await _authRepository.getUsername();
    if (userId != null) {
      _user = UserModel(id: userId, username: username ?? 'User', email: '');
      notifyListeners();
    }
  }
}
