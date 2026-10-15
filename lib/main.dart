import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'services/app_state.dart';
import 'services/audio_service.dart';
import 'services/notification_service.dart';
import 'theme/app_theme.dart';
import 'screens/welcome_screen.dart';

void main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();

    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.transparent,
    ));

    await AppState.load();
    await AudioService.instance.initialize();
    await NotificationService.instance.init();
    await NotificationService.instance.scheduleDaily(hour: 19, minute: 0);

    runApp(const MyApp());
  } catch (e) {
    debugPrint('Error in main: $e');
    runApp(const MyApp());
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.paused:
      case AppLifecycleState.inactive:
      case AppLifecycleState.detached:
        AudioService.instance.stopMusic();
        AppState.save();
        break;
      case AppLifecycleState.resumed:
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
        break;
      case AppLifecycleState.hidden:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: AppState.themeNotifier,
      builder: (context, isDark, child) {
        return MaterialApp(
          title: 'Languageland',
          debugShowCheckedModeBanner: false,
          theme: isDark ? AppTheme.dark : AppTheme.light,
          home: const WelcomeScreen(),
        );
      },
    );
  }
}