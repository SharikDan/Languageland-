import 'package:flutter/material.dart';
import '../services/app_state.dart';
import '../models/quest_def.dart';
import '../theme/app_colors.dart';

class QuestsScreen extends StatefulWidget {
  const QuestsScreen({super.key});
  @override
  State<QuestsScreen> createState() => _QuestsScreenState();
}

class _QuestsScreenState extends State<QuestsScreen> {
  @override
  Widget build(BuildContext context) {
    final active =
        AppState.quests.values.where((q) => !q.isCompleted).toList();
    final completed =
        AppState.quests.values.where((q) => q.isCompleted).toList();

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Квесты',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold, color: textOf(context))),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                    child: _statCard('Активные', '${active.length}',
                        Icons.play_arrow, Colors.blue)),
                const SizedBox(width: 8),
                Expanded(
                    child: _statCard('Завершённые', '${completed.length}',
                        Icons.check_circle, Colors.green)),
              ],
            ),
            const SizedBox(height: 12),
            Expanded(child: _list(active, completed)),
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
        children: [
          Icon(icon, size: 24, color: color),
          const SizedBox(height: 4),
          Text(value,
              style: TextStyle(
                  fontSize: 20, fontWeight: FontWeight.bold, color: color)),
          Text(label, style: TextStyle(fontSize: 11, color: textOf(context))),
        ],
      ),
    );
  }

  Widget _list(List<QuestDef> active, List<QuestDef> completed) {
    return ListView(
      children: [
        if (active.isNotEmpty) ...[
          Text('Активные',
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: textOf(context))),
          const SizedBox(height: 8),
          ...active.map((q) => _card(q, false)),
        ],
        if (completed.isNotEmpty) ...[
          const SizedBox(height: 12),
          Text('Завершённые',
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: textOf(context))),
          const SizedBox(height: 8),
          ...completed.map((q) => _card(q, true)),
        ],
      ],
    );
  }

  Widget _card(QuestDef q, bool done) {
    final progress = q.currentCount / q.targetCount;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: done
              ? Colors.green.withValues(alpha: 0.1)
              : surfaceOf(context),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  done ? Icons.check_circle : Icons.flag,
                  color: done ? Colors.green : const Color(0xFFE91E63),
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(q.title,
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: textOf(context))),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(q.description,
                style: TextStyle(fontSize: 11, color: textSubOf(context))),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: progress.clamp(0.0, 1.0),
                      minHeight: 6,
                      backgroundColor: Theme.of(context).dividerColor,
                      valueColor: AlwaysStoppedAnimation(
                          done ? Colors.green : const Color(0xFFE91E63)),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text('${q.currentCount}/${q.targetCount}',
                    style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: textOf(context))),
                const SizedBox(width: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.orange.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text('+${q.reward} XP',
                      style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}