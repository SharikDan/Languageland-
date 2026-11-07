import 'package:flutter/material.dart';
import 'package:ayas_languageland/logic/services/app_state.dart';
import 'package:ayas_languageland/logic/services/app_localizations.dart';
import 'package:ayas_languageland/data/achievements_data.dart';
import 'package:ayas_languageland/widgets/aya_image.dart';
import 'package:ayas_languageland/logic/services/audio_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  void _showEditDialog() {
    final TextEditingController nameController = TextEditingController(text: AppState.userName);
    String selectedAvatar = AppState.userAvatar;
    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
            title: Text(AppLoc.t('edit_profile'), textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.bold)),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(controller: nameController, decoration: InputDecoration(labelText: AppLoc.t('name'), border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)))),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: ['joy', 'neutral', 'sad'].map((emotion) {
                    final isSelected = selectedAvatar == emotion;
                    return GestureDetector(
                      onTap: () { AudioService.playSound('tap.mp3'); setDialogState(() => selectedAvatar = emotion); },
                      child: Container(padding: const EdgeInsets.all(4), decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: isSelected ? const Color(0xFFE91E63) : Colors.transparent, width: 3)), child: AyaImage(emotion: emotion, size: 60)),
                    );
                  }).toList(),
                ),
              ],
            ),
            actions: [
              Row(
                children: [
                  Expanded(child: TextButton(onPressed: () => Navigator.pop(ctx), child: Text(AppLoc.t('cancel'), style: const TextStyle(color: Colors.grey)))),
                  Expanded(child: ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFE91E63), foregroundColor: Colors.white), onPressed: () { AudioService.playSound('tap.mp3'); setState(() { AppState.userName = nameController.text.trim(); AppState.userAvatar = selectedAvatar; AppState.save(); }); Navigator.pop(ctx); }, child: Text(AppLoc.t('save')))),
                ],
              )
            ],
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const accent = Color(0xFFE91E63);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF0F0F17) : const Color(0xFFFFF5F8);
    final cardColor = isDark ? const Color(0xFF1C1C28) : Colors.white;
    final textColor = isDark ? const Color(0xFFEDEDF2) : const Color(0xFF2C2C2C);
    final level = AppState.level, xp = AppState.xp, currentLevelXp = xp % 100, progress = currentLevelXp / 100;
    final displayName = AppState.userName.isEmpty ? AppLoc.t('student') : AppState.userName;

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(children: [const Icon(Icons.person, color: accent, size: 32), const SizedBox(width: 12), Text(AppLoc.t('profile_title'), style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: textColor))]),
                  IconButton(icon: const Icon(Icons.edit, color: accent, size: 28), onPressed: () { AudioService.playSound('tap.mp3'); _showEditDialog(); }),
                ],
              ),
              const SizedBox(height: 32),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 160, height: 160,
                    decoration: BoxDecoration(color: cardColor, shape: BoxShape.circle, border: Border.all(color: accent, width: 4), boxShadow: [BoxShadow(color: accent.withValues(alpha: 0.2), blurRadius: 20, offset: const Offset(0, 10))]),
                    clipBehavior: Clip.antiAlias,
                    child: Padding(padding: const EdgeInsets.all(8.0), child: AyaImage(emotion: AppState.userAvatar, size: 140)),
                  ),
                  const SizedBox(width: 32),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(displayName, style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: textColor)),
                        const SizedBox(height: 8),
                        Text(AppLoc.t('student_sub'), style: TextStyle(fontSize: 16, color: Colors.grey.shade600)),
                        const SizedBox(height: 24),
                        Row(children: [
                          _StatCard(icon: Icons.star_rounded, color: Colors.amber, title: AppLoc.t('level'), value: '$level'),
                          const SizedBox(width: 16),
                          _StatCard(icon: Icons.bolt_rounded, color: Colors.blue, title: AppLoc.t('xp'), value: '$xp'),
                          const SizedBox(width: 16),
                          _StatCard(icon: Icons.local_fire_department_rounded, color: Colors.orange, title: AppLoc.t('streak'), value: '${AppState.currentStreak} ${AppLoc.t('days')}'),
                        ]),
                        const SizedBox(height: 24),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(AppLoc.t('next_level'), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)), Text('$currentLevelXp / 100 XP', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: accent))]),
                            const SizedBox(height: 8),
                            ClipRRect(borderRadius: BorderRadius.circular(999), child: LinearProgressIndicator(value: progress, minHeight: 16, backgroundColor: Colors.grey.shade200, color: accent)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 48),
              Text(AppLoc.t('achievements'), style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: textColor)),
              const SizedBox(height: 16),
              GridView.builder(
                shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(maxCrossAxisExtent: 280, mainAxisSpacing: 16, crossAxisSpacing: 16, childAspectRatio: 2.2),
                itemCount: achievementsData.length,
                itemBuilder: (context, index) {
                  final ach = achievementsData[index];
                  final isUnlocked = AppState.unlockedAchievements.contains(ach.id);
                  final isEn = AppLoc.lang.value == 'en';
                  return _AchievementCard(title: isEn ? ach.titleEn : ach.title, description: isEn ? ach.descriptionEn : ach.description, isUnlocked: isUnlocked);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon; final Color color; final String title, value;
  const _StatCard({required this.icon, required this.color, required this.title, required this.value});
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? const Color(0xFF1C1C28) : Colors.white;
    final textColor = isDark ? const Color(0xFFEDEDF2) : const Color(0xFF2C2C2C);
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        decoration: BoxDecoration(color: cardColor, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: color.withValues(alpha: 0.1), blurRadius: 10, offset: const Offset(0, 4))]),
        child: Row(children: [Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: color.withValues(alpha: 0.1), shape: BoxShape.circle), child: Icon(icon, color: color, size: 24)), const SizedBox(width: 12), Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: TextStyle(fontSize: 12, color: Colors.grey.shade600, fontWeight: FontWeight.w600)), Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: textColor))])]),
      ),
    );
  }
}

class _AchievementCard extends StatelessWidget {
  final String title, description; final bool isUnlocked;
  const _AchievementCard({required this.title, required this.description, required this.isUnlocked});
  @override
  Widget build(BuildContext context) {
    const accent = Color(0xFFE91E63);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? const Color(0xFF1C1C28) : Colors.white;
    final textColor = isDark ? const Color(0xFFEDEDF2) : const Color(0xFF2C2C2C);
    final color = isUnlocked ? accent : Colors.grey.shade400;
    return Container(
      decoration: BoxDecoration(color: isUnlocked ? cardColor : (isDark ? const Color(0xFF13131C) : Colors.grey.shade100), borderRadius: BorderRadius.circular(16), border: Border.all(color: isUnlocked ? accent.withValues(alpha: 0.3) : Colors.transparent, width: 2)),
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Container(width: 48, height: 48, decoration: BoxDecoration(color: isUnlocked ? accent.withValues(alpha: 0.1) : Colors.grey.shade300, shape: BoxShape.circle), child: Icon(isUnlocked ? Icons.emoji_events : Icons.lock, color: color, size: 24)),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [Text(title, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: isUnlocked ? textColor : Colors.grey.shade600)), const SizedBox(height: 4), Text(description, maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 11, color: isUnlocked ? Colors.grey.shade600 : Colors.grey.shade500))])),
        ],
      ),
    );
  }
}