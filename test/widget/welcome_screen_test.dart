// Widget-тест для WelcomeScreen
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:languageland/screens/welcome_screen.dart';
import 'package:languageland/services/app_state.dart';

void main() {
  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await AppState.load();
  });

  testWidgets('WelcomeScreen рендерится без ошибок', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: WelcomeScreen(),
      ),
    );

    expect(find.byType(WelcomeScreen), findsOneWidget);
  });

  testWidgets('WelcomeScreen содержит заголовок "Languageland"', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: WelcomeScreen(),
      ),
    );

    expect(find.text('Languageland'), findsOneWidget);
  });

  testWidgets('WelcomeScreen содержит кнопку "Начать"', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: WelcomeScreen(),
      ),
    );

    expect(
      find.widgetWithText(ElevatedButton, 'Начать'),
      findsOneWidget,
    );
  });

  testWidgets('Кнопка "Начать" реагирует на нажатие', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: WelcomeScreen(),
      ),
    );

    final button = find.widgetWithText(ElevatedButton, 'Начать');
    await tester.tap(button);
    await tester.pumpAndSettle();

    // Проверяем что навигация сработала (экран изменился)
    expect(find.byType(WelcomeScreen), findsNothing);
  });

  testWidgets('WelcomeScreen не переполняется на маленьком экране', (tester) async {
    tester.view.physicalSize = const Size(320, 240);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(
      const MaterialApp(
        home: WelcomeScreen(),
      ),
    );

    expect(tester.takeException(), isNull);
  });

  testWidgets('WelcomeScreen работает на планшете', (tester) async {
    tester.view.physicalSize = const Size(800, 1280);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(
      const MaterialApp(
        home: WelcomeScreen(),
      ),
    );

    expect(tester.takeException(), isNull);
  });

  testWidgets('WelcomeScreen работает в landscape', (tester) async {
    tester.view.physicalSize = const Size(731, 411);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(
      const MaterialApp(
        home: WelcomeScreen(),
      ),
    );

    expect(find.byType(WelcomeScreen), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
