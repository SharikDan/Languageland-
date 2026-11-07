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
    return ValueListenableBuilder<String>(
      valueListenable: AppLoc.lang,
      builder: (context, langCode, child) {
        final List<Widget> screens = [
          const MapScreen(),
          const KanaScreen(),
          const KanjiScreen(),
          const VocabScreen(),
          const GrammarScreen(),
          const ReviewScreen(),
          const QuestsScreen(),
          const ChatScreen(),
          const ProfileScreen(),
          const SettingsScreen(),
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