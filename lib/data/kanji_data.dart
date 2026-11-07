import '../models/kanji_item.dart';

// Данные кандзи N5 / Kanji N5 data
final List<KanjiItem> kanjiData = [
  const KanjiItem(char: '一', meaning: 'один', meaningEn: 'one', kunyomi: 'ひと-つ', onyomi: 'イチ、イツ', examples: ['一つ (ひとつ) - один', '一日 (ついたち) - первое число'], examplesEn: ['一つ (hitotsu) - one', '一日 (tsuitachi) - first day of the month']),
  const KanjiItem(char: '二', meaning: 'два', meaningEn: 'two', kunyomi: 'ふた-つ', onyomi: 'ニ', examples: ['二つ (ふたつ) - два', '二人 (ふたり) - два человека'], examplesEn: ['二つ (futatsu) - two', '二人 (futari) - two people']),
  const KanjiItem(char: '三', meaning: 'три', meaningEn: 'three', kunyomi: 'みっ-つ', onyomi: 'サン', examples: ['三つ (みっつ) - три', '三日 (みっか) - третье число'], examplesEn: ['三つ (mittsu) - three', '三日 (mikka) - third day of the month']),
  const KanjiItem(char: '四', meaning: 'четыре', meaningEn: 'four', kunyomi: 'よ、よっ-つ、よん', onyomi: 'シ', examples: ['四つ (よっつ) - четыре', '四月 (しがつ) - апрель'], examplesEn: ['四つ (yottsu) - four', '四月 (shigatsu) - April']),
  const KanjiItem(char: '五', meaning: 'пять', meaningEn: 'five', kunyomi: 'いつ-つ', onyomi: 'ゴ', examples: ['五つ (いつつ) - пять', '五月 (ごがつ) - май'], examplesEn: ['五つ (itsutsu) - five', '五月 (gogatsu) - May']),
  const KanjiItem(char: '六', meaning: 'шесть', meaningEn: 'six', kunyomi: 'むっ-つ、むい', onyomi: 'ロク', examples: ['六つ (むっつ) - шесть', '六月 (ろくがつ) - июнь'], examplesEn: ['六つ (muttsu) - six', '六月 (rokugatsu) - June']),
  const KanjiItem(char: '七', meaning: 'семь', meaningEn: 'seven', kunyomi: 'なな-つ、なの', onyomi: 'シチ', examples: ['七つ (ななつ) - семь', '七月 (しちがつ) - июль'], examplesEn: ['七つ (nanatsu) - seven', '七月 (shichigatsu) - July']),
  const KanjiItem(char: '八', meaning: 'восемь', meaningEn: 'eight', kunyomi: 'やっ-つ、よう', onyomi: 'ハチ', examples: ['八つ (やっつ) - восемь', '八月 (はちがつ) - август'], examplesEn: ['八つ (yattsu) - eight', '八月 (hachigatsu) - August']),
  const KanjiItem(char: '九', meaning: 'девять', meaningEn: 'nine', kunyomi: 'ここの-つ', onyomi: 'キュウ、ク', examples: ['九つ (ここのつ) - девять', '九月 (くがつ) - сентябрь'], examplesEn: ['九つ (kokonotsu) - nine', '九月 (kugatsu) - September']),
  const KanjiItem(char: '十', meaning: 'десять', meaningEn: 'ten', kunyomi: 'とお', onyomi: 'ジュウ', examples: ['十 (じゅう) - десять', '十月 (じゅうがつ) - октябрь'], examplesEn: ['十 (juu) - ten', '十月 (juugatsu) - October']),
  const KanjiItem(char: '百', meaning: 'сто', meaningEn: 'hundred', kunyomi: '', onyomi: 'ヒャク', examples: ['百 (ひゃく) - сто', '三百 (さんびゃく) - триста'], examplesEn: ['百 (hyaku) - hundred', '三百 (sanbyaku) - three hundred']),
  const KanjiItem(char: '千', meaning: 'тысяча', meaningEn: 'thousand', kunyomi: '', onyomi: 'セン', examples: ['千 (せん) - тысяча', '二千 (にせん) - две тысячи'], examplesEn: ['千 (sen) - thousand', '二千 (nisen) - two thousand']),
  const KanjiItem(char: '万', meaning: 'десять тысяч', meaningEn: 'ten thousand', kunyomi: '', onyomi: 'マン、バン', examples: ['一万 (いちまん) - десять тысяч', '万年筆 (まんねんひつ) - ручка'], examplesEn: ['一万 (ichiman) - ten thousand', '万年筆 (mannenhitsu) - fountain pen']),
  const KanjiItem(char: '円', meaning: 'йена, круг', meaningEn: 'yen, circle', kunyomi: 'まる-い', onyomi: 'エン', examples: ['百円 (ひゃくえん) - 100 йен', '円い (まるい) - круглый'], examplesEn: ['百円 (hyakuen) - 100 yen', '円い (marui) - round']),
  const KanjiItem(char: '人', meaning: 'человек', meaningEn: 'person', kunyomi: 'ひと', onyomi: 'ジン、ニン', examples: ['人 (ひと) - человек', '日本人 (にほんじん) - японец'], examplesEn: ['人 (hito) - person', '日本人 (nihonjin) - Japanese person']),
  const KanjiItem(char: '日', meaning: 'день, солнце', meaningEn: 'day, sun', kunyomi: 'ひ、か', onyomi: 'ニチ、ジツ', examples: ['日 (ひ) - день', '毎日 (まいにち) - каждый день'], examplesEn: ['日 (hi) - day', '毎日 (mainichi) - every day']),
  const KanjiItem(char: '月', meaning: 'месяц, луна', meaningEn: 'month, moon', kunyomi: 'つき', onyomi: 'ゲツ、ガツ', examples: ['月 (つき) - луна', '一月 (いちがつ) - январь'], examplesEn: ['月 (tsuki) - moon', '一月 (ichigatsu) - January']),
  const KanjiItem(char: '火', meaning: 'огонь', meaningEn: 'fire', kunyomi: 'ひ', onyomi: 'カ', examples: ['火 (ひ) - огонь', '火曜日 (かようび) - вторник'], examplesEn: ['火 (hi) - fire', '火曜日 (kayoubi) - Tuesday']),
  const KanjiItem(char: '水', meaning: 'вода', meaningEn: 'water', kunyomi: 'みず', onyomi: 'スイ', examples: ['水 (みず) - вода', '水曜日 (すいようび) - среда'], examplesEn: ['水 (mizu) - water', '水曜日 (suiyoubi) - Wednesday']),
  const KanjiItem(char: '木', meaning: 'дерево', meaningEn: 'tree', kunyomi: 'き', onyomi: 'モク、ボク', examples: ['木 (き) - дерево', '木曜日 (もくようび) - четверг'], examplesEn: ['木 (ki) - tree', '木曜日 (mokuyoubi) - Thursday']),
  // ... (добавь остальные по аналогии или оставь как есть, если тебе хватит этих)
];