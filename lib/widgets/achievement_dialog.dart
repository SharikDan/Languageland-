import 'package:flutter/material.dart';
import 'package:ayas_languageland/models/achievement.dart';
class AchievementDialog extends StatelessWidget {
  final Achievement achievement;
  const AchievementDialog({super.key, required this.achievement});
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      title: const Text('🏆 Achievement!', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold)),
      content: Column(mainAxisSize: MainAxisSize.min, children: [const Icon(Icons.emoji_events, color: Colors.amber, size: 64), const SizedBox(height: 16), Text(achievement.title, textAlign: TextAlign.center, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)), const SizedBox(height: 8), Text(achievement.description, textAlign: TextAlign.center, style: const TextStyle(color: Colors.grey))]),
      actions: [Center(child: ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFE91E63), foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999))), onPressed: () => Navigator.pop(context), child: const Text('Great!')))],
    );
  }
}