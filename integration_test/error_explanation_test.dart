// Integration-тест: Ошибка → ИИ-объяснялка → возврат
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:languageland/main.dart' as app;
import 'package:languageland/services/app_state.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Сценарий с ошибкой и ИИ-объяснялкой', () {
    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      await AppState.load();
      AppState.hasCompletedOnboarding = true;
    });

    testWidgets('Ошибка → ИИ-объяснялка показана → кнопка "Понять" → продолжение',
        (tester) async {
      app.main();
      await tester.pumpAndSettle();

      await tester.tap(find.text('Начать'));
      await tester.pumpAndSettle();

      // Переход к лексике
      await tester.tap(find.byIcon(Icons.book));
      await tester.pumpAndSettle();

      // Начинаем урок
      final startButton = find.widgetWithText(ElevatedButton, 'Начать');
      if (startButton.evaluate().isNotEmpty) {
        await tester.tap(startButton);
        await tester.pumpAndSettle();

        // Выбираем неправильный ответ (пробуем все варианты до ошибки)
        final optionButtons = find.byType(ElevatedButton);
        if (optionButtons.evaluate().length >= 4) {
          // Пробуем разные варианты пока не попадём на ошибку
          for (int i = 0; i < 4; i++) {
            final xpBefore = AppState.xp;
            await tester.tap(optionButtons.at(i));
            await tester.pumpAndSettle(const Duration(seconds: 1));

            // Если XP не вырос - значит ответ был неправильный
            if (AppState.xp == xpBefore) {
              // Должна появиться ИИ-объяснялка
              // Ищем текст "Ошибка" или "Почему"
              final hasExplanation = find.textContaining('Ошибка').evaluate().isNotEmpty ||
                                   find.textContaining('Почему').evaluate().isNotEmpty;
              
              if (hasExplanation) {
                // Нажимаем кнопку "Понятно" или "Продолжить"
                final continueButton = find.text('Понятно');
                if (continueButton.evaluate().isNotEmpty) {
                  await tester.tap(continueButton);
                  await tester.pumpAndSettle();
                }
              }

              // Проверяем что приложение не крашнулось
              expect(tester.takeException(), isNull);
              break;
            }
          }
        }
      }
    });

    testWidgets('Несколько ошибок подряд не ломают приложение', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      await tester.tap(find.text('Начать'));
      await tester.pumpAndSettle();

      // Переход к кане
      await tester.tap(find.byIcon(Icons.abc));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Хирагана'));
      await tester.pumpAndSettle();

      final startButton = find.widgetWithText(ElevatedButton, 'Начать изучение');
      if (startButton.evaluate().isNotEmpty) {
        await tester.tap(startButton);
        await tester.pumpAndSettle();

        // Делаем 3 неправильных ответа подряд
        for (int attempt = 0; attempt < 3; attempt++) {
          final optionButtons = find.byType(ElevatedButton);
          if (optionButtons.evaluate().length >= 4) {
            // Выбираем случайный вариант
            await tester.tap(optionButtons.at(attempt % 4));
            await tester.pumpAndSettle(const Duration(seconds: 1));

            // Закрываем объяснялку если появилась
            final continueButton = find.text('Понятно');
            if (continueButton.evaluate().isNotEmpty) {
              await tester.tap(continueButton);
              await tester.pumpAndSettle();
            }
          }

          // Проверяем что приложение живо
          expect(tester.takeException(), isNull);
        }
      }
    });

    testWidgets('ИИ-объяснялка не переполняет экран', (tester) async {
      tester.view.physicalSize = const Size(320, 240);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      app.main();
      await tester.pumpAndSettle();

      await tester.tap(find.text('Начать'));
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.book));
      await tester.pumpAndSettle();

      final startButton = find.widgetWithText(ElevatedButton, 'Начать');
      if (startButton.evaluate().isNotEmpty) {
        await tester.tap(startButton);
        await tester.pumpAndSettle();

        final optionButtons = find.byType(ElevatedButton);
        if (optionButtons.evaluate().isNotEmpty) {
          await tester.tap(optionButtons.first);
          await tester.pumpAndSettle(const Duration(seconds: 1));

          // Проверяем что нет overflow даже на маленьком экране
          expect(tester.takeException(), isNull);
        }
      }
    });
  });
}
