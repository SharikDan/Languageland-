import 'package:flutter/material.dart';
import 'package:ayas_languageland/logic/services/app_state.dart';
import 'package:ayas_languageland/logic/services/app_localizations.dart';
import 'package:ayas_languageland/logic/services/audio_service.dart';
import 'package:ayas_languageland/logic/services/tts_service.dart';

// Ð­ÐºÑ€Ð°Ð½ Ð½Ð°ÑÑ‚Ñ€Ð¾ÐµÐº / Settings screen
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    const accent = Color(0xFFE91E63);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    final bgColor = isDark ? const Color(0xFF0F0F17) : const Color(0xFFFFF5F8);
    final cardColor = isDark ? const Color(0xFF1C1C28) : Colors.white;
    final textColor = isDark ? const Color(0xFFEDEDF2) : const Color(0xFF2C2C2C);
    final subTextColor = isDark ? const Color(0xFFA0A0B0) : Colors.grey.shade600;

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Ð—Ð°Ð³Ð¾Ð»Ð¾Ð²Ð¾Ðº / Header
              Row(
                children: [
                  const Icon(Icons.settings, color: accent, size: 32),
                  const SizedBox(width: 12),
                  Text(AppLoc.t('settings_title'), style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: textColor)),
                ],
              ),
              const SizedBox(height: 32),

              // Ð’Ð½ÐµÑˆÐ½Ð¸Ð¹ Ð²Ð¸Ð´ / Appearance
              _SectionTitle(title: AppLoc.t('appearance'), textColor: subTextColor),
              _SettingCard(
                cardColor: cardColor,
                child: Column(
                  children: [
                    // Ð¢Ñ‘Ð¼Ð½Ð°Ñ Ñ‚ÐµÐ¼Ð° / Dark theme
                    SwitchListTile(
                      title: Text(AppLoc.t('dark_theme'), style: TextStyle(color: textColor, fontWeight: FontWeight.bold)),
                      subtitle: Text(AppLoc.t('dark_theme_sub'), style: TextStyle(color: subTextColor, fontSize: 12)),
                      secondary: Icon(Icons.dark_mode, color: isDark ? accent : Colors.grey),
                      activeColor: Colors.white,
                      activeTrackColor: accent,
                      value: AppState.isDarkMode,
                      onChanged: (value) {
                        AudioService.playSound('tap.mp3');
                        setState(() => AppState.toggleTheme());
                      },
                    ),
                    Divider(color: isDark ? Colors.grey.shade800 : Colors.grey.shade200, height: 1),
                    // Ð’Ñ‹Ð±Ð¾Ñ€ ÑÐ·Ñ‹ÐºÐ° / Language dropdown
                    ListTile(
                      leading: Icon(Icons.language, color: accent),
                      title: Text(AppLoc.t('language'), style: TextStyle(color: textColor, fontWeight: FontWeight.bold)),
                      trailing: DropdownButton<String>(
                        value: AppState.languageCode,
                        underline: const SizedBox(),
                        icon: Icon(Icons.arrow_drop_down, color: accent),
                        dropdownColor: cardColor,
                        onChanged: (String? newValue) {
                          if (newValue != null) {
                            AudioService.playSound('tap.mp3');
                            setState(() {
                              AppState.setLanguage(newValue);
                            });
                          }
                        },
                        items: [
                          DropdownMenuItem(value: 'ru', child: Text(AppLoc.t('russian'), style: TextStyle(color: textColor))),
                          DropdownMenuItem(value: 'en', child: Text(AppLoc.t('english'), style: TextStyle(color: textColor))),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Ð—Ð²ÑƒÐº / Sound & TTS
              _SectionTitle(title: AppLoc.t('sound_tts'), textColor: subTextColor),
              _SettingCard(
                cardColor: cardColor,
                child: Column(
                  children: [
                    SwitchListTile(
                      title: Text(AppLoc.t('sound_fx'), style: TextStyle(color: textColor, fontWeight: FontWeight.bold)),
                      subtitle: Text(AppLoc.t('sound_fx_sub'), style: TextStyle(color: subTextColor, fontSize: 12)),
                      secondary: Icon(Icons.volume_up, color: AppState.isSoundEnabled ? accent : Colors.grey),
                      activeColor: Colors.white,
                      activeTrackColor: accent,
                      value: AppState.isSoundEnabled,
                      onChanged: (value) {
                        setState(() {
                          AppState.isSoundEnabled = value;
                          AppState.save();
                          if (AudioService.isSoundEnabled != value) AudioService.toggleSound();
                        });
                      },
                    ),
                    Divider(color: isDark ? Colors.grey.shade800 : Colors.grey.shade200, height: 1),
                    SwitchListTile(
                      title: Text(AppLoc.t('bg_music'), style: TextStyle(color: textColor, fontWeight: FontWeight.bold)),
                      subtitle: Text(AppLoc.t('bg_music_sub'), style: TextStyle(color: subTextColor, fontSize: 12)),
                      secondary: Icon(Icons.music_note, color: AppState.isMusicEnabled ? accent : Colors.grey),
                      activeColor: Colors.white,
                      activeTrackColor: accent,
                      value: AppState.isMusicEnabled,
                      onChanged: (value) {
                        setState(() {
                          AppState.isMusicEnabled = value;
                          AppState.save();
                          if (AudioService.isMusicEnabled != value) AudioService.toggleMusic();
                        });
                      },
                    ),
                    Divider(color: isDark ? Colors.grey.shade800 : Colors.grey.shade200, height: 1),
                    SwitchListTile(
                      title: Text(AppLoc.t('tts_voice'), style: TextStyle(color: textColor, fontWeight: FontWeight.bold)),
                      subtitle: Text(AppLoc.t('tts_voice_sub'), style: TextStyle(color: subTextColor, fontSize: 12)),
                      secondary: Icon(Icons.record_voice_over, color: AppState.isTTSEnabled ? accent : Colors.grey),
                      activeColor: Colors.white,
                      activeTrackColor: accent,
                      value: AppState.isTTSEnabled,
                      onChanged: (value) {
                        setState(() {
                          AppState.isTTSEnabled = value;
                          AppState.save();
                          TtsService.instance.setEnabled(value);
                        });
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Ð”Ð°Ð½Ð½Ñ‹Ðµ / Data
              _SectionTitle(title: AppLoc.t('data'), textColor: subTextColor),
              _SettingCard(
                cardColor: cardColor,
                child: ListTile(
                  leading: const Icon(Icons.delete_forever, color: Colors.red),
                  title: Text(AppLoc.t('reset'), style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                  subtitle: Text(AppLoc.t('reset_sub'), style: TextStyle(color: subTextColor, fontSize: 12)),
                  trailing: const Icon(Icons.chevron_right, color: Colors.red),
                  onTap: () => _showResetDialog(context),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Ð”Ð¸Ð°Ð»Ð¾Ð³ ÑÐ±Ñ€Ð¾ÑÐ° / Reset dialog
  void _showResetDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Theme.of(context).cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Text('Ð’Ñ‹ ÑƒÐ²ÐµÑ€ÐµÐ½Ñ‹?', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold)),
        content: const Text('Ð’ÐµÑÑŒ Ð¿Ñ€Ð¾Ð³Ñ€ÐµÑÑ Ð±ÑƒÐ´ÐµÑ‚ ÑƒÐ´Ð°Ð»ÐµÐ½.', textAlign: TextAlign.center),
        actions: [
          Row(
            children: [
              Expanded(child: TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('ÐžÑ‚Ð¼ÐµÐ½Ð°'))),
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
                  onPressed: () async {
                    Navigator.pop(ctx);
                    await AppState.resetProgress();
                  },
                  child: const Text('Ð£Ð´Ð°Ð»Ð¸Ñ‚ÑŒ'),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  final Color textColor;
  const _SectionTitle({required this.title, required this.textColor});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, left: 8),
      child: Text(title.toUpperCase(), style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1.2, color: textColor)),
    );
  }
}

class _SettingCard extends StatelessWidget {
  final Widget child;
  final Color cardColor;
  const _SettingCard({required this.child, required this.cardColor});
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Material(color: cardColor, borderRadius: BorderRadius.circular(16), clipBehavior: Clip.antiAlias, child: child),
    );
  }
}