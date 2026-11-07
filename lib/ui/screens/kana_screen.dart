import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ayas_languageland/logic/bloc/kana/kana_bloc.dart';
import 'package:ayas_languageland/logic/bloc/kana/kana_event.dart';
import 'package:ayas_languageland/logic/bloc/kana/kana_state.dart';
import 'package:ayas_languageland/widgets/aya_image.dart';
import 'package:ayas_languageland/widgets/level_up_dialog.dart';
import 'package:ayas_languageland/widgets/achievement_dialog.dart';
import 'package:ayas_languageland/logic/services/app_state.dart';
import 'package:ayas_languageland/logic/services/app_localizations.dart';
import 'package:ayas_languageland/logic/services/notification_service.dart';
import 'package:ayas_languageland/logic/services/audio_service.dart';
import 'package:ayas_languageland/data/kana_tips.dart';

// Ð­ÐºÑ€Ð°Ð½ Ð¸Ð·ÑƒÑ‡ÐµÐ½Ð¸Ñ ÐšÐ°Ð½Ñ‹ / Kana learning screen
class KanaScreen extends StatelessWidget {
  final String initialMode;
  const KanaScreen({Key? key, this.initialMode = 'hiragana'}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      key: ValueKey(AppLoc.lang.value), // Ð¡Ð±Ñ€Ð¾Ñ Ð¿Ñ€Ð¸ ÑÐ¼ÐµÐ½Ðµ ÑÐ·Ñ‹ÐºÐ° / Reset on lang change
      create: (context) => KanaBloc()..add(KanaInitEvent(mode: initialMode)),
      child: BlocListener<KanaBloc, KanaState>(
        listener: (context, state) {
          if (state is KanaCorrect) {
            AudioService.playSound('correct.mp3');
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (AppState.pendingLevelUp != null) {
                final lvl = AppState.pendingLevelUp!;
                AppState.pendingLevelUp = null;
                showDialog(context: context, builder: (_) => LevelUpDialog(level: lvl));
              }
              if (AppState.pendingAchievement != null) {
                AudioService.playSound('achievement.mp3');
                final ach = AppState.pendingAchievement!;
                AppState.pendingAchievement = null;
                NotificationService.instance.showAchievementUnlocked(ach.title);
                showDialog(context: context, builder: (_) => AchievementDialog(achievement: ach));
              }
            });
          } else if (state is KanaWrong) {
            AudioService.playSound('wrong.mp3');
          }
        },
        child: ValueListenableBuilder<String>(
          valueListenable: AppLoc.lang,
          builder: (context, langCode, child) {
            return BlocBuilder<KanaBloc, KanaState>(
              builder: (context, state) {
                if (state is KanaInitial) return const Scaffold(backgroundColor: Color(0xFFFFF5F8), body: Center(child: CircularProgressIndicator(color: Color(0xFFE91E63))));
                if (state is KanaPractice) return _buildPractice(context, state);
                if (state is KanaCorrect) return _buildResult(context, isCorrect: true, char: state.currentChar.char, romaji: state.correctRomaji, correctRomaji: state.correctRomaji);
                if (state is KanaWrong) return _buildResult(context, isCorrect: false, char: state.currentChar.char, romaji: state.correctRomaji, selected: state.selectedRomaji, correctRomaji: state.correctRomaji);
                if (state is KanaResults) return _buildResults(context, state);
                return const Scaffold(body: Center(child: Text('Unknown state')));
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildPractice(BuildContext context, KanaPractice state) {
    const accentColor = Color(0xFFE91E63);
    const bgColor = Color(0xFFFFF5F8);
    const surfaceColor = Colors.white;
    const textColor = Colors.black87;

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                flex: 5,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(32),
                      decoration: BoxDecoration(
                        color: surfaceColor,
                        border: Border.all(color: accentColor, width: 3),
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [BoxShadow(color: accentColor.withValues(alpha: 0.1), blurRadius: 20)],
                      ),
                      child: Text(state.currentChar.char, style: const TextStyle(fontSize: 120, fontWeight: FontWeight.bold, color: textColor)),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.volume_up_rounded, size: 40, color: accentColor),
                          onPressed: () => context.read<KanaBloc>().add(KanaPlaySoundEvent()),
                        ),
                        const SizedBox(width: 16),
                        IconButton(
                          icon: const Icon(Icons.lightbulb_outline, size: 36, color: Colors.amber),
                          onPressed: () {
                            AudioService.playSound('tap.mp3');
                            final hint = KanaTips.getHint(state.currentChar.char, state.currentChar.romaji);
                            showDialog(
                              context: context,
                              builder: (ctx) => AlertDialog(
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                title: const Row(children: [Icon(Icons.smart_toy, color: accentColor), SizedBox(width: 8), Text('ÐÑ Ð¿Ð¾Ð´ÑÐºÐ°Ð·Ñ‹Ð²Ð°ÐµÑ‚')]),
                                content: Text(hint, style: const TextStyle(fontSize: 16)),
                                actions: [TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('ÐŸÐ¾Ð½ÑÑ‚Ð½Ð¾', style: TextStyle(color: accentColor, fontWeight: FontWeight.bold)))],
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                flex: 5,
                child: Column(
                  children: [
                    Text('${AppLoc.t('kana_question')} ${state.currentIndex + 1} ${AppLoc.t('kana_of')} ${state.totalCount}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: textColor)),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: LinearProgressIndicator(value: (state.currentIndex + 1) / state.totalCount, minHeight: 8, backgroundColor: Colors.grey.shade300, color: accentColor),
                    ),
                    const SizedBox(height: 24),
                    Expanded(
                      child: GridView.count(
                        crossAxisCount: 2, mainAxisSpacing: 12, crossAxisSpacing: 12, childAspectRatio: 1.5,
                        children: state.options.map((option) {
                          final isSelected = state.selectedRomaji == option;
                          return GestureDetector(
                            onTap: () {
                              AudioService.playSound('tap.mp3');
                              context.read<KanaBloc>().add(KanaSelectEvent(selectedRomaji: option));
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              decoration: BoxDecoration(
                                color: isSelected ? accentColor : surfaceColor,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: isSelected ? accentColor : Colors.grey.shade300, width: 2),
                                boxShadow: isSelected ? [BoxShadow(color: accentColor.withValues(alpha: 0.3), blurRadius: 10)] : [],
                              ),
                              alignment: Alignment.center,
                              child: Text(option, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: isSelected ? Colors.white : textColor)),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity, height: 56,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: state.selectedRomaji != null ? accentColor : Colors.grey.shade300,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        ),
                        onPressed: state.selectedRomaji != null ? () {
                          AudioService.playSound('tap.mp3');
                          context.read<KanaBloc>().add(const KanaCheckEvent());
                        } : null,
                        child: Text(AppLoc.t('kana_check'), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                flex: 3,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(color: Colors.green.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
                      child: Text('${AppLoc.t('kana_correct')}: ${state.correctCount}', style: const TextStyle(color: Colors.green, fontSize: 18, fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(color: Colors.red.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
                      child: Text('${AppLoc.t('kana_wrong')}: ${state.wrongCount}', style: const TextStyle(color: Colors.red, fontSize: 18, fontWeight: FontWeight.bold)),
                    ),
                    const Spacer(),
                    const AyaImage(emotion: 'neutral', size: 160),
                    const Spacer(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResult(BuildContext context, {required bool isCorrect, required String char, required String romaji, String? selected, required String correctRomaji}) {
    const accentColor = Color(0xFFE91E63);
    final tip = KanaTips.getSmartTip(char, correctRomaji, selected);

    return Scaffold(
      backgroundColor: const Color(0xFFFFF5F8),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(isCorrect ? Icons.check_circle : Icons.cancel, color: isCorrect ? Colors.green : Colors.red, size: 80),
              const SizedBox(height: 24),
              Text(isCorrect ? AppLoc.t('kana_correct') : AppLoc.t('kana_wrong'), style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: isCorrect ? Colors.green : Colors.red)),
              const SizedBox(height: 16),
              Text('${AppLoc.t('kana_char')}: $char', style: const TextStyle(fontSize: 28, color: Colors.black87)),
              if (!isCorrect) ...[
                const SizedBox(height: 8),
                Text('${AppLoc.t('kana_your_answer')}: $selected', style: const TextStyle(fontSize: 22, color: Colors.red, decoration: TextDecoration.lineThrough)),
              ],
              const SizedBox(height: 8),
              Text('${AppLoc.t('kana_correct_answer')}: $romaji', style: const TextStyle(fontSize: 22, color: Colors.green, fontWeight: FontWeight.bold)),
              const SizedBox(height: 32),
              if (!isCorrect)
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white, borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: accentColor.withValues(alpha: 0.3), width: 2),
                    boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 4))],
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 60, height: 60,
                        decoration: BoxDecoration(color: accentColor.withValues(alpha: 0.1), shape: BoxShape.circle),
                        child: const Icon(Icons.smart_toy, color: accentColor, size: 32),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('ÐžÐ±ÑŠÑÑÐ½ÐµÐ½Ð¸Ðµ Ð¾Ñ‚ ÐÐ¸:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black87)),
                            const SizedBox(height: 4),
                            Text(tip, style: const TextStyle(fontSize: 15, color: Colors.black54, height: 1.4)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 48),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: isCorrect ? Colors.green : accentColor,
                  padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 20),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
                ),
                onPressed: () => context.read<KanaBloc>().add(const KanaNextEvent()),
                child: Text(AppLoc.t('kana_next'), style: const TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResults(BuildContext context, KanaResults state) {
    const accentColor = Color(0xFFE91E63);
    return Scaffold(
      backgroundColor: const Color(0xFFFFF5F8),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(AppLoc.t('kana_finished'), style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: Colors.black87)),
            const SizedBox(height: 24),
            Text('${AppLoc.t('kana_correct')}: ${state.correctCount}', style: const TextStyle(fontSize: 28, color: Colors.green, fontWeight: FontWeight.bold)),
            Text('${AppLoc.t('kana_wrong')}: ${state.wrongCount}', style: const TextStyle(fontSize: 28, color: Colors.red, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Text('${AppLoc.t('kana_accuracy')}: ${state.accuracy.toStringAsFixed(1)}%', style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: accentColor)),
            const SizedBox(height: 48),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: accentColor, padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 20), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999))),
              onPressed: () => context.read<KanaBloc>().add(const KanaRetryEvent()),
              child: Text(AppLoc.t('kana_retry'), style: const TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}