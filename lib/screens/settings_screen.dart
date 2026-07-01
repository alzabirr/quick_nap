import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:nes_ui/nes_ui.dart';
import '../providers/alarm_provider.dart';
import '../providers/sleep_provider.dart';
import '../storage/hive_storage.dart';
import '../themes/app_theme.dart';
import '../widgets/ambient_background.dart';

class SettingsScreen extends StatefulWidget {
  final double? bottomPadding;
  const SettingsScreen({super.key, this.bottomPadding});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final HiveStorage _storage = HiveStorage();
  late String _profileName;
  late String _workspaceName;
  late bool _notificationsEnabled;
  late bool _cloudSyncEnabled;
  late bool _hapticFeedbackEnabled;

  @override
  void initState() {
    super.initState();
    _profileName = _storage.getSetting('profileName', 'Starter User') as String;
    _workspaceName =
        _storage.getSetting('workspaceName', 'Personal workspace') as String;
    _notificationsEnabled =
        _storage.getSetting('notificationsEnabled', true) as bool;
    _cloudSyncEnabled = _storage.getSetting('cloudSyncEnabled', false) as bool;
    _hapticFeedbackEnabled =
        _storage.getSetting('hapticFeedbackEnabled', true) as bool;
  }

  Future<void> _saveBool(String key, bool value) async {
    await _storage.saveSetting(key, value);
  }

  Future<void> _updateNotifications(bool value) async {
    setState(() => _notificationsEnabled = value);
    await _saveBool('notificationsEnabled', value);
  }

  Future<void> _updateCloudSync(bool value) async {
    setState(() => _cloudSyncEnabled = value);
    await _saveBool('cloudSyncEnabled', value);
    if (!mounted) return;
    _showInfoDialog(
      title: value ? 'Cloud sync on' : 'Cloud sync off',
      message: value
          ? 'Your data will be backed up when cloud sync is connected.'
          : 'Your data will stay local on this device.',
    );
  }

  Future<void> _updateHapticFeedback(bool value) async {
    setState(() => _hapticFeedbackEnabled = value);
    await _saveBool('hapticFeedbackEnabled', value);
  }

  Future<void> _showEditProfileDialog() async {
    final nameController = TextEditingController(text: _profileName);
    final workspaceController = TextEditingController(text: _workspaceName);

    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: surface,
          title: Text('Edit profile', style: headingStyle(fontSize: 12, fontWeight: FontWeight.bold)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Name'),
                style: const TextStyle(fontSize: 12),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: workspaceController,
                decoration: const InputDecoration(labelText: 'Workspace'),
                style: const TextStyle(fontSize: 12),
              ),
            ],
          ),
          actions: [
            NesButton(
              type: NesButtonType.normal,
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text('Cancel', style: bodyStyle(fontSize: 10, color: Colors.black)),
            ),
            NesButton(
              type: NesButtonType.primary,
              onPressed: () async {
                final name = nameController.text.trim().isEmpty
                    ? 'Starter User'
                    : nameController.text.trim();
                final workspace = workspaceController.text.trim().isEmpty
                    ? 'Personal workspace'
                    : workspaceController.text.trim();

                setState(() {
                  _profileName = name;
                  _workspaceName = workspace;
                });
                await _storage.saveSetting('profileName', name);
                await _storage.saveSetting('workspaceName', workspace);
                if (dialogContext.mounted) {
                  Navigator.of(dialogContext).pop();
                }
              },
              child: Text('Save', style: bodyStyle(fontSize: 10)),
            ),
          ],
        );
      },
    );

    nameController.dispose();
    workspaceController.dispose();
  }

  void _showInfoDialog({required String title, required String message}) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: surface,
        title: Text(title, style: headingStyle(fontSize: 12, fontWeight: FontWeight.bold)),
        content: Text(message, style: bodyStyle(fontSize: 10, color: textMid)),
        actions: [
          NesButton(
            type: NesButtonType.primary,
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text('OK', style: bodyStyle(fontSize: 10)),
          ),
        ],
      ),
    );
  }

  void _showPrivacyDialog() {
    _showInfoDialog(
      title: 'Privacy',
      message: 'Data is stored locally on this device.',
    );
  }

  void _showAboutDialog() {
    _showInfoDialog(
      title: 'About Nappy',
      message: 'Nappy 1.0.0\nQuick sleep tracking and alarm app.',
    );
  }

  @override
  Widget build(BuildContext context) {
    final double listBottomPadding = widget.bottomPadding ?? (28.0 + MediaQuery.of(context).padding.bottom);
    final canPop = Navigator.of(context).canPop();
    return Scaffold(
      backgroundColor: bgLight,
      body: AmbientBackground(
        child: SafeArea(
          bottom: widget.bottomPadding == null,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Pinned Header Row
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
                child: Row(
                  children: [
                    if (canPop) ...[
                      NesButton(
                        type: NesButtonType.normal,
                        onPressed: () => Navigator.of(context).pop(),
                        child: Icon(CupertinoIcons.chevron_left, color: isDarkMode ? Colors.white : Colors.black, size: 20),
                      ),
                      const SizedBox(width: 12),
                    ],
                    Text(
                      'SETTINGS',
                      style: headingStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  padding: EdgeInsets.fromLTRB(20, 4, 20, listBottomPadding),
                  physics: const BouncingScrollPhysics(),
                  children: [
                    _ProfileHeader(
                      name: _profileName,
                      workspaceName: _workspaceName,
                      onTap: _showEditProfileDialog,
                    ),
                    const SizedBox(height: 16),

                    _SettingsGroup(
                      title: 'ACCOUNT',
                      children: [
                        _ActionSetting(
                          icon: CupertinoIcons.person_crop_circle,
                          title: 'Edit profile',
                          subtitle: 'Name and personal details',
                          onTap: _showEditProfileDialog,
                        ),
                        const _Divider(),
                        _SwitchSetting(
                          title: 'Notifications',
                          subtitle: 'Alarm and reminder alerts',
                          value: _notificationsEnabled,
                          onChanged: _updateNotifications,
                        ),
                        const _Divider(),
                        _SwitchSetting(
                          title: 'Cloud sync',
                          subtitle: 'Back up your data',
                          value: _cloudSyncEnabled,
                          onChanged: _updateCloudSync,
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    _SettingsGroup(
                      title: 'APPEARANCE',
                      children: [
                        _SwitchSetting(
                          title: 'Dark Mode',
                          subtitle: 'Easier on the eyes at night',
                          value: darkModeNotifier.value,
                          onChanged: (val) async {
                            await _storage.saveSetting('darkMode', val);
                            darkModeNotifier.value = val;
                            setState(() {});
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    _SettingsGroup(
                      title: 'APP',
                      children: [
                        _SwitchSetting(
                          title: 'Haptic feedback',
                          subtitle: 'Vibrate on interactions',
                          value: _hapticFeedbackEnabled,
                          onChanged: _updateHapticFeedback,
                        ),
                        const _Divider(),
                        _ActionSetting(
                          icon: CupertinoIcons.lock_shield,
                          title: 'Privacy',
                          subtitle: 'Data stays on this device',
                          onTap: _showPrivacyDialog,
                        ),
                        const _Divider(),
                        _ActionSetting(
                          icon: CupertinoIcons.info_circle,
                          title: 'About',
                          subtitle: 'Version 1.0.0',
                          onTap: _showAboutDialog,
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    _SettingsGroup(
                      title: 'DATA',
                      children: [
                        _ActionSetting(
                          icon: CupertinoIcons.refresh,
                          title: 'Reset Application',
                          subtitle: 'Clear all data and start fresh',
                          onTap: () async {
                            showDialog<void>(
                              context: context,
                              builder: (dialogContext) => AlertDialog(
                                backgroundColor: surface,
                                title: Text("Reset App?", style: headingStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                                content: Text("This will clear all your sleep history, dream notes, and goals. This cannot be undone.", style: bodyStyle(fontSize: 10, color: textMid)),
                                actions: [
                                  NesButton(
                                    type: NesButtonType.normal,
                                    onPressed: () => Navigator.of(dialogContext).pop(),
                                    child: Text("Cancel", style: bodyStyle(fontSize: 10, color: Colors.black)),
                                  ),
                                  NesButton(
                                    type: NesButtonType.error,
                                    onPressed: () async {
                                      final storage = HiveStorage();
                                      await storage.saveSetting('onboarding_complete', false);
                                      await storage.saveSetting('sessions_list', null);
                                      await storage.saveSetting('dream_notes_list', null);
                                      await storage.saveSetting('alarm_config', null);
                                      await storage.saveSetting('sleep_goal', null);
                                      if (context.mounted) {
                                        Provider.of<SleepProvider>(context, listen: false).resetState();
                                        Provider.of<AlarmProvider>(context, listen: false).resetState();
                                        Navigator.of(dialogContext).pop();
                                        Navigator.of(context).pushNamedAndRemoveUntil('/onboarding', (route) => false);
                                      }
                                    },
                                    child: Text("Reset", style: bodyStyle(fontSize: 10)),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  final String name;
  final String workspaceName;
  final VoidCallback onTap;

  const _ProfileHeader({
    required this.name,
    required this.workspaceName,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return NesButton(
      type: NesButtonType.normal,
      onPressed: onTap,
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: primary,
              border: Border.all(color: Colors.white, width: 2),
            ),
            child: const Icon(CupertinoIcons.person_fill, color: Colors.white, size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: bodyStyle(fontSize: 12, fontWeight: FontWeight.bold), maxLines: 1, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 2),
                Text(workspaceName, style: bodyStyle(fontSize: 8, color: textMid), maxLines: 1, overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
          Icon(CupertinoIcons.chevron_forward, color: textMid, size: 14),
        ],
      ),
    );
  }
}

class _SettingsGroup extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _SettingsGroup({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return NesContainer(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(title, style: bodyStyle(fontSize: 8, color: textMid, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          ...children,
        ],
      ),
    );
  }
}

class _ActionSetting extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _ActionSetting({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return NesButton(
      type: NesButtonType.normal,
      onPressed: onTap,
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: primary.withValues(alpha: 0.2),
              border: Border.all(color: primary, width: 1),
            ),
            child: Icon(icon, color: primary, size: 16),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: bodyStyle(fontSize: 10, fontWeight: FontWeight.bold), maxLines: 1, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 2),
                Text(subtitle, style: bodyStyle(fontSize: 8, color: textMid), maxLines: 1, overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
          Icon(CupertinoIcons.chevron_forward, color: textMid, size: 14),
        ],
      ),
    );
  }
}

class _SwitchSetting extends StatelessWidget {
  final String title;
  final String? subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _SwitchSetting({
    required this.title,
    this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: bodyStyle(fontSize: 10, fontWeight: FontWeight.bold)),
              if (subtitle != null) ...[
                const SizedBox(height: 2),
                Text(subtitle!, style: bodyStyle(fontSize: 8, color: textMid)),
              ],
            ],
          ),
        ),
        Switch(value: value, activeTrackColor: primary, activeThumbColor: Colors.white, onChanged: onChanged),
      ],
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Container(height: 1, color: const Color(0xff808080).withValues(alpha: 0.3)),
    );
  }
}
