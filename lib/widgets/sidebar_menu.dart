// Боковое меню навигации (7 пунктов, компактное под landscape)
import 'package:flutter/material.dart';

class SidebarMenu extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const SidebarMenu({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final items = <(IconData, String)>[
      (Icons.map, 'Карта'),
      (Icons.translate, 'Слова'),
      (Icons.menu_book, 'Грамм.'),
      (Icons.replay, 'SRS'),
      (Icons.assignment, 'Квесты'),
      (Icons.person, 'Профиль'),
      (Icons.settings, 'Настр.'),
    ];

    return Container(
      width: 72,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(
          right: BorderSide(
            color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.15),
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 8),
              for (int i = 0; i < items.length; i++)
                _buildItem(context, i, items[i].$1, items[i].$2),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildItem(
    BuildContext context,
    int index,
    IconData icon,
    String label,
  ) {
    final isSelected = currentIndex == index;

    final color = isSelected
        ? Theme.of(context).colorScheme.primary
        : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6);

    return InkWell(
      onTap: () => onTap(index),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 7),
        decoration: BoxDecoration(
          color: isSelected
              ? Theme.of(context)
                  .colorScheme
                  .primaryContainer
                  .withValues(alpha: 0.4)
              : Colors.transparent,
          border: Border(
            left: BorderSide(
              color: isSelected
                  ? Theme.of(context).colorScheme.primary
                  : Colors.transparent,
              width: 3,
            ),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 9,
                color: color,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}