import 'package:flutter/material.dart';
import 'loc/common_loc.dart';
import 'loc/menu_loc.dart';
import 'loc/screens_loc.dart';

class AppLoc {
  static final ValueNotifier<String> lang = ValueNotifier('en');
  static final Map<String, Map<String, String>> _dict = {
    'ru': {...commonRu, ...menuRu, ...screensRu},
    'en': {...commonEn, ...menuEn, ...screensEn},
  };
  static String t(String key) => _dict[lang.value]?[key] ?? key;
}