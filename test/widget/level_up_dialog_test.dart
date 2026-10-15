// Widget-тест для LevelUpDialog
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:languageland/widgets/level_up_dialog.dart';

void main() {
  testWidgets('LevelUpDialog рендерится без ошибок', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: LevelUpDialog(level: 5),
        ),
      ),
    );

    expect(find.byType(LevelUpDialog), findsOneWidget);
  });

  testWidgets('LevelUpDialog показывает правильный уровень', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: LevelUpDialog(level: 10),
        ),
      ),
    );

    expect(find.textContaining('10'), findsOneWidget);
  });

  testWidgets('LevelUpDialog содержит кнопку закрытия', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: LevelUpDialog(level: 5),
        ),
      ),
    );

    final closeButton = find.widgetWithText(ElevatedButton, 'Продолжить');
    expect(closeButton, findsOneWidget);
  });

  testWidgets('Кнопка закрытия работает', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) {
              return ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (ctx) => const Dialog(
                      child: LevelUpDialog(level: 5),
                    ),
                  );
                },
                child: const Text('Show'),
              );
            },
          ),
        ),
      ),
    );

    await tester.tap(find.text('Show'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Продолжить'));
    await tester.pumpAndSettle();

    expect(find.byType(LevelUpDialog), findsNothing);
  });

  testWidgets('LevelUpDialog не переполняет экран 320x240', (tester) async {
    tester.view.physicalSize = const Size(320, 240);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: LevelUpDialog(level: 42),
        ),
      ),
    );

    expect(tester.takeException(), isNull);
  });

  testWidgets('LevelUpDialog работает на 411x731', (tester) async {
    tester.view.physicalSize = const Size(411, 731);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: LevelUpDialog(level: 15),
        ),
      ),
    );

    expect(tester.takeException(), isNull);
  });

  testWidgets('LevelUpDialog работает на планшете 800x1280', (tester) async {
    tester.view.physicalSize = const Size(800, 1280);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: LevelUpDialog(level: 99),
        ),
      ),
    );

    expect(tester.takeException(), isNull);
  });

  testWidgets('LevelUpDialog работает в landscape', (tester) async {
    tester.view.physicalSize = const Size(731, 411);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: LevelUpDialog(level: 7),
        ),
      ),
    );

    expect(find.byType(LevelUpDialog), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('LevelUpDialog отображает поздравление', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: LevelUpDialog(level: 5),
        ),
      ),
    );

    expect(find.textContaining('Поздравляем'), findsOneWidget);
  });

  testWidgets('LevelUpDialog с большим уровнем не ломается', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: LevelUpDialog(level: 999),
        ),
      ),
    );

    expect(find.textContaining('999'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('LevelUpDialog с уровнем 1 работает', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: LevelUpDialog(level: 1),
        ),
      ),
    );

    expect(find.textContaining('1'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
