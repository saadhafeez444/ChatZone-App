import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:live_chating_apis/core/theme/app_theme.dart';
import 'package:live_chating_apis/providers/home_provider.dart';
import 'package:live_chating_apis/providers/theme_provider.dart';
import 'package:live_chating_apis/data/services/api_service.dart';
import 'package:live_chating_apis/data/services/socket_service.dart';
import 'package:live_chating_apis/data/repositories/auth_repository.dart';
import 'package:live_chating_apis/data/repositories/chat_repository.dart';
import 'package:live_chating_apis/providers/auth_provider.dart';
import 'package:live_chating_apis/providers/chat_provider.dart';
import 'package:live_chating_apis/views/screens/auth/login_screen.dart';
import 'package:live_chating_apis/views/screens/chat/chat_list_screen.dart';
import 'package:live_chating_apis/views/screens/intro/splash_screen.dart';
import 'package:live_chating_apis/views/screens/intro/onboarding_screen.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(statusBarColor: Colors.transparent),
  );
  WidgetsFlutterBinding.ensureInitialized();

  final apiService = ApiService();
  final socketService = SocketService();
  final authRepository = AuthRepository(apiService);
  final chatRepository = ChatRepository(apiService);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(
          create: (_) => AuthProvider(authRepository)..checkAuth(),
        ),
        ChangeNotifierProvider(
          create: (_) => ChatProvider(chatRepository, socketService),
        ),
        ChangeNotifierProvider(create: (_) => HomeProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _showSplash = true;
  bool _showOnboarding = true;

  @override
  void initState() {
    super.initState();
    _initApp();
  }

  Future<void> _initApp() async {
    final prefs = await SharedPreferences.getInstance();
    final showOnboarding = prefs.getBool('showOnboarding') ?? true;

    await Future.delayed(const Duration(seconds: 3));
    if (mounted) {
      setState(() {
        _showOnboarding = showOnboarding;
        _showSplash = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<ThemeProvider, AuthProvider>(
      builder: (context, themeProvider, authProvider, child) {
        return MaterialApp(
          title: 'Live Chatting APIs',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: themeProvider.themeMode,
          home: _showSplash
              ? const SplashScreen(isNavigating: false)
              : (_showOnboarding
                    ? OnboardingScreen(
                        onComplete: () {
                          setState(() {
                            _showOnboarding = false;
                          });
                        },
                      )
                    : (authProvider.isAuthenticated
                          ? const ChatListScreen()
                          : const LoginScreen())),
        );
      },
    );
  }
}
