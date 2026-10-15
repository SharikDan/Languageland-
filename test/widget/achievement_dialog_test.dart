// Widget-тест для AchievementDialog
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:languageland/widgets/achievement_dialog.dart';
import 'package:languageland/models/achievement.dart';

void main() {
  final testAchievement = Achievement(
    id: 'test_ach',
    title: 'Тестовая ачивка',
    description: 'Описание тестовой ачивки',
    iconName: 'star',
    isUnlocked: true,
  );

  testWidgets('AchievementDialog рендерится без ошибок', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AchievementDialog(achievement: testAchievement),
        ),
      ),
    );

    expect(find.byType(AchievementDialog), findsOneWidget);
  });

  testWidgets('AchievementDialog показывает название ачивки', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AchievementDialog(achievement: testAchievement),
        ),
      ),
    );

    expect(find.text('Тестовая ачивка'), findsOneWidget);
  });

  testWidgets('AchievementDialog показывает описание', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AchievementDialog(achievement: testAchievement),
        ),
      ),
    );

    expect(find.text('Описание тестовой ачивки'), findsOneWidget);
  });

  testWidgets('AchievementDialog содержит кнопку закрытия', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AchievementDialog(achievement: testAchievement),
        ),
      ),
    );

    final closeButton = find.widgetWithText(ElevatedButton, 'Отлично');
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
                    builder: (ctx) => Dialog(
                      child: AchievementDialog(achievement: testAchievement),
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

    await tester.tap(find.text('Отлично'));
    await tester.pumpAndSettle();

    expect(find.byType(AchievementDialog), findsNothing);
  });

  testWidgets('AchievementDialog не переполняет экран 320x240', (tester) async {
    tester.view.physicalSize = const Size(320, 240);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AchievementDialog(achievement: testAchievement),
        ),
      ),
    );

    expect(tester.takeException(), isNull);
  });

  testWidgets('AchievementDialog работает на 411x731', (tester) async {
    tester.view.physicalSize = const Size(411, 731);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AchievementDialog(achievement: testAchievement),
        ),
      ),
    );

    expect(tester.takeException(), isNull);
  });

  testWidgets('AchievementDialog работает на планшете 800x1280', (tester) async {
    tester.view.physicalSize = const Size(800, 1280);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AchievementDialog(achievement: testAchievement),
        ),
      ),
    );

    expect(tester.takeException(), isNull);
  });

  testWidgets('AchievementDialog работает в landscape', (tester) async {
    tester.view.physicalSize = const Size(731, 411);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AchievementDialog(achievement: testAchievement),
        ),
      ),
    );

    expect(find.byType(AchievementDialog), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('AchievementDialog с длинным текстом не ломается', (tester) async {
    final longAchievement = Achievement(
      id: 'long',
      title: 'Очень длинное название ачивки которое должно поместиться',
      description: 'Очень длинное описание ачивки которое содержит много текста и должно корректно отображаться без переполнения экрана',
      iconName: 'star',
      isUnlocked: true,
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AchievementDialog(achievement: longAchievement),
        ),
      ),
    );

    expect(tester.takeException(), isNull);
  });

  testWidgets('AchievementDialog показывает иконку', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AchievementDialog(achievement: testAchievement),
        ),
      ),
    );

    // Проверяем наличие иконки
    final icons = find.byType(Icon);
    expect(icons, findsWidgets);
  });
}
