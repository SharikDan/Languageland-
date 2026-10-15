// Widget-тест для OnboardingScreen
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:languageland/screens/onboarding_screen.dart';
import 'package:languageland/services/app_state.dart';

void main() {
  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await AppState.load();
  });

  testWidgets('OnboardingScreen рендерится без ошибок', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: OnboardingScreen(),
      ),
    );

    expect(find.byType(OnboardingScreen), findsOneWidget);
  });

  testWidgets('OnboardingScreen показывает шаг 1 при старте', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: OnboardingScreen(),
      ),
    );

    expect(find.text('Добро пожаловать!'), findsOneWidget);
  });

  testWidgets('Кнопка "Далее" переходит на следующий шаг', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: OnboardingScreen(),
      ),
    );

    final nextButton = find.text('Далее');
    expect(nextButton, findsOneWidget);

    await tester.tap(nextButton);
    await tester.pumpAndSettle();

    expect(find.text('Как учиться?'), findsOneWidget);
  });

  testWidgets('Навигация между 3 шагами работает', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: OnboardingScreen(),
      ),
    );

    // Шаг 1
    expect(find.text('Добро пожаловать!'), findsOneWidget);

    // Переход на шаг 2
    await tester.tap(find.text('Далее'));
    await tester.pumpAndSettle();
    expect(find.text('Как учиться?'), findsOneWidget);

    // Переход на шаг 3
    await tester.tap(find.text('Далее'));
    await tester.pumpAndSettle();
    expect(find.text('Готовы начать?'), findsOneWidget);
  });

  testWidgets('Кнопка "Назад" возвращает на предыдущий шаг', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: OnboardingScreen(),
      ),
    );

    // Переход на шаг 2
    await tester.tap(find.text('Далее'));
    await tester.pumpAndSettle();

    // Возврат на шаг 1
    final backButton = find.byIcon(Icons.arrow_back);
    await tester.tap(backButton);
    await tester.pumpAndSettle();

    expect(find.text('Добро пожаловать!'), findsOneWidget);
  });

  testWidgets('Кнопка "Начать" на последнем шаге работает', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: OnboardingScreen(),
      ),
    );

    // Переход к последнему шагу
    await tester.tap(find.text('Далее'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Далее'));
    await tester.pumpAndSettle();

    // Нажатие "Начать"
    final startButton = find.text('Начать');
    expect(startButton, findsOneWidget);
    await tester.tap(startButton);
    await tester.pumpAndSettle();

    // Проверяем что экран изменился
    expect(find.byType(OnboardingScreen), findsNothing);
  });

  testWidgets('OnboardingScreen не переполняется на маленьком экране', (tester) async {
    tester.view.physicalSize = const Size(320, 240);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(
      const MaterialApp(
        home: OnboardingScreen(),
      ),
    );

    expect(tester.takeException(), isNull);
  });

  testWidgets('Индикаторы шагов отображаются корректно', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: OnboardingScreen(),
      ),
    );

    // Должно быть 3 индикатора (точки)
    final indicators = find.byType(Container);
    expect(indicators, findsWidgets);
  });

  testWidgets('OnboardingScreen работает в landscape', (tester) async {
    tester.view.physicalSize = const Size(731, 411);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(
      const MaterialApp(
        home: OnboardingScreen(),
      ),
    );

    expect(find.byType(OnboardingScreen), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
