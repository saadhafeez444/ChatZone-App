import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'onboarding_screen.dart';
import '../auth/login_screen.dart';
import '../chat/chat_list_screen.dart';
import 'package:provider/provider.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/theme_provider.dart';

class SplashScreen extends StatefulWidget {
  final bool isNavigating;
  const SplashScreen({super.key, this.isNavigating = true});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _progressController;

  @override
  void initState() {
    super.initState();
    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    // Start filling from 0 to 1
    _progressController.forward();

    if (widget.isNavigating) {
      _navigateToNext();
    }
  }

  @override
  void dispose() {
    _progressController.dispose();
    super.dispose();
  }

  Future<void> _navigateToNext() async {
    await Future.delayed(const Duration(seconds: 3));
    if (!mounted) return;

    final prefs = await SharedPreferences.getInstance();
    final showOnboarding = prefs.getBool('showOnboarding') ?? true;
    final authProvider = context.read<AuthProvider>();

    if (showOnboarding) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const OnboardingScreen()),
      );
    } else {
      if (authProvider.isAuthenticated) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const ChatListScreen()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const LoginScreen()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Column(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                      child: Container(
                        height: 150,
                        width: 150,
                        decoration: BoxDecoration(
                          color: isDark
                              ? Colors.white
                              : theme.colorScheme.primary.withOpacity(0.1),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: isDark
                                  ? Colors.white.withOpacity(0.2)
                                  : Colors.black.withOpacity(0.1),
                              blurRadius: 30,
                              spreadRadius: 5,
                            ),
                          ],
                          // image: const DecorationImage(
                          //   image: AssetImage('assets/images/applogo.png'),
                          //   fit: BoxFit.cover, // Image occupies complete container
                          // ),
                        ),
                        child: Center(
                          child: Image.asset(
                            width: 130,
                            height: 130,
                            fit: BoxFit.fill,
                            'assets/images/applogo.png',
                          ),
                        ),
                      ),
                    )
                    .animate()
                    .scale(duration: 800.ms, curve: Curves.elasticOut)
                    .shimmer(delay: 1.seconds, duration: 2.seconds),
                const SizedBox(height: 32),
                Text(
                  'ChatZone',
                  style: theme.textTheme.displayLarge?.copyWith(
                    color: isDark ? Colors.white : theme.colorScheme.primary,
                    letterSpacing: 2,
                    fontSize: 48,
                    fontWeight: FontWeight.w900,
                  ),
                ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.3),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(48, 0, 48, 100),
            child: Column(
              children: [
                AnimatedBuilder(
                  animation: _progressController,
                  builder: (context, child) {
                    return LinearProgressIndicator(
                      value: _progressController.value,
                      // Track: semi-transparent white/purple
                      backgroundColor: isDark
                          ? Colors.white.withOpacity(0.1)
                          : theme.colorScheme.primary.withOpacity(0.1),
                      // Fill: Pure white/Dark Purple
                      valueColor: AlwaysStoppedAnimation<Color>(
                        isDark ? Colors.white : theme.colorScheme.primary,
                      ),
                      borderRadius: BorderRadius.circular(12),
                      minHeight: 12,
                    );
                  },
                ),
                const SizedBox(height: 16),
                Text(
                  'Loading ChatZone...',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.6),
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1,
                  ),
                ),
              ],
            ),
          ).animate().fadeIn(delay: 800.ms),
        ],
      ),
    );
  }
}
