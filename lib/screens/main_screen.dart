import 'package:flutter/material.dart';
import '../services/app_state.dart';
import '../services/notification_service.dart';
import '../widgets/sidebar_menu.dart';
import 'world_map_screen.dart';
import 'vocab_screen.dart';
import 'grammar_screen.dart';
import 'review_screen.dart';
import 'quests_screen.dart';
import 'profile_screen.dart';
import 'settings_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with WidgetsBindingObserver {
  int _current = 0;

  final _screens = const [
    WorldMapScreen(),   // 0 - главная (карта)
    VocabScreen(),      // 1
    GrammarScreen(),    // 2
    ReviewScreen(),     // 3
    QuestsScreen(),     // 4
    ProfileScreen(),    // 5
    SettingsScreen(),   // 6
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    // Тестовое уведомление через 5 секунд после старта
    Future.delayed(const Duration(seconds: 5), () {
      if (!mounted) return;
      NotificationService.instance.showStreakReminder(AppState.currentStreak);
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive ||
        state == AppLifecycleState.detached) {
      AppState.save();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          SidebarMenu(
            currentIndex: _current,
            onTap: (i) => setState(() => _current = i),
          ),
          Expanded(
            child: IndexedStack(
              index: _current,
              children: _screens,
            ),
          ),
        ],
      ),
    );
  }
}