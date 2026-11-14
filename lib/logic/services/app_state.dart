import 'package:flutter/material.dart';
import 'package:ayas_languageland/models/achievement.dart';
import 'package:ayas_languageland/models/card_progress.dart';
import 'package:ayas_languageland/logic/repositories/progress_repository.dart';
import 'package:ayas_languageland/logic/repositories/settings_repository.dart';
import 'package:ayas_languageland/logic/repositories/profile_repository.dart';

/// AppState Ñ‚ÐµÐ¿ÐµÑ€ÑŒ Ð²Ñ‹ÑÑ‚ÑƒÐ¿Ð°ÐµÑ‚ ÐºÐ°Ðº Ð¤ÐÐ¡ÐÐ” Ð´Ð»Ñ Ñ€ÐµÐ¿Ð¾Ð·Ð¸Ñ‚Ð¾Ñ€Ð¸ÐµÐ².
/// Ð’ÐµÑÑŒ ÑÑƒÑ‰ÐµÑÑ‚Ð²ÑƒÑŽÑ‰Ð¸Ð¹ ÐºÐ¾Ð´ (ÑÐºÑ€Ð°Ð½Ñ‹, BLoC) Ð¿Ñ€Ð¾Ð´Ð¾Ð»Ð¶Ð°ÐµÑ‚ Ñ€Ð°Ð±Ð¾Ñ‚Ð°Ñ‚ÑŒ Ð±ÐµÐ· Ð¸Ð·Ð¼ÐµÐ½ÐµÐ½Ð¸Ð¹!
class AppState {
  AppState._();

  static ProgressRepository get _progress => ProgressRepository.instance;
  static SettingsRepository get _settings => SettingsRepository.instance;
  static ProfileRepository get _profile => ProfileRepository.instance;

  // === Ð“Ð•Ð¢Ð¢Ð•Ð Ð« / Ð¡Ð•Ð¢Ð¢Ð•Ð Ð« (Ð¿Ñ€Ð¾ÐºÑÐ¸ Ðº Ñ€ÐµÐ¿Ð¾Ð·Ð¸Ñ‚Ð¾Ñ€Ð¸ÑÐ¼) ===
  static int get xp => _progress.xp;
  static set xp(int v) => _progress.xp = v;

  static int get level => _progress.level;
  static int get currentStreak => _progress.currentStreak;
  static set currentStreak(int v) => _progress.currentStreak = v;

  static Map<String, CardProgress> get cards => _progress.cards;
  static set cards(Map<String, CardProgress> v) => _progress.cards = v;

  static Set<String> get learnedWords => _progress.learnedWords;
  static set learnedWords(Set<String> v) => _progress.learnedWords = v;

  static Set<String> get unlockedAchievements => _progress.unlockedAchievements;
  static set unlockedAchievements(Set<String> v) => _progress.unlockedAchievements = v;

  static int? get pendingLevelUp => _progress.pendingLevelUp;
  static set pendingLevelUp(int? v) => _progress.pendingLevelUp = v;

  static Achievement? get pendingAchievement => _progress.pendingAchievement;
  static set pendingAchievement(Achievement? v) => _progress.pendingAchievement = v;

  static bool get isDarkMode => _settings.isDarkMode;
  static set isDarkMode(bool v) => _settings.isDarkMode = v;

  static String get languageCode => _settings.languageCode;
  static set languageCode(String v) => _settings.languageCode = v;

  static bool get isSoundEnabled => _settings.isSoundEnabled;
  static set isSoundEnabled(bool v) => _settings.isSoundEnabled = v;

  static bool get isMusicEnabled => _settings.isMusicEnabled;
  static set isMusicEnabled(bool v) => _settings.isMusicEnabled = v;

  static bool get isTTSEnabled => _settings.isTTSEnabled;
  static set isTTSEnabled(bool v) => _settings.isTTSEnabled = v;

  static String get userName => _profile.userName;
  static set userName(String v) => _profile.userName = v;

  static String get userAvatar => _profile.userAvatar;
  static set userAvatar(String v) => _profile.userAvatar = v;

  static ValueNotifier<bool> get themeNotifier => _settings.themeNotifier;

  // === ÐœÐ•Ð¢ÐžÐ”Ð« (Ð¿Ñ€Ð¾ÐºÑÐ¸ Ðº Ñ€ÐµÐ¿Ð¾Ð·Ð¸Ñ‚Ð¾Ñ€Ð¸ÑÐ¼) ===
  static Future<void> load() async {
    await Future.wait([
      _progress.load(),
      _settings.load(),
      _profile.load(),
    ]);
  }

  static Future<void> save() async {
    await Future.wait([
      _progress.save(),
      _settings.save(),
      _profile.save(),
    ]);
  }

  static void addXP(int amount) => _progress.addXP(amount);
  static void updateStreak() => _progress.updateStreak();
  static String cardId(String type, String char) => _progress.cardId(type, char);
  static void recordAnswer(String cardId, bool correct) => _progress.recordAnswer(cardId, correct);
  
  static void toggleTheme() => _settings.toggleTheme();
  static void setLanguage(String code) => _settings.setLanguage(code);

  static Future<void> resetProgress() async {
    await _progress.reset();
  }

  static Set<String> get claimedQuests => _progress.claimedQuests;
  static void claimQuest(String questId, int reward) => _progress.claimQuest(questId, reward);
  static bool checkDailyReward() => _progress.checkDailyReward();
  static void cheatProgress() => _progress.cheat();
}