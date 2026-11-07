import 'package:flutter/material.dart';
class LevelUpDialog extends StatelessWidget {
  final int level;
  const LevelUpDialog({super.key, required this.level});
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      title: const Text('🎉 Level Up!', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold)),
      content: Column(mainAxisSize: MainAxisSize.min, children: [const Icon(Icons.star, color: Colors.amber, size: 64), const SizedBox(height: 16), Text('You reached level $level!', style: const TextStyle(fontSize: 20))]),
      actions: [Center(child: ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFE91E63), foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999))), onPressed: () => Navigator.pop(context), child: const Text('Awesome!')))],
    );
  }
}