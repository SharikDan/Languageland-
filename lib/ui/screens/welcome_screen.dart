import 'package:flutter/material.dart';
import 'package:ayas_languageland/widgets/aya_image.dart';
import 'package:ayas_languageland/ui/screens/main_screen.dart';
import 'package:ayas_languageland/logic/services/audio_service.dart';

// Приветственный экран / Welcome screen
class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const accentColor = Color(0xFFE91E63);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFFFF5F8), Color(0xFFFFE4E9)],
          ),
        ),
        child: SafeArea(
          child: Row(
            children: [
              Expanded(
                flex: 6,
                child: Padding(
                  padding: const EdgeInsets.all(40.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "AYA'S",
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800, letterSpacing: 4, color: accentColor),
                      ),
                      const SizedBox(height: 4),
                      RichText(
                        text: const TextSpan(
                          style: TextStyle(fontSize: 56, fontWeight: FontWeight.w900, letterSpacing: -1.5, height: 1.1),
                          children: [
                            TextSpan(text: 'LANGUAGE', style: TextStyle(color: Color(0xFF2C2C2C))),
                            TextSpan(text: 'LAND', style: TextStyle(color: accentColor)),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        '🌸 Learn Japanese with pleasure 🌸',
                        style: TextStyle(fontSize: 16, color: Colors.black.withValues(alpha: 0.6), fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 48),
                      ElevatedButton(
                        onPressed: () {
                          AudioService.playMusic('main_menu.mp3');
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const MainScreen()));
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: accentColor,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 56, vertical: 20),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
                          elevation: 6,
                          shadowColor: accentColor.withValues(alpha: 0.4),
                        ),
                        child: const Text('Start Learning', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ),
              ),
              const Expanded(
                flex: 4,
                child: Center(child: AyaImage(emotion: 'joy', size: 380)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}