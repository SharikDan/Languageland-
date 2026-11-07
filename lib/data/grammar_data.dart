import '../models/grammar_phrase.dart';

// Данные грамматики / Grammar data
final List<GrammarPhrase> grammarData = [
  const GrammarPhrase(
    japanese: 'です',
    russian: 'быть (вежливая форма)',
    english: 'to be (polite form)',
    explanation: 'Связка です используется для утверждений. Это вежливая форма настоящего времени глагола "быть".',
    explanationEn: 'The copula です is used for statements. It is the polite present tense form of the verb "to be".',
    examples: ['わたしは学生です。 - Я студент.', 'これは本です。 - Это книга.'],
    examplesEn: ['わたしは学生です。 - I am a student.', 'これは本です。 - This is a book.'],
  ),
  const GrammarPhrase(
    japanese: 'ではありません / じゃありません',
    russian: 'не быть (отрицание)',
    english: 'not to be (negative)',
    explanation: 'Отрицательная форма です. じゃありません более разговорная.',
    explanationEn: 'The negative form of です. じゃありません is more colloquial.',
    examples: ['わたしは学生ではありません。 - Я не студент.', 'これは本じゃありません。 - Это не книга.'],
    examplesEn: ['わたしは学生ではありません。 - I am not a student.', 'これは本じゃありません。 - This is not a book.'],
  ),
  const GrammarPhrase(
    japanese: 'ですか',
    russian: 'вопросительная частица',
    english: 'question particle',
    explanation: 'Частица か в конце предложения превращает утверждение в вопрос.',
    explanationEn: 'The particle か at the end of a sentence turns a statement into a question.',
    examples: ['これは本ですか。 - Это книга?', '田中さんは学生ですか。 - Танака-сан студент?'],
    examplesEn: ['これは本ですか。 - Is this a book?', '田中さんは学生ですか。 - Is Tanaka-san a student?'],
  ),
  const GrammarPhrase(
    japanese: 'は (частица темы)',
    russian: 'что касается',
    english: 'topic particle',
    explanation: 'Частица は (произносится "ва") обозначает тему предложения.',
    explanationEn: 'The particle は (pronounced "wa") marks the topic of the sentence.',
    examples: ['わたしは学生です。 - Что касается меня, я студент.', '日本は国です。 - Япония - это страна.'],
    examplesEn: ['わたしは学生です。 - As for me, I am a student.', '日本は国です。 - Japan is a country.'],
  ),
  const GrammarPhrase(
    japanese: 'の (частица принадлежности)',
    russian: 'принадлежность',
    english: 'possessive particle',
    explanation: 'Частица の показывает принадлежность или связь между существительными.',
    explanationEn: 'The particle の indicates possession or connection between nouns.',
    examples: ['わたしの本 - моя книга', '田中さんの車 - машина Танака-сан'],
    examplesEn: ['わたしの本 - my book', '田中さんの車 - Tanaka-san\'s car'],
  ),
  // ... (добавь остальные по аналогии)
];