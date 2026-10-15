// Данные квестов (10 начальных квестов)
import '../models/quest_def.dart';

final List<QuestDef> questsData = [
  QuestDef(
    id: 'complete_hiragana',
    title: 'Освоить хирагану',
    description: 'Выучите все 46 знаков хираганы',
    targetCount: 46,
    reward: 500,
  ),
  QuestDef(
    id: 'complete_katakana',
    title: 'Освоить катакану',
    description: 'Выучите все 46 знаков катаканы',
    targetCount: 46,
    reward: 500,
  ),
  QuestDef(
    id: 'learn_10_kanji',
    title: 'Первые кандзи',
    description: 'Выучите 10 кандзи',
    targetCount: 10,
    reward: 200,
  ),
  QuestDef(
    id: 'learn_50_kanji',
    title: 'Половина кандзи N5',
    description: 'Выучите 50 кандзи',
    targetCount: 50,
    reward: 800,
  ),
  QuestDef(
    id: 'learn_20_words',
    title: 'Базовый словарь',
    description: 'Выучите 20 слов',
    targetCount: 20,
    reward: 300,
  ),
  QuestDef(
    id: 'learn_all_words',
    title: 'Полный словарь',
    description: 'Выучите все 80 слов',
    targetCount: 80,
    reward: 1000,
  ),
  QuestDef(
    id: 'learn_5_grammar',
    title: 'Грамматическая база',
    description: 'Изучите 5 грамматических конструкций',
    targetCount: 5,
    reward: 250,
  ),
  QuestDef(
    id: 'daily_practice_7',
    title: 'Неделя практики',
    description: 'Занимайтесь 7 дней подряд',
    targetCount: 7,
    reward: 400,
  ),
  QuestDef(
    id: 'complete_100_reviews',
    title: 'Мастер повторений',
    description: 'Завершите 100 SRS-повторений',
    targetCount: 100,
    reward: 600,
  ),
  QuestDef(
    id: 'reach_level_10',
    title: 'Достигните 10 уровня',
    description: 'Наберите достаточно опыта для 10 уровня',
    targetCount: 1000,
    reward: 1500,
  ),
];
