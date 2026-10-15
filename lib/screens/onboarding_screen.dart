// Экран онбординга: 3 шага знакомства с приложением
import 'package:flutter/material.dart';
import '../services/app_state.dart';
import 'main_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<_OnboardingPage> _pages = const [
    _OnboardingPage(
      icon: Icons.school,
      title: 'Что это?',
      description: 'Languageland — это увлекательное приложение для изучения японского языка. Хирагана, катакана, кандзи, лексика и грамматика в игровой форме!',
    ),
    _OnboardingPage(
      icon: Icons.psychology,
      title: 'Как учиться?',
      description: 'Проходите уроки, отвечайте на вопросы и получайте опыт. При ошибках Ая объяснит, что пошло не так. Система SRS поможет не забыть выученное!',
    ),
    _OnboardingPage(
      icon: Icons.emoji_events,
      title: 'Готовы?',
      description: 'Зарабатывайте уровни, выполняйте квесты, получайте достижения. Занимайтесь каждый день и ваш стрик будет расти!',
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _buildProgressBar(context),
            Expanded(
              child: _buildPageView(),
            ),
            _buildButtons(context),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: List.generate(
          _pages.length,
          (index) => Expanded(
            child: Container(
              height: 4,
              margin: EdgeInsets.only(
                left: index == 0 ? 0 : 4,
                right: index == _pages.length - 1 ? 0 : 4,
              ),
              decoration: BoxDecoration(
                color: index <= _currentPage
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.surfaceVariant,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPageView() {
    return PageView.builder(
      controller: _pageController,
      onPageChanged: (index) {
        setState(
          () {
            _currentPage = index;
          },
        );
      },
      itemCount: _pages.length,
      itemBuilder: (context, index) {
        return _buildPage(context, _pages[index]);
      },
    );
  }

  Widget _buildPage(BuildContext context, _OnboardingPage page) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
              shape: BoxShape.circle,
            ),
            child: Icon(
              page.icon,
              size: 64,
              color: Theme.of(context).colorScheme.onPrimaryContainer,
            ),
          ),
          const SizedBox(height: 32),
          Text(
            page.title,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            page.description,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildButtons(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          if (_currentPage > 0) ...[
            TextButton(
              onPressed: _goToPreviousPage,
              child: const Text('Назад'),
            ),
            const SizedBox(width: 16),
          ],
          Expanded(
            child: ElevatedButton(
              onPressed: _isLastPage ? _finishOnboarding : _goToNextPage,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
              child: Text(
                _isLastPage ? 'Начать обучение' : 'Далее',
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool get _isLastPage => _currentPage == _pages.length - 1;

  void _goToNextPage() {
    _pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _goToPreviousPage() {
    _pageController.previousPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _finishOnboarding() {
    AppState.hasCompletedOnboarding = true;
    AppState.save();

    if (!mounted) {
      return;
    }

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const MainScreen(),
      ),
    );
  }
}

class _OnboardingPage {
  final IconData icon;
  final String title;
  final String description;

  const _OnboardingPage({
    required this.icon,
    required this.title,
    required this.description,
  });
}
