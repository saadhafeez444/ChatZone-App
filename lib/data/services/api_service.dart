import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static const String baseUrl = 'https://live-chating-apis.onrender.com';
  final Dio _dio = Dio(BaseOptions(
    baseUrl: baseUrl,
    connectTimeout: const Duration(seconds: 15), // Slightly increased for stability
    receiveTimeout: const Duration(seconds: 15),
    validateStatus: (status) => status != null && status < 500, // Handle non-500 errors gracefully
  ));

  ApiService() {
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final prefs = await SharedPreferences.getInstance();
        final token = prefs.getString('token');
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options);
      },
      onError: (DioException e, handler) {
        // Handle connection errors specifically
        if (e.type == DioExceptionType.connectionTimeout || 
            e.type == DioExceptionType.receiveTimeout) {
          print('Network Timeout: Please check your connection.');
        }
        return handler.next(e);
      },
    ));
  }

  Dio get dio => _dio;
}
