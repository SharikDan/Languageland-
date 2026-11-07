abstract class KanaEvent {
  const KanaEvent();
}

class KanaInitEvent extends KanaEvent {
  final String mode; // 'hiragana' или 'katakana'
  const KanaInitEvent({required this.mode});
}

class KanaSwitchModeEvent extends KanaEvent {
  final String mode;
  const KanaSwitchModeEvent({required this.mode});
}

class KanaSelectEvent extends KanaEvent {
  final String selectedRomaji;
  const KanaSelectEvent({required this.selectedRomaji});
}

class KanaCheckEvent extends KanaEvent {
  const KanaCheckEvent();
}

class KanaNextEvent extends KanaEvent {
  const KanaNextEvent();
}

class KanaRetryEvent extends KanaEvent {
  const KanaRetryEvent();
}

// Вот это событие мы добавили для кнопки озвучки!
class KanaPlaySoundEvent extends KanaEvent {
  const KanaPlaySoundEvent();
}
