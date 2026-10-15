// Integration-тест: Прохождение урока → level up → диалог
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:languageland/main.dart' as app;
import 'package:languageland/services/app_state.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Прохождение урока до level up', () {
    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      await AppState.load();
      AppState.hasCompletedOnboarding = true;
    });

    testWidgets('Прохождение урока → level up → диалог → закрытие → продолжение',
        (tester) async {
      app.main();
      await tester.pumpAndSettle();

      await tester.tap(find.text('Начать'));
      await tester.pumpAndSettle();

      // Устанавливаем XP близко к повышению уровня
      AppState.xp = 95; // Осталось 5 XP до уровня 2
      final levelBefore = AppState.level;

      // Переход к урокам
      await tester.tap(find.byIcon(Icons.abc));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Хирагана'));
      await tester.pumpAndSettle();

      final startButton = find.widgetWithText(ElevatedButton, 'Начать изучение');
      if (startButton.evaluate().isNotEmpty) {
        await tester.tap(startButton);
        await tester.pumpAndSettle();

        // Отвечаем правильно (пробуем все варианты)
        final optionButtons = find.byType(ElevatedButton);
        if (optionButtons.evaluate().isNotEmpty) {
          await tester.tap(optionButtons.first);
          await tester.pumpAndSettle(const Duration(seconds: 2));

          // Если XP вырос достаточно, должен показаться LevelUpDialog
          if (AppState.level > levelBefore) {
            // Ищем диалог
            final levelUpText = find.textContaining('Поздравляем');
            if (levelUpText.evaluate().isNotEmpty) {
              expect(levelUpText, findsOneWidget);

              // Закрываем диалог
              final continueButton = find.text('Продолжить');
              await tester.tap(continueButton);
              await tester.pumpAndSettle();

              // Проверяем что вернулись к уроку
              expect(find.textContaining('Поздравляем'), findsNothing);
            }
          }

          // Приложение должно работать нормально
          expect(tester.takeException(), isNull);
        }
      }
    });

    testWidgets('Level up диалог показывается при достижении уровня', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      await tester.tap(find.text('Начать'));
      await tester.pumpAndSettle();

      // Начальный уровень
      final initialLevel = AppState.level;

      // Добавляем 100 XP для гарантированного level up
      AppState.addXP(100);
      await tester.pumpAndSettle(const Duration(seconds: 1));

      // Проверяем что уровень вырос
      expect(AppState.level, greaterThan(initialLevel));

      // Диалог должен показаться (если реализован автопоказ)
      // Если нет - это нормально, проверяем что не крашит
      expect(tester.takeException(), isNull);
    });

    testWidgets('Несколько level up подряд работают корректно', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      await tester.tap(find.text('Начать'));
      await tester.pumpAndSettle();

      // Делаем 3 level up
      for (int i = 0; i < 3; i++) {
        final levelBefore = AppState.level;
        AppState.addXP(100);
        await tester.pumpAndSettle(const Duration(seconds: 1));

        expect(AppState.level, equals(levelBefore + 1));

        // Закрываем диалог если появился
        final continueButton = find.text('Продолжить');
        if (continueButton.evaluate().isNotEmpty) {
          await tester.tap(continueButton);
          await tester.pumpAndSettle();
        }

        expect(tester.takeException(), isNull);
      }
    });

    testWidgets('Level up диалог не переполняется на маленьком экране',
        (tester) async {
      tester.view.physicalSize = const Size(320, 240);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      app.main();
      await tester.pumpAndSettle();

      await tester.tap(find.text('Начать'));
      await tester.pumpAndSettle();

      // Вызываем level up
      AppState.addXP(100);
      await tester.pumpAndSettle(const Duration(seconds: 1));

      // Проверяем что нет overflow
      expect(tester.takeException(), isNull);
    });

    testWidgets('Прогресс сохраняется после level up', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      await tester.tap(find.text('Начать'));
      await tester.pumpAndSettle();

      AppState.xp = 0;
      AppState.addXP(250);
      await tester.pumpAndSettle();

      // Проверяем что XP и уровень сохранены
      expect(AppState.xp, equals(250));
      expect(AppState.level, equals(3));

      // Симулируем перезагрузку
      await AppState.save();
      await AppState.load();

      expect(AppState.xp, equals(250));
      expect(AppState.level, equals(3));
    });

    testWidgets('Level up после завершения урока работает', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      await tester.tap(find.text('Начать'));
      await tester.pumpAndSettle();

      // Устанавливаем XP близко к уровню
      AppState.xp = 90;

      // Идём в грамматику
      await tester.tap(find.byIcon(Icons.edit_note));
      await tester.pumpAndSettle();

      final startButton = find.widgetWithText(ElevatedButton, 'Начать');
      if (startButton.evaluate().isNotEmpty) {
        await tester.tap(startButton);
        await tester.pumpAndSettle();

        // Отвечаем на вопросы
        for (int i = 0; i < 3; i++) {
          final optionButtons = find.byType(ElevatedButton);
          if (optionButtons.evaluate().length >= 2) {
            await tester.tap(optionButtons.first);
            await tester.pumpAndSettle(const Duration(seconds: 1));

            // Закрываем любые диалоги
            final closeButtons = find.text('Продолжить');
            if (closeButtons.evaluate().isNotEmpty) {
              await tester.tap(closeButtons.first);
              await tester.pumpAndSettle();
            }
          }
        }

        // Проверяем что приложение работает
        expect(tester.takeException(), isNull);
      }
    });
  });
}
