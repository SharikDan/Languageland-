import 'package:flutter/material.dart';
import 'package:ayas_languageland/logic/services/app_state.dart';
import 'package:ayas_languageland/models/card_progress.dart';
import 'package:ayas_languageland/data/hiragana_data.dart';
import 'package:ayas_languageland/data/katakana_data.dart';
import 'package:ayas_languageland/models/kana_char.dart';
import 'package:ayas_languageland/logic/services/tts_service.dart';
import 'package:ayas_languageland/logic/services/app_localizations.dart';
import 'package:ayas_languageland/logic/services/audio_service.dart';

// Экран интервального повторения / Spaced Repetition System screen
class ReviewScreen extends StatefulWidget {
  const ReviewScreen({super.key});

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  List<CardProgress> _dueCards = [];
  int _currentIndex = 0;
  bool _showAnswer = false;

  @override
  void initState() {
    super.initState();
    _loadDueCards();
  }

  void _loadDueCards() {
    _dueCards = AppState.cards.values.where((c) => c.isDue).toList();
    _dueCards.shuffle();
    if (_dueCards.isNotEmpty) {
      _currentIndex = 0;
      _showAnswer = false;
    }
  }

  void _handleAnswer(bool correct) {
    AudioService.playSound(correct ? 'correct.mp3' : 'wrong.mp3');
    final card = _dueCards[_currentIndex];
    AppState.recordAnswer(card.cardId, correct);
    if (correct) AppState.addXP(5);
    setState(() {
      if (_currentIndex < _dueCards.length - 1) {
        _currentIndex++;
        _showAnswer = false;
      } else {
        _dueCards.clear();
      }
    });
  }

  KanaChar? _getKanaData(String cardId) {
    final parts = cardId.split('_');
    if (parts.length < 2) return null;
    final type = parts[0], char = parts[1];
    final list = type == 'katakana' ? katakanaData : hiraganaData;
    try {
      return list.firstWhere((k) => k.char == char);
    } catch (e) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    const accent = Color(0xFFE91E63);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF0F0F17) : const Color(0xFFFFF5F8);
    final cardColor = isDark ? const Color(0xFF1C1C28) : Colors.white;
    final textColor = isDark ? const Color(0xFFEDEDF2) : const Color(0xFF2C2C2C);
    final subTextColor = isDark ? const Color(0xFFA0A0B0) : Colors.grey.shade600;

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(32, 24, 32, 16),
              child: Row(
                children: [
                  const Icon(Icons.replay, color: accent, size: 32),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(AppLoc.t('srs_main_title'), style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: textColor)),
                      Text(AppLoc.t('srs_main_sub'), style: TextStyle(fontSize: 14, color: subTextColor)),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: _dueCards.isEmpty
                  ? _buildEmptyState(textColor, subTextColor, accent, cardColor)
                  : _buildReviewCard(textColor, subTextColor, accent, cardColor),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(Color textColor, Color subTextColor, Color accent, Color cardColor) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120, height: 120,
            decoration: BoxDecoration(color: accent.withValues(alpha: 0.1), shape: BoxShape.circle),
            child: Icon(Icons.check_circle_outline, size: 64, color: accent),
          ),
          const SizedBox(height: 24),
          Text(AppLoc.t('srs_done'), style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: textColor)),
          const SizedBox(height: 8),
          Text(AppLoc.t('srs_done_sub'), textAlign: TextAlign.center, style: TextStyle(fontSize: 16, color: subTextColor)),
          const SizedBox(height: 32),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: cardColor, foregroundColor: accent,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999), side: BorderSide(color: accent, width: 2)),
            ),
            onPressed: () => setState(() => _loadDueCards()),
            child: Text(AppLoc.t('update'), style: const TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewCard(Color textColor, Color subTextColor, Color accent, Color cardColor) {
    final card = _dueCards[_currentIndex];
    final kana = _getKanaData(card.cardId);
    if (kana == null) return const Center(child: Text('Неизвестный тип'));

    return Padding(
      padding: const EdgeInsets.fromLTRB(32, 0, 32, 32),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('${AppLoc.t('left')}: ${_dueCards.length - _currentIndex}', style: TextStyle(color: subTextColor, fontWeight: FontWeight.bold)),
              Text('${AppLoc.t('box')}: ${card.box} / 5', style: TextStyle(color: subTextColor, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _showAnswer = !_showAnswer),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: cardColor, borderRadius: BorderRadius.circular(32),
                  boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 20, offset: const Offset(0, 10))],
                  border: Border.all(color: accent.withValues(alpha: 0.2), width: 2),
                ),
                child: Center(
                  child: _showAnswer
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(kana.romajiRu, style: TextStyle(fontSize: 56, fontWeight: FontWeight.bold, color: textColor)),
                            const SizedBox(height: 8),
                            Text('(${kana.romaji})', style: TextStyle(fontSize: 24, color: subTextColor)),
                          ],
                        )
                      : Text(kana.char, style: TextStyle(fontSize: 140, fontWeight: FontWeight.bold, color: textColor)),
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          if (!_showAnswer)
            SizedBox(
              width: double.infinity, height: 60,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: accent.withValues(alpha: 0.1), foregroundColor: accent, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)), elevation: 0),
                onPressed: () => setState(() => _showAnswer = true),
                child: Text(AppLoc.t('show_answer'), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            )
          else
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 60,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.red.withValues(alpha: 0.1), foregroundColor: Colors.red, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)), elevation: 0),
                      onPressed: () => _handleAnswer(false),
                      child: Text(AppLoc.t('dont_remember'), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: SizedBox(
                    height: 60,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.green.withValues(alpha: 0.1), foregroundColor: Colors.green, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)), elevation: 0),
                      onPressed: () => _handleAnswer(true),
                      child: Text(AppLoc.t('remember'), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}