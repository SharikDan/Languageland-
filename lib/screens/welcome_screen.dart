import 'package:flutter/material.dart';
import '../services/app_state.dart';
import '../widgets/aya_image.dart';
import 'onboarding_screen.dart';
import 'main_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                        text: const TextSpan(
                          style: TextStyle(
                              fontSize: 44,
                              fontWeight: FontWeight.w900,
                              letterSpacing: -1.5),
                          children: [
                            TextSpan(
                                text: 'LANGUAGE',
                                style: TextStyle(color: Color(0xFF2C2C2C))),
                            TextSpan(
                                text: 'LAND',
                                style: TextStyle(color: Color(0xFFE91E63))),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        '🌸  Учите японский с удовольствием  🌸',
                        style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF7A7A8C),
                            fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 32),
                      ElevatedButton(
                        onPressed: () => Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) => AppState.hasCompletedOnboarding
                                ? const MainScreen()
                                : const OnboardingScreen(),
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFE91E63),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 48, vertical: 16),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(999)),
                        ),
                        child: const Text('Начать',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ),
              ),
              const Expanded(
                flex: 4,
                child: Center(child: AyaImage(emotion: 'joy', size: 280)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}