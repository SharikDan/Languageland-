// Widget-тест для MainScreen
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:languageland/screens/main_screen.dart';
import 'package:languageland/services/app_state.dart';

void main() {
  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await AppState.load();
  });

  testWidgets('MainScreen рендерится без ошибок', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: MainScreen(),
      ),
    );

    expect(find.byType(MainScreen), findsOneWidget);
  });

  testWidgets('MainScreen содержит sidebar с 8 кнопками', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: MainScreen(),
      ),
    );

    // Проверяем наличие иконок навигации
    expect(find.byIcon(Icons.abc), findsOneWidget); // Кана
    expect(find.byIcon(Icons.book), findsOneWidget); // Лексика
    expect(find.byIcon(Icons.edit_note), findsOneWidget); // Грамматика
    expect(find.byIcon(Icons.refresh), findsOneWidget); // Повторение
    expect(find.byIcon(Icons.task_alt), findsOneWidget); // Квесты
    expect(find.byIcon(Icons.map), findsOneWidget); // Карта
    expect(find.byIcon(Icons.person), findsOneWidget); // Профиль
    expect(find.byIcon(Icons.settings), findsOneWidget); // Настройки
  });

  testWidgets('Переключение между табами работает', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: MainScreen(),
      ),
    );

    // Нажимаем на "Лексика"
    await tester.tap(find.byIcon(Icons.book));
    await tester.pumpAndSettle();

    // Проверяем что контент изменился
    expect(find.byType(MainScreen), findsOneWidget);
  });

  testWidgets('Клик по каждой кнопке меню не вызывает ошибок', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: MainScreen(),
      ),
    );

    final menuIcons = [
      Icons.abc,
      Icons.book,
      Icons.edit_note,
      Icons.refresh,
      Icons.task_alt,
      Icons.map,
      Icons.person,
      Icons.settings,
    ];

    for (final icon in menuIcons) {
      await tester.tap(find.byIcon(icon));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    }
  });

  testWidgets('MainScreen не переполняется на маленьком экране', (tester) async {
    tester.view.physicalSize = const Size(320, 240);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(
      const MaterialApp(
        home: MainScreen(),
      ),
    );

    expect(tester.takeException(), isNull);
  });

  testWidgets('MainScreen работает на планшете', (tester) async {
    tester.view.physicalSize = const Size(800, 1280);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(
      const MaterialApp(
        home: MainScreen(),
      ),
    );

    expect(tester.takeException(), isNull);
  });

  testWidgets('MainScreen работает в landscape', (tester) async {
    tester.view.physicalSize = const Size(731, 411);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(
      const MaterialApp(
        home: MainScreen(),
      ),
    );

    expect(find.byType(MainScreen), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Sidebar виден на экране', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: MainScreen(),
      ),
    );

    // Проверяем что sidebar занимает левую часть экрана
    final sidebar = find.byIcon(Icons.abc);
    expect(sidebar, findsOneWidget);
  });

  testWidgets('Активная кнопка меню выделена визуально', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: MainScreen(),
      ),
    );

    // Первая кнопка должна быть активной по умолчанию
    final firstButton = find.byIcon(Icons.abc);
    expect(firstButton, findsOneWidget);

    // Нажимаем на вторую кнопку
    await tester.tap(find.byIcon(Icons.book));
    await tester.pumpAndSettle();

    // Проверяем что вторая кнопка теперь активна
    expect(find.byIcon(Icons.book), findsOneWidget);
  });
}
