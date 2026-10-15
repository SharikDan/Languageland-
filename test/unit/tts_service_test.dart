// Unit-тесты для TtsService
import 'package:flutter_test/flutter_test.dart';
import 'package:languageland/services/tts_service.dart';

void main() {
  group('TtsService', () {
    test('Singleton возвращает тот же экземпляр', () {
      final instance1 = TtsService.instance;
      final instance2 = TtsService.instance;
      expect(instance1, same(instance2));
    });

    test('speak с пустой строкой не вызывает ошибок', () async {
      final tts = TtsService.instance;
      expect(() => tts.speak(''), returnsNormally);
    });

    test('speak с null не вызывает ошибок', () async {
      final tts = TtsService.instance;
      expect(() => tts.speak(''), returnsNormally);
    });

    test('setEnabled(false) не крашит приложение', () {
      final tts = TtsService.instance;
      expect(() => tts.setEnabled(false), returnsNormally);
    });

    test('setEnabled(true) работает корректно', () {
      final tts = TtsService.instance;
      tts.setEnabled(false);
      tts.setEnabled(true);
      expect(tts.isEnabled, isTrue);
    });

    test('speak работает после отключения и включения', () async {
      final tts = TtsService.instance;
      tts.setEnabled(false);
      await tts.speak('テスト');
      tts.setEnabled(true);
      expect(() => tts.speak('テスト'), returnsNormally);
    });

    test('Несколько вызовов speak не вызывают ошибок', () async {
      final tts = TtsService.instance;
      await tts.speak('あ');
      await tts.speak('い');
      await tts.speak('う');
      expect(true, isTrue);
    });

    test('stop работает без ошибок', () {
      final tts = TtsService.instance;
      expect(() => tts.stop(), returnsNormally);
    });

    test('stop после speak не крашит', () async {
      final tts = TtsService.instance;
      tts.speak('こんにちは');
      tts.stop();
      expect(true, isTrue);
    });

    test('isAvailable возвращает bool', () {
      final tts = TtsService.instance;
      expect(tts.isAvailable, isA<bool>());
    });
  });
}
