import 'dart:math' as math;
import 'package:flutter/material.dart';

class AyaLoadingWidget extends StatefulWidget {
  final double progress;
  final String message;
  const AyaLoadingWidget({super.key, required this.progress, this.message = 'Loading...'});

  @override
  State<AyaLoadingWidget> createState() => _AyaLoadingWidgetState();
}

class _AyaLoadingWidgetState extends State<AyaLoadingWidget> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 2))..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const accent = Color(0xFFE91E63);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? const Color(0xFFEDEDF2) : const Color(0xFF2C2C2C);
    final subTextColor = isDark ? const Color(0xFFA0A0B0) : Colors.grey.shade600;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Анимация: Вращающееся кольцо
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Transform.rotate(
                angle: _controller.value * 2 * math.pi,
                child: CustomPaint(
                  size: const Size(140, 140),
                  painter: _SpinnerPainter(color: accent),
                ),
              );
            },
          ),
          const SizedBox(height: 32),
          
          Text(
            widget.message,
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: textColor),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          
          // Огромный красивый прогресс-бар
          Container(
            width: 400, // Очень широкий, чтобы было видно на весь экран
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF23232F) : Colors.grey.shade200,
              borderRadius: BorderRadius.circular(999),
              border: Border.all(color: accent.withValues(alpha: 0.3), width: 2),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(999),
              child: LinearProgressIndicator(
                value: widget.progress > 0 ? widget.progress : null, // Если 0 - бесконечная загрузка
                minHeight: 20,
                backgroundColor: Colors.transparent,
                color: accent,
              ),
            ),
          ),
          const SizedBox(height: 16),
          
          // Красивый текст с процентами
          if (widget.progress > 0)
            Text(
              '${(widget.progress * 100).toStringAsFixed(1)}%',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: accent),
            )
          else
            Text(
              'Connecting to server...',
              style: TextStyle(fontSize: 18, color: subTextColor, fontWeight: FontWeight.w600),
            ),

          const SizedBox(height: 24),
          Text(
            'Please keep the app open and screen on.\nThe download will take a few minutes.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: subTextColor),
          ),
        ],
      ),
    );
  }
}

// Кастомный "художник" для рисования красивых спиннеров
class _SpinnerPainter extends CustomPainter {
  final Color color;
  _SpinnerPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    
    // Рисуем дугу (3/4 круга)
    final rect = Rect.fromCircle(center: center, radius: radius);
    canvas.drawArc(rect, 0, math.pi * 1.5, false, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}