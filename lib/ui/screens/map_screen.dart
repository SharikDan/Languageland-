import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:ayas_languageland/logic/services/app_state.dart';
import 'package:ayas_languageland/logic/services/app_localizations.dart';
import 'package:ayas_languageland/logic/services/audio_service.dart';
import 'package:ayas_languageland/ui/screens/kana_screen.dart';
import 'package:ayas_languageland/ui/screens/vocab_screen.dart';
import 'package:ayas_languageland/ui/screens/grammar_screen.dart';
import 'package:ayas_languageland/ui/screens/review_screen.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const accent = Color(0xFFE91E63);
    final level = AppState.level;
    
    // Проверяем размер экрана / Check screen size
    final isMobile = MediaQuery.of(context).size.width < 800;
    final nodeSize = isMobile ? 50.0 : 70.0;
    final padding = isMobile ? 12.0 : 24.0;

    final stages = <_MapStage>[
      _MapStage(title: AppLoc.t('hiragana'), subtitle: AppLoc.t('hiragana_sub'), icon: Icons.text_fields, requiredLevel: 1, alignment: const Alignment(-0.8, 0.7), onTap: (ctx) => Navigator.push(ctx, MaterialPageRoute(builder: (_) => const KanaScreen(initialMode: 'hiragana')))),
      _MapStage(title: AppLoc.t('katakana'), subtitle: AppLoc.t('katakana_sub'), icon: Icons.translate, requiredLevel: 1, alignment: const Alignment(-0.4, 0.4), onTap: (ctx) => Navigator.push(ctx, MaterialPageRoute(builder: (_) => const KanaScreen(initialMode: 'katakana')))),
      _MapStage(title: AppLoc.t('vocab_title'), subtitle: AppLoc.t('vocab_sub'), icon: Icons.menu_book, requiredLevel: 2, alignment: const Alignment(0.1, -0.1), onTap: (ctx) => Navigator.push(ctx, MaterialPageRoute(builder: (_) => const VocabScreen()))),
      _MapStage(title: AppLoc.t('grammar_title'), subtitle: AppLoc.t('grammar_sub'), icon: Icons.school, requiredLevel: 3, alignment: const Alignment(0.3, -0.3), onTap: (ctx) => Navigator.push(ctx, MaterialPageRoute(builder: (_) => const GrammarScreen()))),
      _MapStage(title: AppLoc.t('srs_title'), subtitle: AppLoc.t('srs_sub'), icon: Icons.replay, requiredLevel: 4, alignment: const Alignment(0.65, -0.6), onTap: (ctx) => Navigator.push(ctx, MaterialPageRoute(builder: (_) => const ReviewScreen()))),
      _MapStage(title: AppLoc.t('master'), subtitle: AppLoc.t('master_sub'), icon: Icons.emoji_events, requiredLevel: 10, alignment: const Alignment(0.9, 0.3)),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFFFF5F8),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(isMobile ? 16 : 32, isMobile ? 12 : 24, isMobile ? 16 : 32, 8),
              child: Row(
                children: [
                  Icon(Icons.map_rounded, color: accent, size: isMobile ? 24 : 32),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(AppLoc.t('map_title'), style: TextStyle(fontSize: isMobile ? 18 : 26, fontWeight: FontWeight.bold, color: const Color(0xFF2C2C2C))),
                        Text(AppLoc.t('map_sub'), style: TextStyle(fontSize: isMobile ? 12 : 14, color: const Color(0xFF7A7A8C))),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: isMobile ? 12 : 16, vertical: isMobile ? 6 : 10),
                    decoration: BoxDecoration(color: accent.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(999)),
                    child: Text('${AppLoc.t('level')} $level', style: TextStyle(color: accent, fontWeight: FontWeight.bold, fontSize: isMobile ? 12 : 16)),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(padding),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(32),
                  child: Stack(
                    children: [
                      Positioned.fill(child: Image.asset('assets/map/japan.png', fit: BoxFit.cover, errorBuilder: (_, __, ___) => Container(color: Colors.blue.shade50))),
                      Positioned.fill(child: CustomPaint(painter: _MapPathPainter(points: stages.map((s) => s.alignment).toList()))),
                      ...stages.map((stage) {
                        final unlocked = level >= stage.requiredLevel;
                        final isFar = level < stage.requiredLevel - 1;
                        return Align(
                          alignment: stage.alignment,
                          child: AnimatedOpacity(
                            duration: const Duration(milliseconds: 500),
                            opacity: isFar ? 0.1 : 1.0,
                            child: _MapNode(
                              stage: stage, unlocked: unlocked, isFar: isFar, size: nodeSize, isMobile: isMobile,
                              onTap: (unlocked && stage.onTap != null) ? () { AudioService.playSound('tap.mp3'); stage.onTap!(context); } : null,
                            ),
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MapStage {
  final String title, subtitle; final IconData icon; final int requiredLevel; final Alignment alignment; final void Function(BuildContext)? onTap;
  const _MapStage({required this.title, required this.subtitle, required this.icon, required this.requiredLevel, required this.alignment, this.onTap});
}

class _MapNode extends StatelessWidget {
  final _MapStage stage; final bool unlocked, isFar, isMobile; final double size; final VoidCallback? onTap;
  const _MapNode({required this.stage, required this.unlocked, required this.isFar, required this.size, required this.isMobile, this.onTap});

  @override
  Widget build(BuildContext context) {
    const accent = Color(0xFFE91E63);
    final color = unlocked ? accent : Colors.grey.shade400;
    final iconData = unlocked ? stage.icon : (isFar ? Icons.question_mark_rounded : Icons.lock_rounded);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: size, height: size,
            decoration: BoxDecoration(
              color: unlocked ? Colors.white : Colors.black.withValues(alpha: 0.5),
              shape: BoxShape.circle,
              border: Border.all(color: color, width: unlocked ? 3 : 2),
              boxShadow: unlocked ? [BoxShadow(color: accent.withValues(alpha: 0.4), blurRadius: 8, offset: const Offset(0, 3))] : null,
            ),
            child: Icon(iconData, color: unlocked ? color : Colors.white70, size: size * 0.45),
          ),
        ),
        const SizedBox(height: 2),
        if (!isFar)
          Container(
            padding: EdgeInsets.symmetric(horizontal: isMobile ? 4 : 8, vertical: 2),
            decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.85), borderRadius: BorderRadius.circular(8)),
            child: Column(
              children: [
                Text(stage.title, textAlign: TextAlign.center, style: TextStyle(fontSize: isMobile ? 9 : 12, fontWeight: FontWeight.bold, color: unlocked ? const Color(0xFF2C2C2C) : Colors.grey.shade700)),
                if (!unlocked) Text('${AppLoc.t('level')} ${stage.requiredLevel}', style: TextStyle(fontSize: isMobile ? 7 : 9, color: Colors.grey.shade600)),
              ],
            ),
          ),
      ],
    );
  }
}

class _MapPathPainter extends CustomPainter {
  final List<Alignment> points;
  _MapPathPainter({required this.points});

  @override
  void paint(Canvas canvas, Size size) {
    if (points.length < 2) return;
    Offset getOffset(Alignment a) => Offset((a.x + 1) / 2 * size.width, (a.y + 1) / 2 * size.height);
    final centers = points.map(getOffset).toList();
    final paint = Paint()..color = const Color(0xFFE91E63).withValues(alpha: 0.6)..strokeWidth = 4..style = PaintingStyle.stroke..strokeCap = StrokeCap.round;
    for (int i = 0; i < centers.length - 1; i++) {
      final a = centers[i], b = centers[i + 1];
      final mid = Offset((a.dx + b.dx) / 2, (a.dy + b.dy) / 2 - 50);
      final path = Path()..moveTo(a.dx, a.dy)..quadraticBezierTo(mid.dx, mid.dy, b.dx, b.dy);
      _drawDashedPath(canvas, path, paint);
    }
  }

  void _drawDashedPath(Canvas canvas, Path path, Paint paint) {
    const dash = 10.0, gap = 8.0;
    for (final metric in path.computeMetrics()) {
      double dist = 0;
      while (dist < metric.length) {
        final len = math.min(dash, metric.length - dist);
        canvas.drawPath(metric.extractPath(dist, dist + len), paint);
        dist += len + gap;
      }
    }
  }
  @override
  bool shouldRepaint(covariant _MapPathPainter oldDelegate) => false;
}