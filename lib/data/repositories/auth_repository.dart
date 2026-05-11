import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';
import '../services/api_service.dart';

class AuthRepository {
  final ApiService _apiService;

  AuthRepository(this._apiService);

  Future<UserModel?> login(String email, String password) async {
    try {
      final response = await _apiService.dio.post(
        '/auth/login',
        data: {'email': email, 'password': password},
      );

      if (response.statusCode == 200) {
        final token = response.data['token'];
        final userData = response.data['user'];

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', token);
        await prefs.setString('userId', userData['id'] ?? userData['_id']);
        await prefs.setString('username', userData['username'] ?? 'User');

        return UserModel.fromJson(userData);
      }
    } catch (e) {
      rethrow;
    }
    return null;
  }

  Future<bool> signup(String username, String email, String password) async {
    try {
      final response = await _apiService.dio.post(
        '/auth/signup',
        data: {'username': username, 'email': email, 'password': password},
      );
      return response.statusCode == 201;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('userId');
    await prefs.remove('username');
  }

  Future<List<UserModel>> searchUsers(String query) async {
    try {
      final response = await _apiService.dio.get(
        '/auth/search',
        queryParameters: {'query': query},
      );

      if (response.statusCode == 200) {
        final List<dynamic> usersData = response.data;
        return usersData.map((json) => UserModel.fromJson(json)).toList();
      }
    } catch (e) {
      print('Search users error: $e');
    }
    return [];
  }

  Future<String?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('userId');
  }

  Future<String?> getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('username');
  }
}
