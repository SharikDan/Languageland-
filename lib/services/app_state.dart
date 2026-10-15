// Глобальный стейт приложения (XP, стрики, SRS, квесты, ачивки)
import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/card_progress.dart';
import '../models/quest_def.dart';
import '../models/achievement.dart';
import '../data/achievements_data.dart';
import '../data/quests_data.dart';

class AppState {
  AppState._();

  static int xp = 0;
  static int get level => ((xp ~/ 100) + 1).clamp(1, 999).toInt();
  static int lastLoginMs = 0;

  static Map<String, CardProgress> cards = {};
  static Map<String, QuestDef> quests = {};
  static List<Achievement> achievements = [];
  static Set<String> unlockedAchievements = {};

  static bool isDarkMode = false;
  static bool isMusicEnabled = true;
  static bool isSoundEnabled = true;
  static bool isTTSEnabled = true;
  static bool hasCompletedOnboarding = false;

  static final themeNotifier = ValueNotifier<bool>(false);

  // Очередь для показа диалогов
  static int? pendingLevelUp;
  static Achievement? pendingAchievement;

  static Timer? _saveTimer;
  static SharedPreferences? _prefs;

  static int get currentStreak {
    if (lastLoginMs == 0) return 0;
    final now = DateTime.now();
    final lastLogin = DateTime.fromMillisecondsSinceEpoch(lastLoginMs);
    final difference = now.difference(lastLogin).inDays;
    if (difference == 0) {
      return _prefs?.getInt('streak') ?? 1;
    } else if (difference == 1) {
      return (_prefs?.getInt('streak') ?? 0) + 1;
    } else {
      return 0;
    }
  }

  static Future<void> load() async {
    try {
      _prefs = await SharedPreferences.getInstance();

      xp = _prefs?.getInt('xp') ?? 0;
      lastLoginMs = _prefs?.getInt('lastLoginMs') ?? 0;
      isDarkMode = _prefs?.getBool('isDarkMode') ?? false;
      isMusicEnabled = _prefs?.getBool('isMusicEnabled') ?? true;
      isSoundEnabled = _prefs?.getBool('isSoundEnabled') ?? true;
      isTTSEnabled = _prefs?.getBool('isTTSEnabled') ?? true;
      hasCompletedOnboarding =
          _prefs?.getBool('hasCompletedOnboarding') ?? false;

      themeNotifier.value = isDarkMode;

      final cardsJson = _prefs?.getString('cards') ?? '{}';
      final cardsMap = jsonDecode(cardsJson) as Map<String, dynamic>;
      cards = cardsMap.map(
        (key, value) => MapEntry(
          key,
          CardProgress.fromJson(value as Map<String, dynamic>),
        ),
      );

      final questsJson = _prefs?.getString('quests') ?? '{}';
      final questsMap = jsonDecode(questsJson) as Map<String, dynamic>;
      quests = {};
      for (final questData in questsData) {
        if (questsMap.containsKey(questData.id)) {
          quests[questData.id] = QuestDef.fromJson(
            questsMap[questData.id] as Map<String, dynamic>,
          );
        } else {
          quests[questData.id] = questData;
        }
      }

      final achievementsJson = _prefs?.getString('achievements') ?? '[]';
      final achievementsList = jsonDecode(achievementsJson) as List<dynamic>;
      unlockedAchievements = achievementsList.cast<String>().toSet();

      achievements = achievementsData.map((ach) {
        if (unlockedAchievements.contains(ach.id)) {
          return Achievement(
            id: ach.id,
            title: ach.title,
            description: ach.description,
            iconName: ach.iconName,
            isUnlocked: true,
          );
        }
        return ach;
      }).toList();

      _updateLoginStreak();
    } catch (e) {
      debugPrint('AppState.load error: $e');
      _initializeDefaults();
    }
  }

  static void _initializeDefaults() {
    xp = 0;
    lastLoginMs = DateTime.now().millisecondsSinceEpoch;
    cards = {};
    quests = {};
    for (final quest in questsData) {
      quests[quest.id] = quest;
    }
    achievements = List.from(achievementsData);
    unlockedAchievements = {};
    isDarkMode = false;
    isMusicEnabled = true;
    isSoundEnabled = true;
    isTTSEnabled = true;
    hasCompletedOnboarding = false;
    themeNotifier.value = false;
  }

  static Future<void> save() async {
    if (_prefs == null) return;

    try {
      await _prefs?.setInt('xp', xp.clamp(0, 2147483647).toInt());
      await _prefs?.setInt('lastLoginMs', lastLoginMs);
      await _prefs?.setBool('isDarkMode', isDarkMode);
      await _prefs?.setBool('isMusicEnabled', isMusicEnabled);
      await _prefs?.setBool('isSoundEnabled', isSoundEnabled);
      await _prefs?.setBool('isTTSEnabled', isTTSEnabled);
      await _prefs?.setBool('hasCompletedOnboarding', hasCompletedOnboarding);

      final cardsMap = cards.map((key, value) => MapEntry(key, value.toJson()));
      await _prefs?.setString('cards', jsonEncode(cardsMap));

      final questsMap =
          quests.map((key, value) => MapEntry(key, value.toJson()));
      await _prefs?.setString('quests', jsonEncode(questsMap));

      final unlockedIds = achievements
          .where((ach) => ach.isUnlocked)
          .map((ach) => ach.id)
          .toList();
      await _prefs?.setString('achievements', jsonEncode(unlockedIds));
    } catch (e) {
      debugPrint('AppState.save error: $e');
    }
  }

  static void _debouncedSave() {
    _saveTimer?.cancel();
    _saveTimer = Timer(const Duration(seconds: 1), () => save());
  }

  static void _updateLoginStreak() {
    final now = DateTime.now();
    final lastLogin = DateTime.fromMillisecondsSinceEpoch(lastLoginMs);
    final difference = now.difference(lastLogin).inDays;

    if (difference == 1) {
      final currentStreakValue = _prefs?.getInt('streak') ?? 0;
      _prefs?.setInt('streak', currentStreakValue + 1);
    } else if (difference > 1) {
      _prefs?.setInt('streak', 1);
    }

    lastLoginMs = now.millisecondsSinceEpoch;
    _debouncedSave();
  }

  static void addXP(int amount) {
    final oldLevel = level;
    xp = (xp + amount).clamp(0, 2147483647).toInt();
    final newLevel = level;

    if (newLevel > oldLevel) {
      _checkLevelAchievements(newLevel);
      pendingLevelUp = newLevel;
    }

    _debouncedSave();
  }

  static void recordAnswer(String cardId, bool correct) {
    if (!cards.containsKey(cardId)) {
      cards[cardId] = CardProgress(cardId: cardId);
    }

    final card = cards[cardId]!;
    if (correct) {
      card.recordCorrect();
      addXP(10);
    } else {
      card.recordIncorrect();
    }

    _checkQuestProgress(cardId, correct);
    _debouncedSave();
  }

  static void _checkQuestProgress(String cardId, bool correct) {
    if (!correct) return;
    final type = typeFromCardId(cardId);

    if (type == 'hiragana') {
      final learned = cards.keys
          .where((k) => k.startsWith('hiragana_'))
          .where((k) => cards[k]!.box >= 2)
          .length;
      _setQuestCount('complete_hiragana', learned);
    } else if (type == 'katakana') {
      final learned = cards.keys
          .where((k) => k.startsWith('katakana_'))
          .where((k) => cards[k]!.box >= 2)
          .length;
      _setQuestCount('complete_katakana', learned);
    } else if (type == 'kanji') {
      final learned = cards.keys
          .where((k) => k.startsWith('kanji_'))
          .where((k) => cards[k]!.box >= 2)
          .length;
      _setQuestCount('learn_10_kanji', learned);
      _setQuestCount('learn_50_kanji', learned);
    } else if (type == 'vocab') {
      final learned = cards.keys
          .where((k) => k.startsWith('vocab_'))
          .where((k) => cards[k]!.box >= 2)
          .length;
      _setQuestCount('learn_20_words', learned);
      _setQuestCount('learn_all_words', learned);
    }

    _setQuestCount('reach_level_10', xp);
  }

  static void _setQuestCount(String questId, int count) {
    if (!quests.containsKey(questId)) return;
    final q = quests[questId]!;
    if (q.isCompleted) return;
    final old = q.currentCount;
    q.currentCount = count.clamp(0, q.targetCount).toInt();
    if (!q.isCompleted && q.currentCount >= q.targetCount) {
      addXP(q.reward);
    }
    if (old != q.currentCount) _debouncedSave();
  }

  static List<String> getDueCardIds() {
    final now = DateTime.now().millisecondsSinceEpoch;
    return cards.entries
        .where((entry) => entry.value.nextReviewMs <= now)
        .map((entry) => entry.key)
        .toList();
  }

  static void updateQuestProgress(String questId, int amount) {
    if (!quests.containsKey(questId)) return;
    final quest = quests[questId]!;
    if (quest.isCompleted) return;

    quest.currentCount =
        (quest.currentCount + amount).clamp(0, quest.targetCount).toInt();

    if (quest.isCompleted) {
      addXP(quest.reward);
    }

    _debouncedSave();
  }

  static void unlockAchievement(String achievementId) {
    if (unlockedAchievements.contains(achievementId)) return;

    final index = achievements.indexWhere((ach) => ach.id == achievementId);
    if (index == -1) return;

    if (!achievements[index].isUnlocked) {
      achievements[index].isUnlocked = true;
      unlockedAchievements.add(achievementId);
      pendingAchievement = achievements[index];
      addXP(50);
      _debouncedSave();
    }
  }

  static void _checkLevelAchievements(int newLevel) {
    if (newLevel >= 5) unlockAchievement('level_5');
    if (newLevel >= 10) unlockAchievement('level_10');
  }

  static void toggleTheme() {
    isDarkMode = !isDarkMode;
    themeNotifier.value = isDarkMode;
    _debouncedSave();
  }

  static Future<void> resetProgress() async {
    xp = 0;
    lastLoginMs = DateTime.now().millisecondsSinceEpoch;
    cards.clear();
    quests.clear();
    for (final quest in questsData) {
      quests[quest.id] = quest;
    }
    achievements = List.from(achievementsData);
    unlockedAchievements.clear();
    _prefs?.setInt('streak', 0);
    await save();
  }

  static String cardId(String type, String char) {
    return '${type}_$char';
  }

  static String charFromCardId(String cardId) {
    final parts = cardId.split('_');
    return parts.sublist(1).join('_');
  }

  static String typeFromCardId(String cardId) {
    return cardId.split('_').first;
  }
}