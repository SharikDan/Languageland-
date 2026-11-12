import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ayas_languageland/logic/services/app_localizations.dart';
import 'base_repository.dart';

class SettingsRepository extends BaseRepository {
  SettingsRepository._();
  static final SettingsRepository instance = SettingsRepository._();

  bool isDarkMode = false;
  String languageCode = 'en';
  bool isSoundEnabled = true;
  bool isMusicEnabled = true;
  bool isTTSEnabled = true;

  final ValueNotifier<bool> themeNotifier = ValueNotifier<bool>(false);

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    isDarkMode = prefs.getBool('isDarkMode') ?? false;
    languageCode = prefs.getString('languageCode') ?? 'en';
    isSoundEnabled = prefs.getBool('isSoundEnabled') ?? true;
    isMusicEnabled = prefs.getBool('isMusicEnabled') ?? true;
    isTTSEnabled = prefs.getBool('isTTSEnabled') ?? true;

    themeNotifier.value = isDarkMode;
    AppLoc.lang.value = languageCode;
  }

  @override
  Future<void> saveData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', isDarkMode);
    await prefs.setString('languageCode', languageCode);
    await prefs.setBool('isSoundEnabled', isSoundEnabled);
    await prefs.setBool('isMusicEnabled', isMusicEnabled);
    await prefs.setBool('isTTSEnabled', isTTSEnabled);
  }

  void toggleTheme() {
    isDarkMode = !isDarkMode;
    themeNotifier.value = isDarkMode;
    scheduleSave();
  }

  void setLanguage(String code) {
    languageCode = code;
    AppLoc.lang.value = code;
    scheduleSave();
  }
}