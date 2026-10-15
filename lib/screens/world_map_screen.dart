import 'package:flutter/material.dart';
import '../services/app_state.dart';
import '../theme/app_colors.dart';
import '../widgets/aya_image.dart';
import 'kana_screen.dart';

class WorldMapScreen extends StatelessWidget {
  const WorldMapScreen({super.key});

  static const _regions = [
    _R('hiragana', 'Хоккайдо', 'Катакана', 'ア', 0.72, 0.18, Color(0xFF9C27B0)),
    _R('hiragana', 'Хонсю', 'Хирагана', 'あ', 0.52, 0.42, Color(0xFFE91E63)),
    _R('kanji', 'Кюсю', 'Кандзи N5', '漢', 0.20, 0.72, Color(0xFF1976D2)),
    _R('hiragana', 'Кансай', 'Хирагана', 'あ', 0.42, 0.60, Color(0xFFE91E63)),
    _R('hiragana', 'Токио', 'Хирагана', 'あ', 0.60, 0.35, Color(0xFFE91E63)),
    _R('kanji', 'Сикоку', 'Кандзи N5', '漢', 0.35, 0.72, Color(0xFF1976D2)),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: LayoutBuilder(
        builder: (context, c) {
          final w = c.maxWidth, h = c.maxHeight;
          return Stack(
            children: [
              Positioned.fill(
                child: Image.asset(
                  'assets/map/japan.png',
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) =>
                      Container(color: surfaceAltOf(context)),
                ),
              ),
              Positioned.fill(
                child: Container(
                    color: Colors.black.withValues(
                        alpha: Theme.of(context).brightness == Brightness.dark
                            ? 0.4
                            : 0.15)),
              ),
              Positioned(
                left: 14,
                top: 10,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    color: surfaceOf(context).withValues(alpha: 0.92),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('🗾 Путешествие по Японии',
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: textOf(context))),
                      Text('Изучи 6 регионов!',
                          style: TextStyle(
                              fontSize: 10, color: textSubOf(context))),
                    ],
                  ),
                ),
              ),
              for (final r in _regions)
                Positioned(
                  left: w * r.x - 42,
                  top: h * r.y - 42,
                  child: _marker(context, r),
                ),
              Positioned(
                right: 12,
                bottom: 10,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: surfaceOf(context).withValues(alpha: 0.95),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('Прогресс',
                              style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: textSubOf(context))),
                          const SizedBox(height: 2),
                          Text('${_openCount()} / 6 регионов',
                              style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: textOf(context))),
                          const SizedBox(height: 4),
                          SizedBox(
                            width: 130,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: LinearProgressIndicator(
                                value: _openCount() / 6,
                                minHeight: 6,
                                backgroundColor: Theme.of(context).dividerColor,
                                valueColor: const AlwaysStoppedAnimation(
                                    Color(0xFFE91E63)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 6),
                    const AyaImage(emotion: 'neutral', size: 100),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  int _openCount() {
    final learned = AppState.cards.keys.where((k) => k.contains('_')).length;
    return (learned / 30).floor().clamp(1, 6);
  }

  Widget _marker(BuildContext context, _R r) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => KanaScreen(initialMode: r.mode)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: r.color,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 3),
              boxShadow: [
                BoxShadow(
                    color: r.color.withValues(alpha: 0.5), blurRadius: 12)
              ],
            ),
            child: Center(
              child: Text(r.symbol,
                  style: const TextStyle(
                      fontSize: 22,
                      color: Colors.white,
                      fontWeight: FontWeight.bold)),
            ),
          ),
          const SizedBox(height: 3),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
            decoration: BoxDecoration(
              color: surfaceOf(context).withValues(alpha: 0.95),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(r.title,
                style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: textOf(context))),
          ),
        ],
      ),
    );
  }
}

class _R {
  final String mode, title, subtitle, symbol;
  final double x, y;
  final Color color;
  const _R(this.mode, this.title, this.subtitle, this.symbol, this.x, this.y,
      this.color);
}