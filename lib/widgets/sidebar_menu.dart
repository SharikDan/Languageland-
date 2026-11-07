import 'package:flutter/material.dart';
import 'package:ayas_languageland/logic/services/app_localizations.dart';
import 'package:ayas_languageland/logic/services/audio_service.dart';

class SidebarMenu extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  const SidebarMenu({super.key, required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF1C1C28) : const Color(0xFFFCE4EC);
    const accent = Color(0xFFE91E63);

    // Адаптивная ширина меню (уже на телефоне) / Adaptive width
    final isMobile = MediaQuery.of(context).size.width < 800;
    final sidebarWidth = isMobile ? 64.0 : 80.0;
    final iconSize = isMobile ? 22.0 : 26.0;

    final items = [
      (Icons.map_rounded, AppLoc.t('map')), (Icons.text_fields, AppLoc.t('kana')), (Icons.translate, AppLoc.t('kanji')),
      (Icons.translate, AppLoc.t('vocab')), (Icons.menu_book, AppLoc.t('grammar')), (Icons.replay, AppLoc.t('srs')),
      (Icons.assignment, AppLoc.t('quests')), (Icons.smart_toy, AppLoc.t('chat')), (Icons.person, AppLoc.t('profile')), (Icons.settings, AppLoc.t('settings')),
    ];

    return Container(
      width: sidebarWidth,
      height: double.infinity,
      color: bgColor,
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 8),
              for (int i = 0; i < items.length; i++) 
                _buildItem(context, i, items[i].$1, items[i].$2, isDark, accent, iconSize, isMobile),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildItem(BuildContext context, int index, IconData icon, String label, bool isDark, Color accent, double iconSize, bool isMobile) {
    final isSelected = currentIndex == index;
    final color = isSelected ? accent : (isDark ? Colors.grey.shade500 : Colors.grey.shade600);
    
    return InkWell(
      onTap: () { AudioService.playSound('tap.mp3'); onTap(index); },
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: isMobile ? 6 : 10),
        decoration: BoxDecoration(border: Border(left: BorderSide(color: isSelected ? accent : Colors.transparent, width: 4))),
        child: Column(
          children: [
            Icon(icon, color: color, size: iconSize),
            const SizedBox(height: 2),
            Text(
              label, 
              textAlign: TextAlign.center, 
              style: TextStyle(fontSize: isMobile ? 8 : 10, color: color, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}