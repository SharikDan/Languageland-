// Анимация конфетти при достижениях
import 'package:flutter/material.dart';
import 'dart:math';

class ConfettiOverlay extends StatefulWidget {
  final bool isActive;
  final VoidCallback? onComplete;

  const ConfettiOverlay({
    super.key,
    required this.isActive,
    this.onComplete,
  });

  @override
  State<ConfettiOverlay> createState() => _ConfettiOverlayState();
}

class _ConfettiOverlayState extends State<ConfettiOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<_ConfettiParticle> _particles = [];
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    _controller.addStatusListener(
      (status) {
        if (status == AnimationStatus.completed) {
          widget.onComplete?.call();
        }
      },
    );

    _initParticles();
  }

  void _initParticles() {
    for (int i = 0; i < 50; i++) {
      _particles.add(
        _ConfettiParticle(
          color: _randomColor(),
          x: _random.nextDouble(),
          y: -0.1,
          velocityX: (_random.nextDouble() - 0.5) * 2,
          velocityY: _random.nextDouble() * 2 + 1,
          rotation: _random.nextDouble() * 2 * pi,
          size: _random.nextDouble() * 8 + 4,
        ),
      );
    }
  }

  Color _randomColor() {
    final colors = [
      Colors.red,
      Colors.blue,
      Colors.green,
      Colors.yellow,
      Colors.purple,
      Colors.orange,
      Colors.pink,
    ];
    return colors[_random.nextInt(colors.length)];
  }

  @override
  void didUpdateWidget(ConfettiOverlay oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isActive && !oldWidget.isActive) {
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isActive) {
      return const SizedBox.shrink();
    }

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          painter: _ConfettiPainter(
            particles: _particles,
            progress: _controller.value,
          ),
          child: const SizedBox.expand(),
        );
      },
    );
  }
}

class _ConfettiParticle {
  final Color color;
  final double x;
  final double y;
  final double velocityX;
  final double velocityY;
  final double rotation;
  final double size;

  _ConfettiParticle({
    required this.color,
    required this.x,
    required this.y,
    required this.velocityX,
    required this.velocityY,
    required this.rotation,
    required this.size,
  });
}

class _ConfettiPainter extends CustomPainter {
  final List<_ConfettiParticle> particles;
  final double progress;

  _ConfettiPainter({
    required this.particles,
    required this.progress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (final particle in particles) {
      final x = particle.x * size.width + particle.velocityX * progress * 100;
      final y = particle.y * size.height + particle.velocityY * progress * size.height;

      if (y > size.height) {
        continue;
      }

      final paint = Paint()
        ..color = particle.color.withOpacity(1.0 - progress)
        ..style = PaintingStyle.fill;

      canvas.save();
      canvas.translate(x, y);
      canvas.rotate(particle.rotation * progress * 4);
      canvas.drawRect(
        Rect.fromCenter(
          center: Offset.zero,
          width: particle.size,
          height: particle.size,
        ),
        paint,
      );
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(_ConfettiPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
