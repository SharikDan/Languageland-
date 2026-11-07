import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gemma/flutter_gemma.dart'; // <--- ДОБАВИЛИ ИМПОРТ
import 'package:ayas_languageland/logic/services/app_state.dart';
import 'package:ayas_languageland/logic/services/app_localizations.dart';
import 'package:ayas_languageland/logic/services/audio_service.dart';
import 'package:ayas_languageland/logic/services/tts_service.dart';
import 'package:ayas_languageland/logic/services/notification_service.dart';
import 'package:ayas_languageland/theme/app_theme.dart';
import 'package:ayas_languageland/ui/screens/welcome_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Скрываем системные панели и фиксируем ландшафт
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

  try {
    // Инициализируем движок нейросети (ОБЯЗАТЕЛЬНО для flutter_gemma)
    await FlutterGemma.initialize();
    
    // Инициализируем остальные сервисы
    await AppState.load();
    await AudioService.init();
    await TtsService.instance.init();
    await NotificationService.instance.init();
  } catch (e) {
    debugPrint('Init error: $e');
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: AppState.themeNotifier,
      builder: (context, isDark, child) {
        return ValueListenableBuilder<String>(
          valueListenable: AppLoc.lang,
          builder: (context, langCode, child) {
            return MaterialApp(
              title: "Aya's Languageland",
              debugShowCheckedModeBanner: false,
              theme: isDark ? AppTheme.dark : AppTheme.light,
              home: const WelcomeScreen(),
            );
          },
        );
      },
    );
  }
}