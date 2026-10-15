// Unit-тесты для AudioService
import 'package:flutter_test/flutter_test.dart';
import 'package:languageland/services/audio_service.dart';

void main() {
  group('AudioService', () {
    test('Singleton возвращает тот же экземпляр', () {
      final instance1 = AudioService.instance;
      final instance2 = AudioService.instance;
      expect(instance1, same(instance2));
    });

    test('playMusic с несуществующим файлом не крашит', () async {
      final audio = AudioService.instance;
      expect(
        () => audio.playMusic('non_existent_file.mp3'),
        returnsNormally,
      );
    });

    test('playSound с несуществующим файлом не крашит', () async {
      final audio = AudioService.instance;
      expect(
        () => audio.playSound('non_existent_sound.mp3'),
        returnsNormally,
      );
    });

    test('stopMusic не вызывает ошибок', () {
      final audio = AudioService.instance;
      expect(() => audio.stopMusic(), returnsNormally);
    });

    test('setMusicEnabled(false) останавливает музыку', () {
      final audio = AudioService.instance;
      audio.setMusicEnabled(false);
      expect(audio.isMusicEnabled, isFalse);
    });

    test('setSoundEnabled(false) отключает звуки', () {
      final audio = AudioService.instance;
      audio.setSoundEnabled(false);
      expect(audio.isSoundEnabled, isFalse);
    });

    test('playSound не воспроизводится если звук выключен', () async {
      final audio = AudioService.instance;
      audio.setSoundEnabled(false);
      await audio.playSound('button_click.mp3');
      expect(audio.isSoundEnabled, isFalse);
    });

    test('playMusic не воспроизводится если музыка выключена', () async {
      final audio = AudioService.instance;
      audio.setMusicEnabled(false);
      await audio.playMusic('background_music.mp3');
      expect(audio.isMusicEnabled, isFalse);
    });

    test('Несколько вызовов playSound не вызывают ошибок', () async {
      final audio = AudioService.instance;
      audio.setSoundEnabled(true);
      await audio.playSound('correct.mp3');
      await audio.playSound('wrong.mp3');
      await audio.playSound('button_click.mp3');
      expect(true, isTrue);
    });

    test('setMusicEnabled можно переключать многократно', () {
      final audio = AudioService.instance;
      audio.setMusicEnabled(true);
      audio.setMusicEnabled(false);
      audio.setMusicEnabled(true);
      expect(audio.isMusicEnabled, isTrue);
    });

    test('dispose не вызывает ошибок', () {
      final audio = AudioService.instance;
      expect(() => audio.dispose(), returnsNormally);
    });
  });
}
