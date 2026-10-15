import 'package:flutter/material.dart';
import 'dart:math';
import '../data/hiragana_data.dart';
import '../data/katakana_data.dart';
import '../data/kanji_data.dart';
import '../models/kana_char.dart';
import '../models/kanji_item.dart';
import '../services/app_state.dart';
import '../services/tts_service.dart';
import '../services/audio_service.dart';
import '../services/notification_service.dart';
import '../theme/app_colors.dart';
import '../widgets/ai_explanation_panel.dart';
import '../widgets/aya_image.dart';
import '../widgets/level_up_dialog.dart';
import '../widgets/achievement_dialog.dart';

class KanaScreen extends StatefulWidget {
  final String initialMode;
  const KanaScreen({super.key, this.initialMode = 'hiragana'});

  @override
  State<KanaScreen> createState() => _KanaScreenState();
}

class _KanaScreenState extends State<KanaScreen> {
  late String _mode;
  int _idx = 0;
  String? _selected;
  bool? _correct;
  bool _showError = false;
  List<dynamic> _data = [];
  List<String> _options = [];
  final _rnd = Random();

  @override
  void initState() {
    super.initState();
    _mode = widget.initialMode;
    _load();
    _gen();
    AudioService.instance.playMusic('music/honshu.mp3');
  }

  void _load() {
    _data = _mode == 'hiragana'
        ? hiraganaData
        : _mode == 'katakana'
            ? katakanaData
            : kanjiData;
  }

  void _switchMode(String m) {
    setState(() {
      _mode = m;
      _idx = 0;
      _selected = null;
      _correct = null;
      _showError = false;
      _load();
      _gen();
    });
  }

  void _gen() {
    if (_data.isEmpty) return;
    final cur = _data[_idx];
    final ans = _mode == 'kanji'
        ? (cur as KanjiItem).meaning
        : (cur as KanaChar).romajiRu;
    _options = [ans];
    while (_options.length < 4) {
      final r = _data[_rnd.nextInt(_data.length)];
      final o = _mode == 'kanji'
          ? (r as KanjiItem).meaning
          : (r as KanaChar).romajiRu;
      if (!_options.contains(o)) _options.add(o);
    }
    _options.shuffle();
  }

  String get _curChar => _mode == 'kanji'
      ? (_data[_idx] as KanjiItem).char
      : (_data[_idx] as KanaChar).char;

  String get _curAnswer => _mode == 'kanji'
      ? (_data[_idx] as KanjiItem).meaning
      : (_data[_idx] as KanaChar).romajiRu;

  @override
  Widget build(BuildContext context) {
    if (_showError) return _buildErrorScreen();
    return _buildLesson();
  }

  Widget _buildLesson() {
    return Scaffold(
      backgroundColor: bgOf(context),
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  children: [
                    Expanded(flex: 5, child: _buildQuestionCard()),
                    const SizedBox(width: 8),
                    Expanded(flex: 5, child: _buildOptions()),
                    const SizedBox(width: 8),
                    Expanded(flex: 3, child: _buildRightPanel()),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    final total = _data.length;
    final pct = ((_idx + 1) / total * 100).round();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      color: surfaceOf(context),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(Icons.arrow_back, size: 20, color: textOf(context)),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
          const SizedBox(width: 8),
          _modeChip('hiragana', 'あ Хирагана'),
          const SizedBox(width: 4),
          _modeChip('katakana', 'ア Катакана'),
          const SizedBox(width: 4),
          _modeChip('kanji', '漢 Кандзи'),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Урок ${_idx + 1} из $total',
                    style: TextStyle(fontSize: 10, color: textSubOf(context))),
                const SizedBox(height: 2),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: (_idx + 1) / total,
                    minHeight: 6,
                    backgroundColor: Theme.of(context).dividerColor,
                    valueColor:
                        const AlwaysStoppedAnimation(Color(0xFFE91E63)),
                  ),
                ),
              ],
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

  Widget _modeChip(String m, String label) {
    final active = _mode == m;
    return GestureDetector(
      onTap: () => _switchMode(m),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: active ? const Color(0xFFE91E63) : surfaceAltOf(context),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: active ? Colors.white : textSubOf(context),
            )),
      ),
    );
  }

  Widget _buildQuestionCard() {
    return Container(
      decoration: BoxDecoration(
        color: surfaceOf(context),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.06), blurRadius: 12)
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(_curChar,
                    style: TextStyle(
                        fontSize: 140,
                        fontWeight: FontWeight.bold,
                        color: textOf(context))),
              ),
            ),
          ),
          IconButton(
            onPressed: () => TtsService.instance.speak(_curChar),
            icon: const Icon(Icons.volume_up,
                size: 26, color: Color(0xFFE91E63)),
          ),
        ],
      ),
    );
  }

  Widget _buildOptions() {
    return Column(
      children: [
        Text('Что это за символ? Выберите правильный ответ',
            style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: textOf(context)),
            textAlign: TextAlign.center),
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
            child: Text(opt,
                style: TextStyle(
                    fontSize: 15, fontWeight: FontWeight.bold, color: fg),
                textAlign: TextAlign.center),
          ),
        ),
      ),
    );
  }

  Widget _buildRightPanel() {
    return Column(
      children: [
        _stat('🔥', '${AppState.currentStreak}', 'дней'),
        const SizedBox(height: 4),
        _stat('⭐', '${AppState.xp}', 'очков'),
        const SizedBox(height: 4),
        _stat('🎖', '${AppState.level}', 'уровень'),
        const Spacer(),
        AyaImage(
          emotion: _correct == null
              ? 'neutral'
              : (_correct! ? 'triumph' : 'thoughtful'),
          size: 110,
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

  void _check() {
    final ok = _selected == _curAnswer;
    setState(() => _correct = ok);
    AppState.recordAnswer(AppState.cardId(_mode, _curChar), ok);
    AudioService.instance
        .playSound(ok ? 'sounds/correct.mp3' : 'sounds/wrong.mp3');
    if (ok) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _checkDialogs());
    }
  }

  void _checkDialogs() {
    if (AppState.pendingLevelUp != null) {
      final lvl = AppState.pendingLevelUp!;
      AppState.pendingLevelUp = null;
      showDialog(context: context, builder: (_) => LevelUpDialog(level: lvl));
    }
    if (AppState.pendingAchievement != null) {
      final a = AppState.pendingAchievement!;
      AppState.pendingAchievement = null;
      NotificationService.instance.showAchievementUnlocked(a.title);
      showDialog(
          context: context, builder: (_) => AchievementDialog(achievement: a));
    }
  }

  void _next() {
    if (_idx < _data.length - 1) {
      setState(() {
        _idx++;
        _selected = null;
        _correct = null;
        _gen();
      });
    } else {
      Navigator.pop(context);
    }
  }

  Widget _buildErrorScreen() {
    return Scaffold(
      backgroundColor: bgOf(context),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Expanded(
                flex: 5,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: const BoxDecoration(
                            color: Color(0xFFE53935),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.close,
                              color: Colors.white, size: 28),
                        ),
                        const SizedBox(width: 10),
                        Text('Почти!',
                            style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: textOf(context))),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text('Это не совсем верно. Давай разберёмся вместе!',
                        style:
                            TextStyle(fontSize: 13, color: textSubOf(context))),
                    const SizedBox(height: 16),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: surfaceOf(context),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        children: [
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(_curChar,
                                style: TextStyle(
                                    fontSize: 80,
                                    fontWeight: FontWeight.bold,
                                    color: textOf(context))),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.close,
                                  color: Colors.red, size: 18),
                              const SizedBox(width: 4),
                              Flexible(
                                child: Text('Ты: $_selected',
                                    style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.red,
                                        decoration:
                                            TextDecoration.lineThrough)),
                              ),
                              const SizedBox(width: 12),
                              const Icon(Icons.check,
                                  color: Colors.green, size: 18),
                              const SizedBox(width: 4),
                              Flexible(
                                child: Text('Верно: $_curAnswer',
                                    style: const TextStyle(
                                        fontSize: 14,
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
                              padding:
                                  const EdgeInsets.symmetric(vertical: 14),
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
                          correctAnswer: _curAnswer,
                          userAnswer: _selected ?? '',
                          explanation: _mode == 'kanji'
                              ? 'Кунъёми: ${(_data[_idx] as KanjiItem).kunyomi}, онъёми: ${(_data[_idx] as KanjiItem).onyomi}'
                              : 'Этот знак читается как "$_curAnswer".',
                          tip: _mode == 'kanji'
                              ? 'Пример: ${(_data[_idx] as KanjiItem).examples.first}'
                              : 'Попробуй написать знак несколько раз — так запомнится форма.',
                          onContinue: () => setState(() {
                            _showError = false;
                            _selected = null;
                            _correct = null;
                          }),
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    const AyaImage(emotion: 'thoughtful', size: 90),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}