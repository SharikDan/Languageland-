import 'package:flutter/material.dart';
import '../services/app_state.dart';
import '../theme/app_colors.dart';

class ReviewScreen extends StatefulWidget {
  const ReviewScreen({super.key});
  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  List<String> _due = [];

  @override
  void initState() {
    super.initState();
    _due = AppState.getDueCardIds();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('SRS Повторение',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold, color: textOf(context))),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                    child: _card('К повторению', '${_due.length}', Colors.red)),
                const SizedBox(width: 8),
                Expanded(
                    child: _card('Всего карточек',
                        '${AppState.cards.length}', Colors.blue)),
              ],
            ),
            const SizedBox(height: 12),
            Text('Коробки SRS',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: textOf(context))),
            const SizedBox(height: 8),
            for (int i = 1; i <= 5; i++) _boxRow(i),
          ],
        ),
      ),
    );
  }

  Widget _card(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Text(value,
              style: TextStyle(
                  fontSize: 24, fontWeight: FontWeight.bold, color: color)),
          const SizedBox(height: 4),
          Text(label, style: TextStyle(fontSize: 11, color: textOf(context))),
        ],
      ),
    );
  }

  Widget _boxRow(int box) {
    final count = AppState.cards.values.where((c) => c.box == box).length;
    final intervals = ['1 день', '3 дня', '7 дней', '14 дней', '30 дней'];
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: surfaceAltOf(context),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Center(
                child: Text('$box',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: textOf(context))),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Коробка $box',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                          color: textOf(context))),
                  Text('Интервал: ${intervals[box - 1]}',
                      style: TextStyle(
                          fontSize: 11, color: textSubOf(context))),
                ],
              ),
            ),
            Text('$count',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary)),
          ],
        ),
      ),
    );
  }
}