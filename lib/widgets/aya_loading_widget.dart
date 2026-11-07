import 'dart:math' as math;
import 'package:flutter/material.dart';

class AyaLoadingWidget extends StatelessWidget {
  final double progress;
  final String message;
  const AyaLoadingWidget({super.key, required this.progress, this.message = 'Loading...'});

  @override
  Widget build(BuildContext context) {
    const accent = Color(0xFFE91E63);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? const Color(0xFFEDEDF2) : const Color(0xFF2C2C2C);
    final subTextColor = isDark ? const Color(0xFFA0A0B0) : Colors.grey.shade600;
    final percentStr = (progress * 100).toStringAsFixed(1);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Круговой заполняющийся прогресс
          SizedBox(
            width: 160,
            height: 160,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Фоновое серое кольцо
                SizedBox(
                  width: 160,
                  height: 160,
                  child: CircularProgressIndicator(
                    value: 1.0,
                    strokeWidth: 12,
                    color: isDark ? const Color(0xFF23232F) : Colors.grey.shade200,
                  ),
                ),
                // Розовое заполняющееся кольцо
                SizedBox(
                  width: 160,
                  height: 160,
                  child: CircularProgressIndicator(
                    value: progress > 0 ? progress : null, // Если 0 - крутится бесконечно
                    strokeWidth: 12,
                    color: accent,
                    strokeCap: StrokeCap.round,
                  ),
                ),
                // Проценты внутри круга
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      progress > 0 ? '$percentStr%' : '...',
                      style: TextStyle(fontSize: 32, fontWeight: FontWeight.w900, color: accent),
                    ),
                    Text(
                      'Loading',
                      style: TextStyle(fontSize: 12, color: subTextColor, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          
          Text(
            message,
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: textColor),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          
          // Линейный прогресс-бар с процентами ВНУТРИ
          Container(
            width: 450, // Очень широкий
            height: 40,
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF23232F) : Colors.grey.shade200,
              borderRadius: BorderRadius.circular(999),
              border: Border.all(color: accent.withValues(alpha: 0.3), width: 2),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Заполняющаяся полоска
                ClipRRect(
                  borderRadius: BorderRadius.circular(999),
                  child: LinearProgressIndicator(
                    value: progress > 0 ? progress : null,
                    minHeight: 40,
                    backgroundColor: Colors.transparent,
                    color: accent,
                  ),
                ),
                // Текст внутри полоски
                Text(
                  progress > 0 ? 'Downloading: $percentStr%' : 'Connecting to server...',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    shadows: [Shadow(color: Colors.black45, blurRadius: 4)],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),
          Text(
            'Please keep the app open and screen on.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: subTextColor),
          ),
        ],
      ),
    );
  }
}