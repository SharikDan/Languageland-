import 'package:flutter/material.dart';
import 'dart:math';
import '../data/vocab_data.dart';
import '../models/vocab_word.dart';
import '../services/app_state.dart';
import '../services/tts_service.dart';
import '../services/audio_service.dart';
import '../theme/app_colors.dart';
import '../widgets/ai_explanation_panel.dart';
import '../widgets/aya_image.dart';

class VocabScreen extends StatefulWidget {
  const VocabScreen({super.key});
  @override
  State<VocabScreen> createState() => _VocabScreenState();
}

class _VocabScreenState extends State<VocabScreen> {
  bool _isLearning = false;
  int _idx = 0;
  String? _selected;
  bool? _correct;
  bool _showError = false;
  List<String> _options = [];
  final _rnd = Random();

  @override
  Widget build(BuildContext context) {
    if (_isLearning) return _buildLearning();
    return _buildSelection();
  }

  Widget _buildSelection() {
    final learned = vocabData.where((w) {
      final id = AppState.cardId('vocab', w.japanese);
      return AppState.cards.containsKey(id);
    }).length;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Изучение лексики',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold, color: textOf(context))),
            const SizedBox(height: 8),
            Expanded(
              flex: 2,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    'Базовый словарь из 80 самых важных японских слов. '
                    'Учите слова и фразы для повседневной жизни.',
                    style: TextStyle(fontSize: 13, color: textOf(context)),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              flex: 3,
              child: Row(
                children: [
                  Expanded(
                    child: _statCard('Всего слов', '${vocabData.length}',
                        Icons.book, Colors.orange),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _statCard(
                        'Изучено', '$learned', Icons.check_circle, Colors.green),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => setState(() {
                  _isLearning = true;
                  _idx = 0;
                  _selected = null;
                  _correct = null;
                  _showError = false;
                  _gen();
                }),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE91E63),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(999)),
                ),
                child: const Text('Начать практику',
                    style: TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _statCard(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 28, color: color),
          const SizedBox(height: 6),
          Text(value,
              style: TextStyle(
                  fontSize: 22, fontWeight: FontWeight.bold, color: color)),
          const SizedBox(height: 2),
          Text(label, style: TextStyle(fontSize: 11, color: textOf(context))),
        ],
      ),
    );
  }

  Widget _buildLearning() {
    if (vocabData.isEmpty) return const Center(child: Text('Нет слов'));
    final cur = vocabData[_idx];

    return SafeArea(
      child: Column(
        children: [
          _buildTopBar(),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: _showError
                  ? _buildErrorScreen(cur)
                  : Row(
                      children: [
                        Expanded(flex: 5, child: _questionCard(cur)),
                        const SizedBox(width: 8),
                        Expanded(flex: 5, child: _optionsColumn()),
                        const SizedBox(width: 8),
                        Expanded(flex: 3, child: _rightPanel(cur)),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopBar() {
    final total = vocabData.length;
    final pct = ((_idx + 1) / total * 100).round();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      color: surfaceOf(context),
      child: Row(
        children: [
          IconButton(
            onPressed: () => setState(() => _isLearning = false),
            icon: Icon(Icons.arrow_back, size: 20, color: textOf(context)),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
          const SizedBox(width: 8),
          Text('Словарь',
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: textOf(context))),
          const SizedBox(width: 12),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: (_idx + 1) / total,
                minHeight: 6,
                backgroundColor: Theme.of(context).dividerColor,
                valueColor: const AlwaysStoppedAnimation(Color(0xFFE91E63)),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text('$pct%',
              style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFE91E63))),
        ],
      ),
    );
  }

  Widget _questionCard(VocabWord w) {
    return Container(
      decoration: BoxDecoration(
        color: surfaceOf(context),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text(w.japanese,
                        style: TextStyle(
                            fontSize: 56,
                            fontWeight: FontWeight.bold,
                            color: textOf(context))),
                    const SizedBox(height: 6),
                    Text(w.romaji,
                        style: TextStyle(
                            fontSize: 16, color: textSubOf(context))),
                  ],
                ),
              ),
            ),
          ),
          IconButton(
            onPressed: () => TtsService.instance.speak(w.japanese),
            icon: const Icon(Icons.volume_up,
                size: 26, color: Color(0xFFE91E63)),
          ),
        ],
      ),
    );
  }

  Widget _optionsColumn() {
    return Column(
      children: [
        Text('Что означает слово?',
            style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: textOf(context))),
        const SizedBox(height: 8),
        Expanded(
          child: GridView.count(
            crossAxisCount: 2,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            childAspectRatio: 2.0,
            physics: const NeverScrollableScrollPhysics(),
            children: _options.map(_optionBtn).toList(),
          ),
        ),
      ],
    );
  }

  Widget _optionBtn(String opt) {
    final sel = _selected == opt;
    final result = _correct != null && sel;
    Color bg = surfaceOf(context);
    Color border = Theme.of(context).dividerColor;
    Color fg = textOf(context);

    if (result) {
      bg = _correct!
          ? Colors.green.withValues(alpha: 0.15)
          : Colors.red.withValues(alpha: 0.15);
      border = _correct! ? Colors.green : Colors.red;
      fg = _correct! ? Colors.green[400]! : Colors.red[400]!;
    } else if (sel) {
      bg = Theme.of(context).colorScheme.primaryContainer;
      border = const Color(0xFFE91E63);
    }

    return Material(
      color: bg,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap:
            _correct == null ? () => setState(() => _selected = opt) : null,
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: border, width: 2),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(6),
              child: Text(opt,
                  style: TextStyle(
                      fontSize: 13, fontWeight: FontWeight.bold, color: fg),
                  textAlign: TextAlign.center),
            ),
          ),
        ),
      ),
    );
  }

  Widget _rightPanel(VocabWord w) {
    return Column(
      children: [
        _stat('🔥', '${AppState.currentStreak}', 'дней'),
        const SizedBox(height: 4),
        _stat('⭐', '${AppState.xp}', 'очков'),
        const Spacer(),
        AyaImage(
          emotion: _correct == null
              ? 'neutral'
              : (_correct! ? 'triumph' : 'thoughtful'),
          size: 100,
        ),
        const SizedBox(height: 6),
        if (_selected != null && _correct == null)
          _bigBtn('Проверить', const Color(0xFFE91E63), _check)
        else if (_correct == true)
          _bigBtn('Дальше', Colors.green, _next)
        else if (_correct == false)
          _bigBtn('Понятно', const Color(0xFFE91E63),
              () => setState(() => _showError = true)),
      ],
    );
  }

  Widget _stat(String i, String v, String l) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: surfaceOf(context),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(i, style: const TextStyle(fontSize: 13)),
            const SizedBox(width: 4),
            Text(v,
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: textOf(context))),
            const SizedBox(width: 2),
            Text(l, style: TextStyle(fontSize: 9, color: textSubOf(context))),
          ],
        ),
      );

  Widget _bigBtn(String t, Color c, VoidCallback cb) => SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: cb,
          style: ElevatedButton.styleFrom(
            backgroundColor: c,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 12),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(999)),
          ),
          child:
              Text(t, style: const TextStyle(fontWeight: FontWeight.bold)),
        ),
      );

  Widget _buildErrorScreen(VocabWord w) {
    return Row(
      children: [
        Expanded(
          flex: 5,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: const BoxDecoration(
                      color: Color(0xFFE53935),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.close,
                        color: Colors.white, size: 24),
                  ),
                  const SizedBox(width: 8),
                  Text('Почти!',
                      style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: textOf(context))),
                ],
              ),
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: surfaceOf(context),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Column(
                  children: [
                    Text(w.japanese,
                        style: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                            color: textOf(context))),
                    const SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Flexible(
                          child: Text('Ты: $_selected',
                              style: const TextStyle(
                                  fontSize: 13,
                                  color: Colors.red,
                                  decoration: TextDecoration.lineThrough)),
                        ),
                        const SizedBox(width: 12),
                        Flexible(
                          child: Text('Верно: ${w.russian}',
                              style: const TextStyle(
                                  fontSize: 13,
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => setState(() {
                        _selected = null;
                        _correct = null;
                        _showError = false;
                      }),
                      child: const Text('Ещё раз',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() => _showError = false);
                        _next();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFE91E63),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(999)),
                      ),
                      child: const Text('Дальше',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          flex: 4,
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: AIExplanationPanel(
                    correctAnswer: w.russian,
                    userAnswer: _selected ?? '',
                    explanation:
                        '«${w.japanese}» (${w.romaji}) — это «${w.russian}».',
                    tip: 'Пример: ${w.exampleSentence}',
                    onContinue: () => setState(() {
                      _showError = false;
                      _selected = null;
                      _correct = null;
                    }),
                  ),
                ),
              ),
              const SizedBox(height: 6),
              const AyaImage(emotion: 'thoughtful', size: 80),
            ],
          ),
        ),
      ],
    );
  }

  void _gen() {
    if (vocabData.isEmpty) return;
    final cur = vocabData[_idx];
    _options = [cur.russian];
    while (_options.length < 4) {
      final r = vocabData[_rnd.nextInt(vocabData.length)];
      if (!_options.contains(r.russian)) _options.add(r.russian);
    }
    _options.shuffle();
  }

  void _check() {
    final ok = _selected == vocabData[_idx].russian;
    setState(() => _correct = ok);
    AppState.recordAnswer(
        AppState.cardId('vocab', vocabData[_idx].japanese), ok);
    AudioService.instance
        .playSound(ok ? 'sounds/correct.mp3' : 'sounds/wrong.mp3');
    if (!ok) setState(() => _showError = true);
  }

  void _next() {
    if (_idx < vocabData.length - 1) {
      setState(() {
        _idx++;
        _selected = null;
        _correct = null;
        _showError = false;
        _gen();
      });
    } else {
      setState(() => _isLearning = false);
    }
  }
}