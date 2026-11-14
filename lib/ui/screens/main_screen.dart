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
import 'package:ayas_languageland/logic/services/app_state.dart';
import 'package:ayas_languageland/widgets/daily_reward_dialog.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    // Проверяем ежедневную награду при запуске
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (AppState.checkDailyReward()) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) => const DailyRewardDialog(),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Ð¡Ð»ÑƒÑˆÐ°ÐµÐ¼ ÑÐ¼ÐµÐ½Ñƒ ÑÐ·Ñ‹ÐºÐ° â€” Ð²ÐµÑÑŒ Ð¸Ð½Ñ‚ÐµÑ€Ñ„ÐµÐ¹Ñ Ð¿ÐµÑ€ÐµÑ€Ð¸ÑÑƒÐµÑ‚ÑÑ
    return ValueListenableBuilder<String>(
      valueListenable: AppLoc.lang,
      builder: (context, langCode, child) {
        // Ð’ÐÐ–ÐÐž: Ð‘Ð•Ð— const! Ð˜Ð½Ð°Ñ‡Ðµ Flutter Ð½Ðµ Ð¿ÐµÑ€ÐµÑ€Ð¸ÑÑƒÐµÑ‚ ÑÐºÑ€Ð°Ð½Ñ‹ Ð¿Ñ€Ð¸ ÑÐ¼ÐµÐ½Ðµ ÑÐ·Ñ‹ÐºÐ°.
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