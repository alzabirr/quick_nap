import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:upgrade_flutter_starter_kit/main.dart';
import 'package:upgrade_flutter_starter_kit/providers/sleep_provider.dart';
import 'package:upgrade_flutter_starter_kit/providers/alarm_provider.dart';
import 'package:upgrade_flutter_starter_kit/providers/audio_library_provider.dart';

void main() {
  setUpAll(() async {
    // Initialize Hive in a temporary directory for unit tests
    Hive.init(Directory.systemTemp.path);
    await Hive.openBox('snap_settings');
  });

  testWidgets('SnapApp Dashboard build test', (WidgetTester tester) async {
    // Build SnapApp starting directly on HomeScreen
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => SleepProvider()),
          ChangeNotifierProvider(create: (_) => AlarmProvider()),
          ChangeNotifierProvider(create: (_) => AudioLibraryProvider()),
        ],
        child: const SnapApp(onboardingComplete: true),
      ),
    );

    // Verify the app title is present
    expect(find.textContaining('QUICK NAP'), findsOneWidget);

    // Settle all animations/timers
    await tester.pumpAndSettle();
  });
}
