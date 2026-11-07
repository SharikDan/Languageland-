import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ayas_languageland/logic/services/app_state.dart' as global_state;
import 'package:ayas_languageland/logic/services/audio_service.dart';
import 'app_event.dart';
import 'app_state.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  AppBloc() : super(const AppLoading()) {
    on<AppInitEvent>(_onInit);
    on<AppToggleThemeEvent>(_onToggleTheme);
    on<AppToggleSoundEvent>(_onToggleSound);
    on<AppToggleMusicEvent>(_onToggleMusic);
    on<AppToggleTTSEvent>(_onToggleTTS);
  }

  Future<void> _onInit(AppInitEvent event, Emitter<AppState> emit) async {
    try {
      await global_state.AppState.load();
      await AudioService.init();

      emit(AppReady(
        isDarkMode: global_state.AppState.isDarkTheme,
        isSoundEnabled: AudioService.isSoundEnabled,
        isMusicEnabled: AudioService.isMusicEnabled,
        isTTSEnabled: AudioService.isTTSEnabled,
      ));
    } catch (e) {
      emit(AppError(message: 'Ошибка инициализации: $e'));
    }
  }

  void _onToggleTheme(AppToggleThemeEvent event, Emitter<AppState> emit) {
    if (state is AppReady) {
      global_state.AppState.toggleTheme();
      emit((state as AppReady).copyWith(isDarkMode: event.isDark));
    }
  }

  void _onToggleSound(AppToggleSoundEvent event, Emitter<AppState> emit) {
    if (state is AppReady) {
      AudioService.toggleSound();
      emit((state as AppReady).copyWith(isSoundEnabled: event.enabled));
    }
  }

  void _onToggleMusic(AppToggleMusicEvent event, Emitter<AppState> emit) {
    if (state is AppReady) {
      AudioService.toggleMusic();
      emit((state as AppReady).copyWith(isMusicEnabled: event.enabled));
    }
  }

  void _onToggleTTS(AppToggleTTSEvent event, Emitter<AppState> emit) {
    if (state is AppReady) {
      AudioService.toggleTTS();
      emit((state as AppReady).copyWith(isTTSEnabled: event.enabled));
    }
  }
}
