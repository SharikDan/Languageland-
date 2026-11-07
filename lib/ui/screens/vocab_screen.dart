import 'package:flutter/material.dart';
import 'package:ayas_languageland/data/vocab_data.dart';
import 'package:ayas_languageland/models/vocab_word.dart';
import 'package:ayas_languageland/logic/services/tts_service.dart';
import 'package:ayas_languageland/logic/services/app_localizations.dart';
import 'package:ayas_languageland/logic/services/audio_service.dart';

// Экран словаря / Vocabulary screen
class VocabScreen extends StatefulWidget {
  const VocabScreen({super.key});

  @override
  State<VocabScreen> createState() => _VocabScreenState();
}

class _VocabScreenState extends State<VocabScreen> {
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    const accent = Color(0xFFE91E63);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF0F0F17) : const Color(0xFFFFF5F8);
    final cardColor = isDark ? const Color(0xFF1C1C28) : Colors.white;
    final textColor = isDark ? const Color(0xFFEDEDF2) : const Color(0xFF2C2C2C);
    final subTextColor = isDark ? const Color(0xFFA0A0B0) : Colors.grey.shade600;

    final filteredWords = vocabData.where((word) {
      final query = _searchQuery.toLowerCase();
      return word.japanese.contains(query) || word.romaji.toLowerCase().contains(query) || word.russian.toLowerCase().contains(query) || word.english.toLowerCase().contains(query);
    }).toList();

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
                  const Icon(Icons.translate, color: accent, size: 32),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(AppLoc.t('vocab_title_screen'), style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: textColor)),
                        Text(AppLoc.t('vocab_sub_screen'), style: TextStyle(fontSize: 14, color: subTextColor)),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 300, height: 44,
                    child: TextField(
                      controller: _searchController,
                      onChanged: (value) => setState(() => _searchQuery = value),
                      style: TextStyle(color: textColor),
                      decoration: InputDecoration(
                        hintText: AppLoc.t('search_hint'),
                        hintStyle: TextStyle(fontSize: 14, color: subTextColor),
                        prefixIcon: const Icon(Icons.search, size: 20, color: accent),
                        filled: true,
                        fillColor: cardColor,
                        contentPadding: const EdgeInsets.symmetric(vertical: 0),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(999), borderSide: BorderSide.none),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: filteredWords.isEmpty
                  ? Center(child: Text(AppLoc.t('not_found'), style: TextStyle(fontSize: 18, color: subTextColor)))
                  : GridView.builder(
                      padding: const EdgeInsets.fromLTRB(32, 8, 32, 32),
                      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(maxCrossAxisExtent: 350, mainAxisSpacing: 16, crossAxisSpacing: 16, childAspectRatio: 2.5),
                      itemCount: filteredWords.length,
                      itemBuilder: (context, index) => _VocabCard(word: filteredWords[index], cardColor: cardColor, textColor: textColor, subTextColor: subTextColor),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _VocabCard extends StatelessWidget {
  final VocabWord word;
  final Color cardColor, textColor, subTextColor;
  const _VocabCard({required this.word, required this.cardColor, required this.textColor, required this.subTextColor});

  @override
  Widget build(BuildContext context) {
    const accent = Color(0xFFE91E63);
    final isEn = AppLoc.lang.value == 'en';
    final translation = isEn ? word.english : word.russian;

    return Container(
      decoration: BoxDecoration(color: cardColor, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 10, offset: const Offset(0, 4))]),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            AudioService.playSound('tap.mp3');
            TtsService.instance.speak(word.japanese);
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(word.japanese, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: textColor)),
                      Text(word.romaji, style: TextStyle(fontSize: 13, color: subTextColor, fontStyle: FontStyle.italic)),
                      const SizedBox(height: 4),
                      Text(translation, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: accent)),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.volume_up_rounded, color: accent, size: 28),
                  onPressed: () {
                    AudioService.playSound('tap.mp3');
                    TtsService.instance.speak(word.japanese);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}