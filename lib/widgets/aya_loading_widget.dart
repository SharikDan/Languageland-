import 'package:flutter/material.dart';
import 'package:ayas_languageland/widgets/aya_image.dart';

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
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 3))..repeat();
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
          // Анимация: Вращающееся кольцо + Пульсация
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Stack(
                alignment: Alignment.center,
                children: [
                  // Вращающееся пунктирное кольцо
                  Transform.rotate(
                    angle: _controller.value * 2 * 3.14159,
                    child: CustomPaint(
                      size: const Size(160, 160),
                      painter: _DashedCirclePainter(color: accent.withValues(alpha: 0.4)),
                    ),
                  ),
                  // Пульсирующий аватар
                  Transform.scale(
                    scale: 1.0 + (_controller.value * 0.1),
                    child: Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF1C1C28) : Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [BoxShadow(color: accent.withValues(alpha: 0.2), blurRadius: 20, spreadRadius: 5)],
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: const Padding(
                        padding: EdgeInsets.all(10),
                        child: AyaImage(emotion: 'neutral', size: 100),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 32),
          
          // Текст
          Text(
            widget.message,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textColor),
          ),
          const SizedBox(height: 16),
          
          // Прогресс-бар
          SizedBox(
            width: 300,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(999),
              child: TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: widget.progress),
                duration: const Duration(milliseconds: 500),
                builder: (context, value, child) {
                  return LinearProgressIndicator(
                    value: value > 0 ? value : null, // Если 0, показываем "бесконечную" загрузку
                    minHeight: 12,
                    backgroundColor: isDark ? const Color(0xFF23232F) : Colors.grey.shade200,
                    color: accent,
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 8),
          
          // Проценты
          if (widget.progress > 0)
            Text(
              '${(widget.progress * 100).toStringAsFixed(1)}%',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: accent),
            )
          else
            Text(
              'Please wait...',
              style: TextStyle(fontSize: 14, color: subTextColor),
            ),
        ],
      ),
    );
  }
}

// Кастомный "художник" для рисования пунктирного круга
class _DashedCirclePainter extends CustomPainter {
  final Color color;
  _DashedCirclePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    
    // Рисуем 12 пунктирных линий по кругу
    for (int i = 0; i < 12; i++) {
      final angle = (i * 3.14159 * 2) / 12;
      final start = Offset(center.dx + radius * 0.9 * _cos(angle), center.dy + radius * 0.9 * _sin(angle));
      final end = Offset(center.dx + radius * _cos(angle), center.dy + radius * _sin(angle));
      canvas.drawLine(start, end, paint);
    }
  }

  double _sin(double x) => (x % (2 * 3.14159)) < 3.14159 ? _mathSin(x) : -_mathSin(x - 3.14159);
  double _cos(double x) => _sin(x + 3.14159 / 2);
  double _mathSin(double x) {
    // Упрощенный синус, чтобы не импортировать dart:math
    return (4 / 3.14159) * x - (4 / (3.14159 * 3.14159)) * x * x.abs(); 
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}