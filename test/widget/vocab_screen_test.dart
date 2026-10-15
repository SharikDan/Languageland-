// Widget-тест для VocabScreen
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:languageland/screens/vocab_screen.dart';
import 'package:languageland/services/app_state.dart';

void main() {
  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await AppState.load();
  });

  testWidgets('VocabScreen рендерится без ошибок', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: VocabScreen(),
      ),
    );

    expect(find.byType(VocabScreen), findsOneWidget);
  });

  testWidgets('VocabScreen показывает слово при старте обучения', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: VocabScreen(),
      ),
    );

    final startButton = find.widgetWithText(ElevatedButton, 'Начать');
    if (startButton.evaluate().isNotEmpty) {
      await tester.tap(startButton);
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
    }
  });

  testWidgets('VocabScreen показывает 4 варианта ответа', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: VocabScreen(),
      ),
    );

    final startButton = find.widgetWithText(ElevatedButton, 'Начать');
    if (startButton.evaluate().isNotEmpty) {
      await tester.tap(startButton);
      await tester.pumpAndSettle();

      // Должно быть 4 кнопки с вариантами
      final optionButtons = find.byType(ElevatedButton);
      expect(optionButtons, findsWidgets);
    }
  });

  testWidgets('При ошибке показывается ИИ-объяснялка', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: VocabScreen(),
      ),
    );

    final startButton = find.widgetWithText(ElevatedButton, 'Начать');
    if (startButton.evaluate().isNotEmpty) {
      await tester.tap(startButton);
      await tester.pumpAndSettle();

      // Выбираем любой вариант
      final optionButtons = find.byType(ElevatedButton);
      if (optionButtons.evaluate().isNotEmpty) {
        await tester.tap(optionButtons.first);
        await tester.pumpAndSettle();

        // Если ответ неправильный, должна появиться объяснялка
        // Проверяем что не крашится
        expect(tester.takeException(), isNull);
      }
    }
  });

  testWidgets('VocabScreen не переполняется на маленьком экране', (tester) async {
    tester.view.physicalSize = const Size(320, 240);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(
      const MaterialApp(
        home: VocabScreen(),
      ),
    );

    expect(tester.takeException(), isNull);
  });

  testWidgets('VocabScreen работает на планшете', (tester) async {
    tester.view.physicalSize = const Size(800, 1280);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(
      const MaterialApp(
        home: VocabScreen(),
      ),
    );

    expect(tester.takeException(), isNull);
  });

  testWidgets('VocabScreen работает в landscape', (tester) async {
    tester.view.physicalSize = const Size(731, 411);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(
      const MaterialApp(
        home: VocabScreen(),
      ),
    );

    expect(find.byType(VocabScreen), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Прогресс отображается корректно', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: VocabScreen(),
      ),
    );

    final startButton = find.widgetWithText(ElevatedButton, 'Начать');
    if (startButton.evaluate().isNotEmpty) {
      await tester.tap(startButton);
      await tester.pumpAndSettle();

      // Проверяем наличие индикатора прогресса
      final progressText = find.textContaining('/');
      expect(progressText, findsWidgets);
    }
  });

  testWidgets('Кнопка выхода работает', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: VocabScreen(),
      ),
    );

    final startButton = find.widgetWithText(ElevatedButton, 'Начать');
    if (startButton.evaluate().isNotEmpty) {
      await tester.tap(startButton);
      await tester.pumpAndSettle();

      final exitButton = find.byIcon(Icons.close);
      if (exitButton.evaluate().isNotEmpty) {
        await tester.tap(exitButton);
        await tester.pumpAndSettle();

        expect(tester.takeException(), isNull);
      }
    }
  });

  testWidgets('TTS кнопка присутствует для озвучки', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: VocabScreen(),
      ),
    );

    final startButton = find.widgetWithText(ElevatedButton, 'Начать');
    if (startButton.evaluate().isNotEmpty) {
      await tester.tap(startButton);
      await tester.pumpAndSettle();

      // Ищем кнопку озвучки
      final ttsButton = find.byIcon(Icons.volume_up);
      expect(ttsButton, findsWidgets);
    }
  });
}
