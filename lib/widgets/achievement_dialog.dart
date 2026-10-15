// Диалог "Достижение получено!"
import 'package:flutter/material.dart';
import '../models/achievement.dart';
import '../widgets/confetti_overlay.dart';
import '../services/audio_service.dart';

class AchievementDialog extends StatefulWidget {
  final Achievement achievement;

  const AchievementDialog({super.key, required this.achievement});

  @override
  State<AchievementDialog> createState() => _AchievementDialogState();
}

class _AchievementDialogState extends State<AchievementDialog> {
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
          maxHeight: 350,
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildHeader(context),
              const SizedBox(height: 16),
              _buildIcon(context),
              const SizedBox(height: 16),
              _buildTitle(context),
              const SizedBox(height: 8),
              _buildDescription(context),
              const SizedBox(height: 24),
              _buildButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Text(
      'Достижение получено!',
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primary,
          ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildIcon(BuildContext context) {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondaryContainer,
        shape: BoxShape.circle,
      ),
      child: Icon(
        _getIcon(),
        size: 48,
        color: Theme.of(context).colorScheme.onSecondaryContainer,
      ),
    );
  }

  IconData _getIcon() {
    switch (widget.achievement.iconName) {
      case 'star':
        return Icons.star;
      case 'fire':
        return Icons.local_fire_department;
      case 'book':
        return Icons.menu_book;
      case 'trophy':
        return Icons.emoji_events;
      default:
        return Icons.emoji_events;
    }
  }

  Widget _buildTitle(BuildContext context) {
    return Text(
      widget.achievement.title,
      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildDescription(BuildContext context) {
    return Text(
      widget.achievement.description,
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
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
      child: const Text('Отлично!'),
    );
  }
}