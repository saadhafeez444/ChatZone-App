import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import '../../../providers/theme_provider.dart';

class OnboardingScreen extends StatefulWidget {
  final VoidCallback? onComplete;
  const OnboardingScreen({super.key, this.onComplete});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingData> _data = [
    OnboardingData(
      title: 'Real-time\nMessaging',
      description:
          'Experience lightning fast communication with your friends and family across the globe.',
      image: 'assets/images/onboarding1.png',
      color: const Color(0xFF6C63FF), // Indigo
    ),
    OnboardingData(
      title: 'Global\nConnectivity',
      description:
          'Connect with anyone, anywhere. Our platform ensures you stay in touch no matter the distance.',
      image: 'assets/images/onboarding.png',
      color: const Color(0xFF00C9A7), // Emerald
    ),
    OnboardingData(
      title: 'Secure &\nPrivate',
      description:
          'Your privacy is our priority. Enjoy end-to-end encrypted conversations with peace of mind.',
      image: 'assets/images/onboarding3.png',
      color: const Color(0xFFFFB800), // Amber
    ),
  ];

  Future<void> _completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('showOnboarding', false);
    if (!mounted) return;
    if (widget.onComplete != null) {
      widget.onComplete!();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final themeProvider = context.watch<ThemeProvider>();
    final size = MediaQuery.of(context).size;

    final bool isLightMode = theme.brightness == Brightness.light;
    final Color pureBackgroundColor = isLightMode
        ? Colors.white
        : theme.scaffoldBackgroundColor;

    return Scaffold(
      backgroundColor: pureBackgroundColor,
      body: Stack(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            color: isLightMode
                ? Colors.transparent
                : _data[_currentPage].color.withOpacity(0.05),
          ),

          PageView.builder(
            controller: _pageController,
            physics: const BouncingScrollPhysics(),
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemCount: _data.length,
            itemBuilder: (context, index) {
              return _buildPage(
                context,
                _data[index],
                size,
                index == _currentPage,
              );
            },
          ),

          // Theme Toggle & Skip Button Row
          Positioned(
            top: MediaQuery.of(context).padding.top + 10,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: theme.colorScheme.outline.withOpacity(0.1),
                      ),
                    ),
                    child: Icon(
                      themeProvider.isDarkMode
                          ? Icons.light_mode_rounded
                          : Icons.dark_mode_rounded,
                      size: 20,
                    ),
                  ),
                  onPressed: () => themeProvider.toggleTheme(),
                ),
                TextButton(
                  onPressed: _completeOnboarding,
                  style: TextButton.styleFrom(
                    foregroundColor: theme.colorScheme.onSurface.withOpacity(
                      0.5,
                    ),
                  ),
                  child: const Text(
                    'Skip',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                  ),
                ).animate().fadeIn(delay: 500.ms),
              ],
            ),
          ),

          // Bottom Navigation Controls
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.fromLTRB(32, 24, 32, 48),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    pureBackgroundColor,
                    pureBackgroundColor.withOpacity(0.9),
                    pureBackgroundColor.withOpacity(0.0),
                  ],
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: List.generate(
                      _data.length,
                      (index) => AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.only(right: 8),
                        height: 8,
                        width: _currentPage == index ? 32 : 8,
                        decoration: BoxDecoration(
                          color: _currentPage == index
                              ? _data[_currentPage].color
                              : theme.dividerColor.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ),

                  GestureDetector(
                    onTap: () {
                      if (_currentPage == _data.length - 1) {
                        _completeOnboarding();
                      } else {
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.fastOutSlowIn,
                        );
                      }
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      height: 60,
                      width: _currentPage == _data.length - 1 ? 160 : 60,
                      decoration: BoxDecoration(
                        color: _data[_currentPage].color,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Center(
                        child: _currentPage == _data.length - 1
                            ? const Text(
                                'Get Started',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ).animate().fadeIn()
                            : const Icon(
                                Icons.arrow_forward_rounded,
                                color: Colors.white,
                                size: 28,
                              ).animate().fadeIn(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPage(
    BuildContext context,
    OnboardingData data,
    Size size,
    bool isActive,
  ) {
    final theme = Theme.of(context);

    return Stack(
      children: [
        // Large Image Section
        Positioned(
          top: size.height * 0.15,
          left: 0,
          right: 0,
          height: size.height * 0.4,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child:
                ClipRRect(
                      borderRadius: BorderRadius.circular(32),
                      child: Image.asset(data.image, fit: BoxFit.cover),
                    )
                    .animate(target: isActive ? 1 : 0)
                    .scale(
                      begin: const Offset(0.8, 0.8),
                      duration: 600.ms,
                      curve: Curves.easeOutBack,
                    )
                    .fadeIn(),
          ),
        ),

        // Text Content
        Positioned(
          bottom: size.height * 0.22,
          left: 32,
          right: 32,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                    data.title,
                    style: theme.textTheme.displayLarge?.copyWith(
                      height: 1.1,
                      fontSize: 26,
                      fontWeight: FontWeight.w900,
                      color: theme.colorScheme.onSurface,
                    ),
                  )
                  .animate(target: isActive ? 1 : 0)
                  .slideX(begin: -0.1, duration: 500.ms, curve: Curves.easeOut)
                  .fadeIn(),

              const SizedBox(height: 16),

              Text(
                    data.description,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      height: 1.6,
                      fontSize: 16,
                      color: theme.colorScheme.onSurface.withOpacity(0.7),
                    ),
                  )
                  .animate(target: isActive ? 1 : 0)
                  .slideX(
                    begin: -0.1,
                    duration: 500.ms,
                    delay: 100.ms,
                    curve: Curves.easeOut,
                  )
                  .fadeIn(),
            ],
          ),
        ),
      ],
    );
  }
}

class OnboardingData {
  final String title;
  final String description;
  final String image;
  final Color color;

  OnboardingData({
    required this.title,
    required this.description,
    required this.image,
    required this.color,
  });
}
