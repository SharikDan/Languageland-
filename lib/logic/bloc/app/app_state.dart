import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ayas_languageland/models/achievement.dart';
import 'package:ayas_languageland/models/card_progress.dart';

class AppState {
  AppState._();

  static int xp = 0;
  static int get level => ((xp ~/ 100) + 1).clamp(1, 999).toInt();
  static int currentStreak = 0;

  static Map<String, CardProgress> cards = {};
  static Set<String> learnedWords = {};
  static List<Achievement> achievements = [];
  static Set<String> unlockedAchievements = {};

  static bool isDarkMode = false;
  static bool isSoundEnabled = true;
  static bool isMusicEnabled = true;
  static bool isTTSEnabled = true;

  // ВОТ ОНИ, НАШЛИСЬ!
  static int? pendingLevelUp;
  static Achievement? pendingAchievement;

  static Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    xp = prefs.getInt('xp') ?? 0;
    currentStreak = prefs.getInt('streak') ?? 0;
    isDarkMode = prefs.getBool('isDarkMode') ?? false;

    final cardsJson = prefs.getString('cards') ?? '{}';
    final map = jsonDecode(cardsJson) as Map<String, dynamic>;
    cards = map.map((k, v) => MapEntry(k, CardProgress.fromJson(v)));

    learnedWords = (prefs.getStringList('learnedWords') ?? []).toSet();
    unlockedAchievements =
        (prefs.getStringList('unlockedAchievements') ?? []).toSet();
  }

  static Future<void> save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('xp', xp);
    await prefs.setInt('streak', currentStreak);
    await prefs.setBool('isDarkMode', isDarkMode);
    final cardsJson = cards.map((k, v) => MapEntry(k, v.toJson()));
    await prefs.setString('cards', jsonEncode(cardsJson));
    await prefs.setStringList('learnedWords', learnedWords.toList());
    await prefs.setStringList(
        'unlockedAchievements', unlockedAchievements.toList());
  }

  static void addXP(int amount) {
    final oldLevel = level;
    xp += amount;
    if (level > oldLevel) {
      pendingLevelUp = level;
    }
    save();
  }

  static void updateStreak() {
    currentStreak++;
    save();
  }

  static void recordAnswer(String cardId, bool correct) {
    if (!cards.containsKey(cardId)) {
      cards[cardId] = CardProgress(cardId: cardId);
    }
    if (correct) {
      cards[cardId]!.recordCorrect();
    } else {
      cards[cardId]!.recordIncorrect();
    }
    save();
  }

  static String cardId(String type, String char) => '${type}_$char';

  static Future<void> resetProgress() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    xp = 0;
    currentStreak = 0;
    cards.clear();
    learnedWords.clear();
    unlockedAchievements.clear();
    save();
  }
}
