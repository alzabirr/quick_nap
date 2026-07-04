import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Handles requesting battery optimization exemption from the user.
/// This is critical for alarm reliability on Android — without it,
/// the OS can kill or delay the alarm when the app is in background.
class BatteryOptimizationService {
  static const MethodChannel _channel =
      MethodChannel('com.example.snap/battery');

  static bool _hasRequested = false;

  /// Shows a dialog asking the user to disable battery optimization for
  /// this app. Should be called once when the user first sets an alarm.
  static Future<void> requestExemptionIfNeeded(BuildContext context) async {
    if (!Platform.isAndroid) return;
    if (_hasRequested) return;
    _hasRequested = true;

    final isIgnoring = await _isIgnoringBatteryOptimizations();
    if (isIgnoring) return;

    if (!context.mounted) return;

    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xff1a1a2e),
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        title: const Row(
          children: [
            Icon(Icons.battery_alert, color: Color(0xffe76e55), size: 22),
            SizedBox(width: 10),
            Text(
              'ALARM RELIABILITY',
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'PressStart2P',
                fontSize: 11,
              ),
            ),
          ],
        ),
        content: const Text(
          'To make sure your alarm NEVER misses, allow Quick Nap to run without battery restrictions.\n\nTap "Allow" on the next screen.',
          style: TextStyle(
            color: Color(0xffaaaaaa),
            fontFamily: 'PressStart2P',
            fontSize: 9,
            height: 1.8,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('SKIP',
                style: TextStyle(color: Color(0xff666666), fontSize: 9, fontFamily: 'PressStart2P')),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xffe76e55),
              shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
            ),
            onPressed: () {
              Navigator.of(ctx).pop();
              _openBatteryOptimizationSettings();
            },
            child: const Text('ALLOW',
                style: TextStyle(color: Colors.white, fontSize: 9, fontFamily: 'PressStart2P')),
          ),
        ],
      ),
    );
  }

  static Future<bool> _isIgnoringBatteryOptimizations() async {
    try {
      final result = await _channel.invokeMethod<bool>('isIgnoringBatteryOptimizations');
      return result ?? false;
    } catch (_) {
      return false;
    }
  }

  static Future<void> _openBatteryOptimizationSettings() async {
    try {
      await _channel.invokeMethod('requestIgnoreBatteryOptimizations');
    } catch (e) {
      debugPrint('Battery optimization request failed: $e');
    }
  }
}
