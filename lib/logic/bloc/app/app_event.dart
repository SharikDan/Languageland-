abstract class AppEvent {
  const AppEvent();
}

class AppInitEvent extends AppEvent {
  const AppInitEvent();
}

class AppToggleThemeEvent extends AppEvent {
  final bool isDark;
  const AppToggleThemeEvent({required this.isDark});
}

class AppToggleSoundEvent extends AppEvent {
  final bool enabled;
  const AppToggleSoundEvent({required this.enabled});
}

class AppToggleMusicEvent extends AppEvent {
  final bool enabled;
  const AppToggleMusicEvent({required this.enabled});
}

class AppToggleTTSEvent extends AppEvent {
  final bool enabled;
  const AppToggleTTSEvent({required this.enabled});
}
