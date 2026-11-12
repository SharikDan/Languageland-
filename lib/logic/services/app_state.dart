import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ayas_languageland/models/achievement.dart';
import 'package:ayas_languageland/models/card_progress.dart';
import 'package:ayas_languageland/logic/services/app_localizations.dart';

class AppState {
  AppState._();

  // === ДАННЫЕ ===
  static int xp = 0;
  static int get level => ((xp ~/ 100) + 1).clamp(1, 999).toInt();
  static int currentStreak = 0;
  static Map<String, CardProgress> cards = {};
  static Set<String> learnedWords = {};
  static List<Achievement> achievements = [];
  static Set<String> unlockedAchievements = {};
  static bool isDarkMode = false;
  static String languageCode = 'en';
  static bool isSoundEnabled = true;
  static bool isMusicEnabled = true;
  static bool isTTSEnabled = true;
  static String userName = '';
  static String userAvatar = 'joy';
  static int? pendingLevelUp;
  static Achievement? pendingAchievement;
  static final ValueNotifier<bool> themeNotifier = ValueNotifier<bool>(false);

  // === ОЧЕРЕДЬ СОХРАНЕНИЯ (фикс race condition) ===
  static Timer? _saveDebounce;
  static bool _isSaving = false;
  static bool _needsResave = false;

  /// Планирует сохранение с задержкой 200 мс.
  /// Батчит несколько быстрых вызовов (например, 5 правильных ответов в Кане).
  static void _scheduleSave() {
    _saveDebounce?.cancel();
    _saveDebounce = Timer(const Duration(milliseconds: 200), () {
      save().catchError((e) => debugPrint('⚠️ AppState.save failed: $e'));
    });
  }

  /// Атомарное сохранение с очередью. Не даёт двум save() работать одновременно.
  static Future<void> save() async {
    if (_isSaving) {
      _needsResave = true;
      return;
    }
    _isSaving = true;
    try {
      do {
        _needsResave = false;
        final prefs = await SharedPreferences.getInstance();
        await prefs.setInt('xp', xp);
        await prefs.setInt('streak', currentStreak);
        await prefs.setBool('isDarkMode', isDarkMode);
        await prefs.setString('languageCode', languageCode);
        await prefs.setString('userName', userName);
        await prefs.setString('userAvatar', userAvatar);
        await prefs.setString('cards', jsonEncode(cards.map((k, v) => MapEntry(k, v.toJson()))));
        await prefs.setStringList('learnedWords', learnedWords.toList());
        await prefs.setStringList('unlockedAchievements', unlockedAchievements.toList());
      } while (_needsResave); // Если во время сохранения пришли изменения — сохраняем ещё раз
    } catch (e) {
      debugPrint('❌ AppState.save failed: $e');
      rethrow;
    } finally {
      _isSaving = false;
    }
  }

  // === ЗАГРУЗКА ===
  static Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    xp = prefs.getInt('xp') ?? 0;
    currentStreak = prefs.getInt('streak') ?? 0;
    isDarkMode = prefs.getBool('isDarkMode') ?? false;
    languageCode = prefs.getString('languageCode') ?? 'en';
    userName = prefs.getString('userName') ?? '';
    userAvatar = prefs.getString('userAvatar') ?? 'joy';
    themeNotifier.value = isDarkMode;
    AppLoc.lang.value = languageCode;
    final cardsJson = prefs.getString('cards') ?? '{}';
    cards = (jsonDecode(cardsJson) as Map<String, dynamic>).map((k, v) => MapEntry(k, CardProgress.fromJson(v)));
    learnedWords = (prefs.getStringList('learnedWords') ?? []).toSet();
    unlockedAchievements = (prefs.getStringList('unlockedAchievements') ?? []).toSet();
  }

  // === БИЗНЕС-ЛОГИКА (использует _scheduleSave — батчинг) ===
  static void addXP(int amount) {
    final oldLevel = level;
    xp += amount;
    if (level > oldLevel) pendingLevelUp = level;
    _scheduleSave();
  }

  static void updateStreak() {
    currentStreak++;
    _scheduleSave();
  }

  static String cardId(String type, String char) => '${type}_$char';

  static void recordAnswer(String cardId, bool correct) {
    if (!cards.containsKey(cardId)) cards[cardId] = CardProgress(cardId: cardId);
    if (correct) {
      cards[cardId]!.recordCorrect();
    } else {
      cards[cardId]!.recordIncorrect();
    }
    _scheduleSave();
  }

  static void toggleTheme() {
    isDarkMode = !isDarkMode;
    themeNotifier.value = isDarkMode;
    _scheduleSave();
  }

  static void setLanguage(String code) {
    languageCode = code;
    AppLoc.lang.value = code;
    _scheduleSave();
  }

  // === КРИТИЧНЫЕ ДЕЙСТВИЯ (await напрямую, без дебаунса) ===
  static Future<void> resetProgress() async {
    _saveDebounce?.cancel();
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    xp = 0;
    currentStreak = 0;
    cards.clear();
    learnedWords.clear();
    unlockedAchievements.clear();
    await save();
  }

  static void cheatProgress() {
    xp = 5000;
    currentStreak = 10;
    learnedWords = {'a', 'i', 'u', 'e', 'o'};
    unlockedAchievements = achievements.map((a) => a.id).toSet();
    save().catchError((e) => debugPrint('cheat save error: $e'));
  }
}