// Диалог "Новый уровень!"
import 'package:flutter/material.dart';
import '../widgets/confetti_overlay.dart';
import '../services/audio_service.dart';

class LevelUpDialog extends StatefulWidget {
  final int level;

  const LevelUpDialog({super.key, required this.level});

  @override
  State<LevelUpDialog> createState() => _LevelUpDialogState();
}

class _LevelUpDialogState extends State<LevelUpDialog> {
  bool _showConfetti = true;

  @override
  void initState() {
    super.initState();
    AudioService.instance.playSound('sounds/achievement.mp3');
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _buildDialog(context),
        ConfettiOverlay(
          isActive: _showConfetti,
          onComplete: () {
            if (mounted) {
              setState(() {
                _showConfetti = false;
              });
            }
          },
        ),
      ],
    );
  }

  Widget _buildDialog(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: 400,
          maxHeight: 300,
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildIcon(context),
              const SizedBox(height: 16),
              _buildTitle(context),
              const SizedBox(height: 8),
              _buildLevel(context),
              const SizedBox(height: 24),
              _buildButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIcon(BuildContext context) {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        shape: BoxShape.circle,
      ),
      child: Icon(
        Icons.star,
        size: 48,
        color: Theme.of(context).colorScheme.onPrimaryContainer,
      ),
    );
  }

  Widget _buildTitle(BuildContext context) {
    return Text(
      'Новый уровень!',
      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildLevel(BuildContext context) {
    return Text(
      'Уровень ${widget.level}',
      style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: Theme.of(context).colorScheme.primary,
            fontWeight: FontWeight.bold,
          ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () => Navigator.of(context).pop(),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(999),
        ),
      ),
      child: const Text('Продолжить'),
    );
  }
}