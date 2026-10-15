// ИИ-объяснялка при ошибке: "Ошибка / Почему / Запомни"
import 'package:flutter/material.dart';

class AIExplanationPanel extends StatelessWidget {
  final String correctAnswer;
  final String userAnswer;
  final String explanation;
  final String tip;
  final VoidCallback onContinue;

  const AIExplanationPanel({
    super.key,
    required this.correctAnswer,
    required this.userAnswer,
    required this.explanation,
    required this.tip,
    required this.onContinue,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.errorContainer.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).colorScheme.error.withOpacity(0.3),
          width: 2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildHeader(context),
          const SizedBox(height: 16),
          _buildErrorSection(context),
          const SizedBox(height: 16),
          _buildWhySection(context),
          const SizedBox(height: 16),
          _buildTipSection(context),
          const SizedBox(height: 24),
          _buildButton(context),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        Icon(
          Icons.psychology,
          color: Theme.of(context).colorScheme.primary,
          size: 32,
        ),
        const SizedBox(width: 12),
        Text(
          'Ая объясняет',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildErrorSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Ошибка:',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.error,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Ваш ответ: $userAnswer',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        decoration: TextDecoration.lineThrough,
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Правильно: $correctAnswer',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildWhySection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Почему:',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          explanation,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }

  Widget _buildTipSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Запомни:',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondaryContainer.withOpacity(0.3),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Icon(
                Icons.lightbulb,
                color: Theme.of(context).colorScheme.secondary,
                size: 20,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  tip,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onContinue,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(999),
          ),
        ),
        child: const Text('Понятно, продолжаем!'),
      ),
    );
  }
}
