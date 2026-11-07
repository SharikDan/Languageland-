import 'package:flutter/material.dart';

class AyaImage extends StatelessWidget {
  final String emotion;
  final double size;

  const AyaImage({super.key, this.emotion = 'neutral', this.size = 200});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/aya/$emotion.png',
      width: size,
      height: size,
      fit: BoxFit.contain,
      // Если картинки нет, покажет японский флаг, чтобы не ломать верстку
      errorBuilder: (_, __, ___) => SizedBox(
        width: size,
        height: size,
        child: const Center(
          child: Text('🎌', style: TextStyle(fontSize: 100)),
        ),
      ),
    );
  }
}
