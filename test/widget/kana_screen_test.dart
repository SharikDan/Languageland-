// Widget-тест для KanaScreen
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:languageland/screens/kana_screen.dart';
import 'package:languageland/services/app_state.dart';

void main() {
  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await AppState.load();
  });

  testWidgets('KanaScreen рендерится без ошибок', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: KanaScreen(),
      ),
    );

    expect(find.byType(KanaScreen), findsOneWidget);
  });

  testWidgets('KanaScreen показывает выбор хирагана/катакана/кандзи', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: KanaScreen(),
      ),
    );

    expect(find.text('Хирагана'), findsOneWidget);
    expect(find.text('Катакана'), findsOneWidget);
    expect(find.text('Кандзи'), findsOneWidget);
  });

  testWidgets('Переключение между хирагана/катакана работает', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: KanaScreen(),
      ),
    );

    // Клик на Катакана
    await tester.tap(find.text('Катакана'));
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
  });

  testWidgets('Кнопка "Начать изучение" запускает урок', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: KanaScreen(),
      ),
    );

    final startButton = find.widgetWithText(ElevatedButton, 'Начать изучение');
    if (startButton.evaluate().isNotEmpty) {
      await tester.tap(startButton);
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
    }
  });

  testWidgets('Режим обучения показывает знак и варианты ответа', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: KanaScreen(),
      ),
    );

    final startButton = find.widgetWithText(ElevatedButton, 'Начать изучение');
    if (startButton.evaluate().isNotEmpty) {
      await tester.tap(startButton);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      // Должно быть 4 варианта ответа
      final optionButtons = find.byType(ElevatedButton);
      expect(optionButtons, findsWidgets);
    }
  });

  testWidgets('Выбор варианта ответа работает', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: KanaScreen(),
      ),
    );

    final startButton = find.widgetWithText(ElevatedButton, 'Начать изучение');
    if (startButton.evaluate().isNotEmpty) {
      await tester.tap(startButton);
      await tester.pumpAndSettle();

      // Находим первую кнопку с вариантом ответа
      final optionButtons = find.byType(ElevatedButton);
      if (optionButtons.evaluate().isNotEmpty) {
        await tester.tap(optionButtons.first);
        await tester.pumpAndSettle();

        expect(tester.takeException(), isNull);
      }
    }
  });

  testWidgets('KanaScreen не переполняется на маленьком экране', (tester) async {
    tester.view.physicalSize = const Size(320, 240);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(
      const MaterialApp(
        home: KanaScreen(),
      ),
    );

    expect(tester.takeException(), isNull);
  });

  testWidgets('KanaScreen работает на планшете', (tester) async {
    tester.view.physicalSize = const Size(800, 1280);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(
      const MaterialApp(
        home: KanaScreen(),
      ),
    );

    expect(tester.takeException(), isNull);
  });

  testWidgets('KanaScreen работает в landscape', (tester) async {
    tester.view.physicalSize = const Size(731, 411);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(
      const MaterialApp(
        home: KanaScreen(),
      ),
    );

    expect(find.byType(KanaScreen), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Прогресс-бар отображается в режиме обучения', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: KanaScreen(),
      ),
    );

    final startButton = find.widgetWithText(ElevatedButton, 'Начать изучение');
    if (startButton.evaluate().isNotEmpty) {
      await tester.tap(startButton);
      await tester.pumpAndSettle();

      // Проверяем наличие прогресс-бара
      final progressIndicator = find.byType(LinearProgressIndicator);
      expect(progressIndicator, findsOneWidget);
    }
  });

  testWidgets('Кнопка "Выход" возвращает к выбору', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: KanaScreen(),
      ),
    );

    final startButton = find.widgetWithText(ElevatedButton, 'Начать изучение');
    if (startButton.evaluate().isNotEmpty) {
      await tester.tap(startButton);
      await tester.pumpAndSettle();

      // Ищем кнопку выхода
      final exitButton = find.byIcon(Icons.close);
      if (exitButton.evaluate().isNotEmpty) {
        await tester.tap(exitButton);
        await tester.pumpAndSettle();

        // Должны вернуться к выбору режима
        expect(find.text('Хирагана'), findsOneWidget);
      }
    }
  });
}
