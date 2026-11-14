import 'package:flutter/material.dart';

class DailyRewardDialog extends StatelessWidget {
  const DailyRewardDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      title: const Text('🎁 Ежедневная награда!', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.card_giftcard, color: Colors.amber, size: 80),
          const SizedBox(height: 16),
          const Text('С возвращением!', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text('Ты получаешь +50 XP за то, что зашел сегодня!', textAlign: TextAlign.center, style: TextStyle(color: Colors.grey.shade600)),
        ],
      ),
      actions: [
        Center(child: ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFE91E63), foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999))),
          onPressed: () => Navigator.pop(context),
          child: const Text('Забрать!'),
        ))
      ],
    );
  }
}