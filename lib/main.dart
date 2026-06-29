import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'screens/home_screen.dart';
import 'screens/onboarding_screen.dart';
import 'storage/hive_storage.dart';
import 'themes/app_theme.dart';
import 'providers/sleep_provider.dart';
import 'providers/alarm_provider.dart';
import 'providers/audio_library_provider.dart';
import 'providers/notes_provider.dart';
import 'services/alarm_notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Set status bar and system navigation bar transparent
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarDividerColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.light,
      systemNavigationBarContrastEnforced: false,
      systemStatusBarContrastEnforced: false,
    ),
  );
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

  // Initialize offline Hive storage and adapters
  await HiveStorage.init();
  await AlarmNotificationService.initialize();

  final storage = HiveStorage();
  
  // Load initial Dark Mode preference
  final isDark = storage.getSetting('darkMode', true) as bool; // Default to dark mode for sleep
  darkModeNotifier.value = isDark;

  final onboardingComplete = storage.getSetting('onboarding_complete', false) as bool;

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SleepProvider()),
        ChangeNotifierProvider(create: (_) => AlarmProvider()),
        ChangeNotifierProvider(create: (_) => AudioLibraryProvider()),
        ChangeNotifierProvider(create: (_) => NotesProvider()),
      ],
      child: SnapApp(onboardingComplete: onboardingComplete),
    ),
  );
}

class SnapApp extends StatelessWidget {
  final bool onboardingComplete;
  
  const SnapApp({super.key, required this.onboardingComplete});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: darkModeNotifier,
      builder: (context, isDark, child) {
        return MaterialApp(
          title: 'Sleep Cycle & Alarm',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            brightness: isDark ? Brightness.dark : Brightness.light,
            primaryColor: const Color(0xFFD7494C),
            scaffoldBackgroundColor: isDark ? const Color(0xFF000000) : const Color(0xFFF2F2F7),
            appBarTheme: AppBarTheme(
              backgroundColor: Colors.transparent,
              elevation: 0,
              foregroundColor: isDark ? const Color(0xFFF5F5F7) : const Color(0xFF1C1C1E),
              systemOverlayStyle: SystemUiOverlayStyle(
                statusBarColor: Colors.transparent,
                statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
                statusBarBrightness: isDark ? Brightness.dark : Brightness.light,
                systemNavigationBarColor: Colors.transparent,
                systemNavigationBarDividerColor: Colors.transparent,
                systemNavigationBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
                systemNavigationBarContrastEnforced: false,
                systemStatusBarContrastEnforced: false,
              ),
            ),
            cupertinoOverrideTheme: CupertinoThemeData(
              brightness: isDark ? Brightness.dark : Brightness.light,
              primaryColor: const Color(0xFFD7494C),
              barBackgroundColor: isDark ? const Color(0xCC121212) : const Color(0xCCFFFFFF),
              scaffoldBackgroundColor: isDark ? const Color(0xFF000000) : const Color(0xFFF2F2F7),
              textTheme: const CupertinoTextThemeData(primaryColor: Color(0xFFD7494C)),
            ),
          ),
          home: onboardingComplete ? const HomeScreen() : const OnboardingScreen(),
          routes: {
            '/home': (context) => const HomeScreen(),
            '/onboarding': (context) => const OnboardingScreen(),
          },
        );
      },
    );
  }
}
