class KanaChar {
  final String char;
  final String romaji;
  final String type;

  const KanaChar({
    required this.char,
    required this.romaji,
    required this.type,
  });

  // Русская транскрипция
  String get romajiRu {
    const map = {
      'a': 'а',
      'i': 'и',
      'u': 'у',
      'e': 'э',
      'o': 'о',
      'ka': 'ка',
      'ki': 'ки',
      'ku': 'ку',
      'ke': 'кэ',
      'ko': 'ко',
      'sa': 'са',
      'shi': 'си',
      'su': 'су',
      'se': 'сэ',
      'so': 'со',
      'ta': 'та',
      'chi': 'ти',
      'tsu': 'цу',
      'te': 'тэ',
      'to': 'то',
      'na': 'на',
      'ni': 'ни',
      'nu': 'ну',
      'ne': 'нэ',
      'no': 'но',
      'ha': 'ха',
      'hi': 'хи',
      'fu': 'фу',
      'he': 'хэ',
      'ho': 'хо',
      'ma': 'ма',
      'mi': 'ми',
      'mu': 'му',
      'me': 'мэ',
      'mo': 'мо',
      'ya': 'я',
      'yu': 'ю',
      'yo': 'ё',
      'ra': 'ра',
      'ri': 'ри',
      'ru': 'ру',
      're': 'рэ',
      'ro': 'ро',
      'wa': 'ва',
      'wo': 'о',
      'n': 'н',
    };
    return map[romaji] ?? romaji;
  }
}
