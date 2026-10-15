import 'package:flutter/material.dart';
import '../data/grammar_data.dart';
import '../models/grammar_phrase.dart';
import '../services/app_state.dart';
import '../theme/app_colors.dart';
import '../widgets/aya_image.dart';

class GrammarScreen extends StatefulWidget {
  const GrammarScreen({super.key});
  @override
  State<GrammarScreen> createState() => _GrammarScreenState();
}

class _GrammarScreenState extends State<GrammarScreen> {
  int? _selectedIndex;

  int get _learnedHiragana => AppState.cards.keys
      .where((k) => k.startsWith('hiragana_'))
      .where((k) => AppState.cards[k]!.box >= 2)
      .length;

  int get _learnedKatakana => AppState.cards.keys
      .where((k) => k.startsWith('katakana_'))
      .where((k) => AppState.cards[k]!.box >= 2)
      .length;

  int get _unlockedCount {
    if (_learnedHiragana < 10) return 0;
    if (_learnedKatakana < 5) return 5;
    if (_learnedHiragana < 30) return 8;
    return grammarData.length;
  }

  @override
  Widget build(BuildContext context) {
    if (_selectedIndex != null) return _buildDetail();
    return _buildList();
  }

  Widget _buildList() {
    final unlocked = _unlockedCount;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text('Грамматика',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold, color: textOf(context))),
                const SizedBox(width: 10),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text('$unlocked / ${grammarData.length}',
                      style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFE91E63))),
                ),
              ],
            ),
            const SizedBox(height: 6),
            if (unlocked < grammarData.length)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(8),
                margin: const EdgeInsets.only(bottom: 6),
                decoration: BoxDecoration(
                  color: Colors.orange.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.lock_outline,
                        size: 16, color: Colors.orange),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(_lockHint(),
                          style: TextStyle(
                              fontSize: 11, color: textOf(context))),
                    ),
                  ],
                ),
              ),
            Expanded(
              child: ListView.builder(
                itemCount: grammarData.length,
                itemBuilder: (context, i) {
                  final isLocked = i >= unlocked;
                  return _item(grammarData[i], i, isLocked);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _lockHint() {
    if (_learnedHiragana < 10) {
      return 'Выучи 10 знаков хираганы — сейчас $_learnedHiragana/10';
    }
    if (_learnedKatakana < 5) {
      return 'Выучи 5 знаков катаканы — сейчас $_learnedKatakana/5';
    }
    if (_learnedHiragana < 30) {
      return 'Выучи 30 знаков хираганы — сейчас $_learnedHiragana/30';
    }
    return '';
  }

  Widget _item(GrammarPhrase p, int i, bool locked) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Material(
        color: locked ? surfaceAltOf(context) : surfaceOf(context),
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: locked ? null : () => setState(() => _selectedIndex = i),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: locked
                        ? textSubOf(context)
                        : const Color(0xFFE91E63),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    locked ? Icons.lock : Icons.book,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(p.japanese,
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: locked
                                  ? textSubOf(context)
                                  : textOf(context))),
                      Text(p.russian,
                          style: TextStyle(
                              fontSize: 11,
                              color: locked
                                  ? textSubOf(context)
                                  : textSubOf(context))),
                    ],
                  ),
                ),
                if (!locked)
                  Icon(Icons.chevron_right, size: 20, color: textOf(context)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetail() {
    final p = grammarData[_selectedIndex!];
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                IconButton(
                  onPressed: () => setState(() => _selectedIndex = null),
                  icon: Icon(Icons.arrow_back, color: textOf(context)),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(p.japanese,
                      style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: textOf(context))),
                ),
                const AyaImage(emotion: 'joy', size: 60),
              ],
            ),
            const SizedBox(height: 8),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(p.russian,
                              style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFFE91E63))),
                          const SizedBox(height: 6),
                          Text(p.explanation,
                              style: TextStyle(
                                  fontSize: 12, color: textOf(context))),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text('Примеры:',
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: textOf(context))),
                    const SizedBox(height: 6),
                    for (final ex in p.examples)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 6),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: surfaceOf(context),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(ex,
                              style: TextStyle(
                                  fontSize: 13, color: textOf(context))),
                        ),
                      ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          AppState.recordAnswer(
                              AppState.cardId('grammar', p.japanese), true);
                          setState(() => _selectedIndex = null);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFE91E63),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(999)),
                        ),
                        child: const Text('Отметить как изученное',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}