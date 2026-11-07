import '../models/quest_def.dart';

// Данные квестов / Quests data
final List<QuestDef> questsData = [
  QuestDef(
    id: 'complete_hiragana',
    title: 'Освоить хирагану',
    titleEn: 'Master Hiragana',
    description: 'Выучите все 46 знаков хираганы',
    descriptionEn: 'Learn all 46 Hiragana characters',
    targetCount: 46,
    reward: 500,
  ),
  QuestDef(
    id: 'complete_katakana',
    title: 'Освоить катакану',
    titleEn: 'Master Katakana',
    description: 'Выучите все 46 знаков катаканы',
    descriptionEn: 'Learn all 46 Katakana characters',
    targetCount: 46,
    reward: 500,
  ),
  QuestDef(
    id: 'learn_10_kanji',
    title: 'Первые кандзи',
    titleEn: 'First Kanji',
    description: 'Выучите 10 кандзи',
    descriptionEn: 'Learn 10 Kanji',
    targetCount: 10,
    reward: 200,
  ),
  QuestDef(
    id: 'learn_50_kanji',
    title: 'Половина кандзи N5',
    titleEn: 'Half of N5 Kanji',
    description: 'Выучите 50 кандзи',
    descriptionEn: 'Learn 50 Kanji',
    targetCount: 50,
    reward: 800,
  ),
  QuestDef(
    id: 'learn_20_words',
    title: 'Базовый словарь',
    titleEn: 'Basic Vocabulary',
    description: 'Выучите 20 слов',
    descriptionEn: 'Learn 20 words',
    targetCount: 20,
    reward: 300,
  ),
  QuestDef(
    id: 'daily_practice_7',
    title: 'Неделя практики',
    titleEn: 'Week of Practice',
    description: 'Занимайтесь 7 дней подряд',
    descriptionEn: 'Study 7 days in a row',
    targetCount: 7,
    reward: 400,
  ),
];