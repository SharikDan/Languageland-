// Экран профиля: уровень, XP, стрик, достижения
import 'package:flutter/material.dart';
import '../services/app_state.dart';
import '../widgets/stat_card.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context),
            const SizedBox(height: 24),
            _buildProfileCard(context),
            const SizedBox(height: 24),
            _buildStatsGrid(context),
            const SizedBox(height: 24),
            _buildAchievements(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Text(
      'Профиль',
      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildProfileCard(BuildContext context) {
    final level = AppState.level;
    final xp = AppState.xp;
    final xpInCurrentLevel = xp % 100;
    final progress = xpInCurrentLevel / 100;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Theme.of(context).colorScheme.primaryContainer,
            Theme.of(context).colorScheme.secondaryContainer,
          ],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                level.toString(),
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Уровень $level',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '$xpInCurrentLevel / 100 XP',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsGrid(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Статистика',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: StatCard(
                title: 'Опыт',
                value: AppState.xp.toString(),
                icon: Icons.stars,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: StatCard(
                title: 'Стрик',
                value: AppState.currentStreak.toString(),
                icon: Icons.local_fire_department,
                color: Colors.orange,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: StatCard(
                title: 'Карточек',
                value: AppState.cards.length.toString(),
                icon: Icons.style,
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: StatCard(
                title: 'Достижений',
                value: AppState.unlockedAchievements.length.toString(),
                icon: Icons.emoji_events,
                color: Colors.amber,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAchievements(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Достижения',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        if (AppState.unlockedAchievements.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceVariant,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.emoji_events,
                  size: 48,
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.3),
                ),
                const SizedBox(height: 12),
                Text(
                  'Пока нет достижений',
                  style: Theme.of(context).textTheme.titleMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 4),
                Text(
                  'Продолжайте учиться, чтобы получить первое!',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          )
        else
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: AppState.unlockedAchievements.map(
              (achievementId) {
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.amber.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(
                      color: Colors.amber.withOpacity(0.5),
                      width: 2,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.emoji_events,
                        size: 20,
                        color: Colors.amber,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        achievementId,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ).toList(),
          ),
      ],
    );
  }
}
