// Экран настроек: тема, звук, TTS, сброс прогресса
import 'package:flutter/material.dart';
import '../services/app_state.dart';
import '../services/audio_service.dart';
import '../services/tts_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 24),
            _buildThemeSection(),
            const SizedBox(height: 24),
            _buildAudioSection(),
            const SizedBox(height: 24),
            _buildDangerZone(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Text(
      'Настройки',
      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
    );
  }

  Widget _buildThemeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Внешний вид',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 12),
        _buildSettingTile(
          title: 'Тёмная тема',
          subtitle: 'Использовать тёмное оформление',
          icon: Icons.dark_mode,
          trailing: Switch(
            value: AppState.isDarkMode,
            onChanged: (value) {
              setState(() {
                AppState.toggleTheme();
              });
            },
          ),
        ),
      ],
    );
  }

  Widget _buildAudioSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Аудио',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 12),
        _buildSettingTile(
          title: 'Фоновая музыка',
          subtitle: 'Проигрывать музыку в фоне',
          icon: Icons.music_note,
          trailing: Switch(
            value: AppState.isMusicEnabled,
            onChanged: (value) {
              setState(() {
                AppState.isMusicEnabled = value;
                AppState.save();
                AudioService.instance.setMusicEnabled(value);
              });
            },
          ),
        ),
        const SizedBox(height: 8),
        _buildSettingTile(
          title: 'Звуковые эффекты',
          subtitle: 'UI-звуки при нажатиях',
          icon: Icons.volume_up,
          trailing: Switch(
            value: AppState.isSoundEnabled,
            onChanged: (value) {
              setState(() {
                AppState.isSoundEnabled = value;
                AppState.save();
                AudioService.instance.setSoundEnabled(value);
              });
            },
          ),
        ),
        const SizedBox(height: 8),
        _buildSettingTile(
          title: 'Озвучка (TTS)',
          subtitle: 'Произношение японских слов',
          icon: Icons.record_voice_over,
          trailing: Switch(
            value: AppState.isTTSEnabled,
            onChanged: (value) {
              setState(() {
                AppState.isTTSEnabled = value;
                AppState.save();
                TtsService.instance.setEnabled(value);
              });
            },
          ),
        ),
      ],
    );
  }

  Widget _buildDangerZone() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Опасная зона',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.error,
              ),
        ),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context)
                .colorScheme
                .errorContainer
                .withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color:
                  Theme.of(context).colorScheme.error.withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.warning,
                    color: Theme.of(context).colorScheme.error,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Сброс прогресса',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Удалит весь ваш прогресс: уровень, XP, стрик, карточки, квесты и достижения. Это действие нельзя отменить!',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: _showResetDialog,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Theme.of(context).colorScheme.error,
                    side: BorderSide(
                      color: Theme.of(context).colorScheme.error,
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                  child: const Text('Сбросить весь прогресс'),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSettingTile({
    required String title,
    required String subtitle,
    required IconData icon,
    required Widget trailing,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withValues(alpha: 0.7),
                      ),
                ),
              ],
            ),
          ),
          trailing,
        ],
      ),
    );
  }

  void _showResetDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Подтверждение'),
          content: const Text(
            'Вы уверены, что хотите сбросить весь прогресс? Это действие нельзя отменить!',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Отмена'),
            ),
            TextButton(
              onPressed: () {
                AppState.resetProgress();
                Navigator.of(context).pop();
                setState(() {});
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Прогресс сброшен')),
                );
              },
              style: TextButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.error,
              ),
              child: const Text('Сбросить'),
            ),
          ],
        );
      },
    );
  }
}