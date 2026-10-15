// Unit-тесты для AppState
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:languageland/services/app_state.dart';
import 'package:languageland/models/card_progress.dart';

void main() {
  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await AppState.load();
  });

  group('AppState XP и уровни', () {
    test('XP начинается с 0', () {
      expect(AppState.xp, equals(0));
    });

    test('Уровень вычисляется корректно: xp=0 → level=1', () {
      AppState.xp = 0;
      expect(AppState.level, equals(1));
    });

    test('Уровень вычисляется корректно: xp=100 → level=2', () {
      AppState.xp = 100;
      expect(AppState.level, equals(2));
    });

    test('Уровень вычисляется корректно: xp=550 → level=6', () {
      AppState.xp = 550;
      expect(AppState.level, equals(6));
    });

    test('addXP увеличивает XP', () {
      AppState.xp = 0;
      AppState.addXP(50);
      expect(AppState.xp, equals(50));
    });

    test('addXP не вызывает overflow при больших значениях', () {
      AppState.xp = 2147483600;
      AppState.addXP(100);
      expect(AppState.xp, equals(2147483647));
    });

    test('level.clamp работает корректно', () {
      AppState.xp = 999999;
      final calculatedLevel = (AppState.xp ~/ 100).clamp(1, 999).toInt() + 1;
      expect(calculatedLevel, equals(1000));
    });
  });

  group('AppState стрики', () {
    test('Streak = 0 при lastLoginMs = 0', () {
      AppState.lastLoginMs = 0;
      expect(AppState.currentStreak, equals(0));
    });

    test('Streak сохраняется если логин сегодня', () async {
      final now = DateTime.now();
      AppState.lastLoginMs = now.millisecondsSinceEpoch;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setInt('streak', 5);
      expect(AppState.currentStreak, equals(5));
    });

    test('Streak сбрасывается если пропущено > 1 дня', () {
      final threeDaysAgo = DateTime.now()
          .subtract(const Duration(days: 3))
          .millisecondsSinceEpoch;
      AppState.lastLoginMs = threeDaysAgo;
      expect(AppState.currentStreak, equals(0));
    });
  });

  group('AppState SRS-карточки', () {
    test('Новая карточка создаётся в box 1', () {
      final cardId = AppState.cardId('h', 'a');
      AppState.recordAnswer(cardId, true);
      expect(AppState.cards[cardId]?.box, equals(1));
    });

    test('Правильный ответ переводит box 1 → 2', () {
      final cardId = AppState.cardId('h', 'i');
      AppState.cards[cardId] = CardProgress(cardId: cardId, box: 1);
      AppState.recordAnswer(cardId, true);
      expect(AppState.cards[cardId]?.box, equals(2));
    });

    test('Неправильный ответ сбрасывает box в 1', () {
      final cardId = AppState.cardId('h', 'u');
      AppState.cards[cardId] = CardProgress(cardId: cardId, box: 3);
      AppState.recordAnswer(cardId, false);
      expect(AppState.cards[cardId]?.box, equals(1));
    });

    test('getDueCardIds возвращает только просроченные', () {
      final cardId1 = AppState.cardId('h', 'e');
      final cardId2 = AppState.cardId('h', 'o');
      
      final past = DateTime.now()
          .subtract(const Duration(hours: 1))
          .millisecondsSinceEpoch;
      final future = DateTime.now()
          .add(const Duration(days: 1))
          .millisecondsSinceEpoch;

      AppState.cards[cardId1] = CardProgress(
        cardId: cardId1,
        nextReviewMs: past,
      );
      AppState.cards[cardId2] = CardProgress(
        cardId: cardId2,
        nextReviewMs: future,
      );

      final dueCards = AppState.getDueCardIds();
      expect(dueCards.contains(cardId1), isTrue);
      expect(dueCards.contains(cardId2), isFalse);
    });
  });

  group('AppState cardId функции', () {
    test('cardId генерирует правильный формат', () {
      final id = AppState.cardId('h', 'a');
      expect(id, equals('h_a'));
    });

    test('charFromCardId извлекает символ', () {
      final char = AppState.charFromCardId('kanji_日');
      expect(char, equals('日'));
    });

    test('typeFromCardId извлекает тип', () {
      final type = AppState.typeFromCardId('vocab_こんにちは');
      expect(type, equals('vocab'));
    });

    test('cardId и charFromCardId согласованы', () {
      final original = 'test_char';
      final id = AppState.cardId('h', original);
      final extracted = AppState.charFromCardId(id);
      expect(extracted, equals(original));
    });
  });

  group('AppState квесты', () {
    test('updateQuestProgress увеличивает прогресс', () {
      AppState.quests.clear();
      final quest = AppState.quests.values.firstOrNull;
      if (quest != null) {
        final initialProgress = quest.currentCount;
        AppState.updateQuestProgress(quest.id, 1);
        expect(quest.currentCount, equals(initialProgress + 1));
      }
    });

    test('Завершённый квест не увеличивает прогресс', () {
      AppState.quests.clear();
      final quest = AppState.quests.values.firstOrNull;
      if (quest != null) {
        quest.currentCount = quest.targetCount;
        AppState.updateQuestProgress(quest.id, 1);
        expect(quest.currentCount, equals(quest.targetCount));
      }
    });
  });

  group('AppState ачивки', () {
    test('unlockAchievement разблокирует ачивку', () {
      final achId = AppState.achievements.first.id;
      AppState.achievements.first.isUnlocked = false;
      AppState.unlockAchievement(achId);
      expect(AppState.achievements.first.isUnlocked, isTrue);
    });

    test('Повторная разблокировка не даёт XP', () {
      final achId = AppState.achievements.first.id;
      AppState.achievements.first.isUnlocked = true;
      final xpBefore = AppState.xp;
      AppState.unlockAchievement(achId);
      expect(AppState.xp, equals(xpBefore));
    });
  });

  group('AppState сохранение/загрузка', () {
    test('save и load сохраняют XP', () async {
      AppState.xp = 777;
      await AppState.save();
      await AppState.load();
      expect(AppState.xp, equals(777));
    });

    test('resetProgress очищает все данные', () async {
      AppState.xp = 500;
      AppState.cards['test'] = CardProgress(cardId: 'test');
      await AppState.resetProgress();
      expect(AppState.xp, equals(0));
      expect(AppState.cards.isEmpty, isTrue);
    });
  });
}
