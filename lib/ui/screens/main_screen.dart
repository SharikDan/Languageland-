import 'package:flutter/material.dart';
import 'package:ayas_languageland/logic/services/app_localizations.dart';
import 'package:ayas_languageland/widgets/sidebar_menu.dart';
import 'package:ayas_languageland/ui/screens/map_screen.dart';
import 'package:ayas_languageland/ui/screens/kana_screen.dart';
import 'package:ayas_languageland/ui/screens/kanji_screen.dart';
import 'package:ayas_languageland/ui/screens/vocab_screen.dart';
import 'package:ayas_languageland/ui/screens/grammar_screen.dart';
import 'package:ayas_languageland/ui/screens/review_screen.dart';
import 'package:ayas_languageland/ui/screens/quests_screen.dart';
import 'package:ayas_languageland/ui/screens/profile_screen.dart';
import 'package:ayas_languageland/ui/screens/settings_screen.dart';
import 'package:ayas_languageland/ui/screens/chat_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    // Слушаем смену языка — весь интерфейс перерисуется
    return ValueListenableBuilder<String>(
      valueListenable: AppLoc.lang,
      builder: (context, langCode, child) {
        // ВАЖНО: БЕЗ const! Иначе Flutter не перерисует экраны при смене языка.
        final List<Widget> screens = [
          MapScreen(),
          KanaScreen(),
          KanjiScreen(),
          VocabScreen(),
          GrammarScreen(),
          ReviewScreen(),
          QuestsScreen(),
          ChatScreen(),
          ProfileScreen(),
          SettingsScreen(),
        ];

        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          body: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SidebarMenu(
                currentIndex: _currentIndex,
                onTap: (index) => setState(() => _currentIndex = index),
              ),
              Expanded(
                child: IndexedStack(
                  index: _currentIndex,
                  children: screens,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}