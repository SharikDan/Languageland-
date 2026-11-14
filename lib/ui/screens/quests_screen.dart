import 'package:flutter/material.dart';
import 'package:ayas_languageland/data/quests_data.dart';
import 'package:ayas_languageland/logic/services/app_state.dart';
import 'package:ayas_languageland/logic/services/app_localizations.dart';
import 'package:ayas_languageland/models/quest_def.dart';

// Ð­ÐºÑ€Ð°Ð½ ÐºÐ²ÐµÑÑ‚Ð¾Ð² / Quests screen
class QuestsScreen extends StatelessWidget {
  const QuestsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const accent = Color(0xFFE91E63);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF0F0F17) : const Color(0xFFFFF5F8);
    final cardColor = isDark ? const Color(0xFF1C1C28) : Colors.white;
    final textColor = isDark ? const Color(0xFFEDEDF2) : const Color(0xFF2C2C2C);
    final subTextColor = isDark ? const Color(0xFFA0A0B0) : Colors.grey.shade600;

    int getProgressForQuest(String id) {
      switch (id) {
        case 'reach_level_10': return AppState.level;
        case 'learn_10_kanji': return 3;
        case 'learn_20_words': return AppState.learnedWords.length;
        case 'daily_practice_7': return AppState.currentStreak;
        default: return 0;
      }
    }

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(32, 24, 32, 16),
              child: Row(
                children: [
                  const Icon(Icons.assignment, color: accent, size: 32),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(AppLoc.t('quests_title'), style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: textColor)),
                      Text(AppLoc.t('quests_sub'), style: TextStyle(fontSize: 14, color: subTextColor)),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.fromLTRB(32, 8, 32, 32),
                itemCount: questsData.length,
                itemBuilder: (context, index) {
                  final quest = questsData[index];
                  final isEn = AppLoc.lang.value == 'en';
                  final title = isEn ? quest.titleEn : quest.title;
                  final desc = isEn ? quest.descriptionEn : quest.description;
                  final isClaimed = AppState.claimedQuests.contains(quest.id);
                  final currentProgress = getProgressForQuest(quest.id);
                  final isCompleted = currentProgress >= quest.targetCount;
                  
                  // Ð’Ñ‹Ð±Ð¸Ñ€Ð°ÐµÐ¼ ÑÐ·Ñ‹Ðº Ð´Ð»Ñ ÐºÐ²ÐµÑÑ‚Ð° / Choose language for quest
                  final isEn = AppLoc.lang.value == 'en';
                  final title = isEn ? quest.titleEn : quest.title;
                  final desc = isEn ? quest.descriptionEn : quest.description;

                  return _QuestCard(
                    title: title,
                    description: desc,
                    quest: quest,
                    currentProgress: currentProgress.clamp(0, quest.targetCount),
                    isCompleted: isCompleted,
                    cardColor: cardColor,
                    textColor: textColor,
                    subTextColor: subTextColor,
                    accent: accent,
                    isDark: isDark,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuestCard extends StatelessWidget {
  final String title;
  final String description;
  final QuestDef quest;
  final bool isClaimed;
  final int currentProgress;
  final bool isCompleted;
  final Color cardColor;
  final Color textColor;
  final Color subTextColor;
  final Color accent;
  final bool isDark;

  const _QuestCard({
    required this.title,
    required this.description,
    required this.quest, required this.isClaimed,
    required this.currentProgress,
    required this.isCompleted,
    required this.cardColor,
    required this.textColor,
    required this.subTextColor,
    required this.accent,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final progressPercent = currentProgress / quest.targetCount;
    final completeColor = Colors.green;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        border: isCompleted ? Border.all(color: completeColor, width: 2) : null,
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Row(
        children: [
          Container(
            width: 56, height: 56,
            decoration: BoxDecoration(color: isCompleted ? completeColor.withValues(alpha: 0.1) : accent.withValues(alpha: 0.1), shape: BoxShape.circle),
            child: Icon(isCompleted ? Icons.check_circle : Icons.flag, color: isCompleted ? completeColor : accent, size: 28),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textColor)),
                    if (isClaimed)
                      const Icon(Icons.check_circle, color: Colors.green, size: 28)
                    else if (isCompleted)
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.amber,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          minimumSize: Size.zero,
                        ),
                        onPressed: () {
                          AppState.claimQuest(quest.id, quest.reward);
                          setState(() {}); // Обновить UI
                        },
                        child: Text('+${quest.reward} XP', style: const TextStyle(fontWeight: FontWeight.bold)),
                      )
                    else
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(color: Colors.amber.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(999)),
                        child: Row(
                          children: [
                            const Icon(Icons.bolt, color: Colors.amber, size: 16),
                            const SizedBox(width: 4),
                            Text('+${quest.reward} XP', style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.bold, fontSize: 12)),
                          ],
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(description, style: TextStyle(fontSize: 14, color: subTextColor)),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(999),
                        child: LinearProgressIndicator(
                          value: progressPercent, minHeight: 10,
                          backgroundColor: isDark ? const Color(0xFF23232F) : Colors.grey.shade200,
                          color: isCompleted ? completeColor : accent,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text('$currentProgress / ${quest.targetCount}', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: isCompleted ? completeColor : subTextColor)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}