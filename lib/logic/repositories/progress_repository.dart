import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ayas_languageland/models/card_progress.dart';
import 'package:ayas_languageland/models/achievement.dart';
import 'base_repository.dart';

class ProgressRepository extends BaseRepository {
  ProgressRepository._();
  static final ProgressRepository instance = ProgressRepository._();

  int xp = 0;
  int get level => ((xp ~/ 100) + 1).clamp(1, 999).toInt();
  int currentStreak = 0;
  Map<String, CardProgress> cards = {};
  Set<String> learnedWords = {};
  Set<String> unlockedAchievements = {};
  
  int? pendingLevelUp;
  Achievement? pendingAchievement;

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    xp = prefs.getInt('xp') ?? 0;
    currentStreak = prefs.getInt('streak') ?? 0;
    
    final cardsJson = prefs.getString('cards') ?? '{}';
    cards = (jsonDecode(cardsJson) as Map<String, dynamic>).map((k, v) => MapEntry(k, CardProgress.fromJson(v)));
    learnedWords = (prefs.getStringList('learnedWords') ?? []).toSet();
    unlockedAchievements = (prefs.getStringList('unlockedAchievements') ?? []).toSet();
  }

  @override
  Future<void> saveData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('xp', xp);
    await prefs.setInt('streak', currentStreak);
    await prefs.setString('cards', jsonEncode(cards.map((k, v) => MapEntry(k, v.toJson()))));
    await prefs.setStringList('learnedWords', learnedWords.toList());
    await prefs.setStringList('unlockedAchievements', unlockedAchievements.toList());
  }

  void addXP(int amount) {
    final oldLevel = level;
    xp += amount;
    if (level > oldLevel) pendingLevelUp = level;
    scheduleSave();
  }

  void updateStreak() {
    currentStreak++;
    scheduleSave();
  }

  String cardId(String type, String char) => '${type}_$char';

  void recordAnswer(String cardId, bool correct) {
    if (!cards.containsKey(cardId)) cards[cardId] = CardProgress(cardId: cardId);
    if (correct) {
      cards[cardId]!.recordCorrect();
    } else {
      cards[cardId]!.recordIncorrect();
    }
    scheduleSave();
  }

  Future<void> reset() async {
    xp = 0;
    currentStreak = 0;
    cards.clear();
    learnedWords.clear();
    unlockedAchievements.clear();
    await save();
  }

  void cheat() {
    xp = 5000;
    currentStreak = 10;
    learnedWords = {'a', 'i', 'u', 'e', 'o'};
    unlockedAchievements = {'first_lesson', 'hiragana_master'};
    save().catchError((e) => debugPrint('cheat error: $e'));
  }
}