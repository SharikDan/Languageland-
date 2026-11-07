import 'package:flutter/material.dart';
import 'package:ayas_languageland/data/grammar_data.dart';
import 'package:ayas_languageland/models/grammar_phrase.dart';
import 'package:ayas_languageland/logic/services/app_localizations.dart';

class GrammarScreen extends StatelessWidget {
  const GrammarScreen({super.key});
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
            Padding(padding: const EdgeInsets.fromLTRB(32, 24, 32, 16), child: Row(children: [const Icon(Icons.menu_book, color: accent, size: 32), const SizedBox(width: 12), Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(AppLoc.t('grammar_title'), style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: textColor)), Text(AppLoc.t('grammar_sub'), style: TextStyle(fontSize: 14, color: subTextColor))])])),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.fromLTRB(32, 8, 32, 32),
                itemCount: grammarData.length,
                itemBuilder: (context, index) {
                  final phrase = grammarData[index];
                  final isEn = AppLoc.lang.value == 'en';
                  return _GrammarCard(phrase: phrase, russianText: isEn ? phrase.english : phrase.russian, explanation: isEn ? phrase.explanationEn : phrase.explanation, examples: isEn ? phrase.examplesEn : phrase.examples, cardColor: cardColor, textColor: textColor, subTextColor: subTextColor, accent: accent, isDark: isDark);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GrammarCard extends StatelessWidget {
  final GrammarPhrase phrase; final String russianText, explanation; final List<String> examples;
  final Color cardColor, textColor, subTextColor, accent; final bool isDark;
  const _GrammarCard({required this.phrase, required this.russianText, required this.explanation, required this.examples, required this.cardColor, required this.textColor, required this.subTextColor, required this.accent, required this.isDark});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04), blurRadius: 10, offset: const Offset(0, 4))]),
      child: Material(
        color: cardColor, borderRadius: BorderRadius.circular(16), clipBehavior: Clip.antiAlias,
        child: Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
            iconColor: accent, collapsedIconColor: subTextColor, tilePadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            title: Text(phrase.japanese, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: textColor)),
            subtitle: Text(russianText, style: TextStyle(fontSize: 15, color: accent, fontWeight: FontWeight.w600)),
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Divider(color: isDark ? Colors.grey.shade800 : Colors.grey.shade200), const SizedBox(height: 8),
                    Text('${AppLoc.t('meaning')}:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: subTextColor)), const SizedBox(height: 4),
                    Text(explanation, style: TextStyle(fontSize: 15, color: textColor, height: 1.4)), const SizedBox(height: 16),
                    Text('${AppLoc.t('examples')}:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: subTextColor)), const SizedBox(height: 8),
                    ...examples.map((example) => Padding(padding: const EdgeInsets.only(bottom: 8), child: Container(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12), decoration: BoxDecoration(color: isDark ? const Color(0xFF23232F) : const Color(0xFFFFF5F8), borderRadius: BorderRadius.circular(12), border: Border.all(color: isDark ? Colors.grey.shade800 : Colors.pink.shade50)), child: Row(children: [Icon(Icons.subdirectory_arrow_right, color: accent, size: 16), const SizedBox(width: 8), Expanded(child: Text(example, style: TextStyle(fontSize: 14, color: textColor)))])))),
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