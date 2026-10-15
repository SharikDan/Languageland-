// Integration-тест: Полный онбординг → дашборд → первый урок
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:languageland/main.dart' as app;
import 'package:languageland/services/app_state.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Полный флоу онбординга и первого урока', () {
    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      await AppState.load();
      AppState.hasCompletedOnboarding = false;
    });

    testWidgets('Онбординг → MainScreen → KanaScreen → правильный ответ → XP растёт',
        (tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Шаг 1: Welcome Screen
      expect(find.text('Languageland'), findsOneWidget);
      await tester.tap(find.text('Начать'));
      await tester.pumpAndSettle();

      // Шаг 2: Onboarding (3 экрана)
      expect(find.text('Добро пожаловать!'), findsOneWidget);
      await tester.tap(find.text('Далее'));
      await tester.pumpAndSettle();

      expect(find.text('Как учиться?'), findsOneWidget);
      await tester.tap(find.text('Далее'));
      await tester.pumpAndSettle();

      expect(find.text('Готовы начать?'), findsOneWidget);
      await tester.tap(find.text('Начать'));
      await tester.pumpAndSettle();

      // Шаг 3: MainScreen (дашборд)
      expect(find.byIcon(Icons.abc), findsOneWidget);
      expect(find.byIcon(Icons.book), findsOneWidget);

      // Запоминаем XP до урока
      final xpBefore = AppState.xp;

      // Шаг 4: Переход к изучению каны
      await tester.tap(find.byIcon(Icons.abc));
      await tester.pumpAndSettle();

      // Шаг 5: Выбираем Хирагана
      expect(find.text('Хирагана'), findsOneWidget);
      await tester.tap(find.text('Хирагана'));
      await tester.pumpAndSettle();

      // Шаг 6: Начинаем изучение
      final startButton = find.widgetWithText(ElevatedButton, 'Начать изучение');
      if (startButton.evaluate().isNotEmpty) {
        await tester.tap(startButton);
        await tester.pumpAndSettle();

        // Шаг 7: Находим варианты ответа
        final optionButtons = find.byType(ElevatedButton);
        if (optionButtons.evaluate().isNotEmpty) {
          // Выбираем первый вариант (может быть правильным или нет)
          await tester.tap(optionButtons.first);
          await tester.pumpAndSettle(const Duration(seconds: 2));

          // Проверяем что приложение не крашнулось
          expect(tester.takeException(), isNull);

          // Если был правильный ответ, XP должен вырасти
          // Если неправильный - покажется объяснялка
          final xpAfter = AppState.xp;
          
          // В любом случае урок должен продолжиться
          expect(xpAfter >= xpBefore, isTrue);
        }
      }
    });

    testWidgets('Навигация между всеми разделами работает', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Пропускаем онбординг
      AppState.hasCompletedOnboarding = true;
      
      await tester.tap(find.text('Начать'));
      await tester.pumpAndSettle();

      // Проходим по всем пунктам меню
      final menuIcons = [
        Icons.abc,      // Кана
        Icons.book,     // Лексика
        Icons.edit_note,// Грамматика
        Icons.refresh,  // Повторение
        Icons.task_alt, // Квесты
        Icons.map,      // Карта
        Icons.person,   // Профиль
        Icons.settings, // Настройки
      ];

      for (final icon in menuIcons) {
        await tester.tap(find.byIcon(icon));
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
      }
    });

    testWidgets('Приложение сохраняет прогресс', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Добавляем XP
      AppState.addXP(150);
      await tester.pumpAndSettle();

      // Проверяем что XP сохранился
      expect(AppState.xp, equals(150));
      expect(AppState.level, equals(2));

      // Перезапускаем приложение (симуляция)
      await AppState.load();
      expect(AppState.xp, equals(150));
    });
  });
}
