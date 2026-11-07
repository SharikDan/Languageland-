import 'package:ayas_languageland/logic/services/app_localizations.dart';

class KanaTips {
  // База знаний с переводами на английский и русский
  static const Map<String, Map<String, String>> explanations = {
    'あ': {'ru': 'Похожа на букву «А», которая запуталась в шарфе. Звучит как «а».', 'en': 'Looks like the letter "A" tangled in a scarf. Sounds like "a".'},
    'い': {'ru': 'Две вертикальные палочки. Легко запомнить: как две спички. Звучит как «и».', 'en': 'Two vertical sticks. Sounds like "i".'},
    'う': {'ru': 'Человечек сидит на стуле и скучает: «У-у-у...». Звучит как «у».', 'en': 'A person sitting on a chair, bored: "U-u-u...". Sounds like "u".'},
    'え': {'ru': 'Человечек упал с горки и кричит: «Э-э-э, как больно!». Звучит как «э».', 'en': 'A person falling down a hill: "E-e-e!". Sounds like "e".'},
    'お': {'ru': 'Человечек с большим ртом. Он удивляется: «О-о-о!». Звучит как «о».', 'en': 'A person with a big mouth: "O-o-o!". Sounds like "o".'},
    'か': {'ru': 'Меч, который рубит змею. Звучит как «ка».', 'en': 'A sword cutting a snake. Sounds like "ka".'},
    'き': {'ru': 'Похожа на английский ключ (key) с двумя зубчиками. Звучит как «ки».', 'en': 'Looks like a key with two teeth. Sounds like "ki".'},
    'く': {'ru': 'Открытый клюв птицы. Она кричит: «Ку-ку!». Звучит как «ку».', 'en': 'An open bird beak. It cries: "Ku-ku!". Sounds like "ku".'},
    'け': {'ru': 'Ключ, у которого сломалась ручка. Звучит как «кэ».', 'en': 'A key with a broken handle. Sounds like "ke".'},
    'こ': {'ru': 'Две горизонтальные ниточки. Звучит как «ко».', 'en': 'Two horizontal threads. Sounds like "ko".'},
    'さ': {'ru': 'Лебедь плывет по воде. Звучит как «са».', 'en': 'A swan swimming on water. Sounds like "sa".'},
    'し': {'ru': 'Крючок для рыбалки или улыбка. Звучит как «си» (ши).', 'en': 'A fishing hook or a smile. Sounds like "shi".'},
    'す': {'ru': 'Человечек висит на турнике. Звучит как «су».', 'en': 'A person hanging on a pull-up bar. Sounds like "su".'},
    'せ': {'ru': 'Глаз с ресницами. Звучит как «сэ».', 'en': 'An eye with eyelashes. Sounds like "se".'},
    'そ': {'ru': 'Зигзаг или молния. Звучит как «со».', 'en': 'A zigzag or lightning. Sounds like "so".'},
    'た': {'ru': 'Буква «Т» с тремя палочками. Звучит как «та».', 'en': 'The letter "T" with three sticks. Sounds like "ta".'},
    'ち': {'ru': 'Человечек танцует. Звучит как «ти» (чи).', 'en': 'A person dancing. Sounds like "chi".'},
    'つ': {'ru': 'Волна или цунами. Звучит как «цу».', 'en': 'A wave or tsunami. Sounds like "tsu".'},
    'て': {'ru': 'Рука, которая держит что-то. Звучит как «тэ».', 'en': 'A hand holding something. Sounds like "te".'},
    'と': {'ru': 'Шип или колючка. Звучит как «то».', 'en': 'A thorn or spike. Sounds like "to".'},
    'な': {'ru': 'Человечек завязал узел. Звучит как «на».', 'en': 'A person tying a knot. Sounds like "na".'},
    'に': {'ru': 'Две черты и петелька. Звучит как «ни».', 'en': 'Two lines and a loop. Sounds like "ni".'},
    'ぬ': {'ru': 'Петля или узел. Звучит как «ну». Внимание: легко спутать с め!', 'en': 'A loop or knot. Sounds like "nu". Warning: easily confused with め!'},
    'ね': {'ru': 'Кошка (neko) с хвостиком. Звучит как «нэ». Внимание: похожа на わ и れ!', 'en': 'A cat (neko) with a tail. Sounds like "ne". Warning: looks like わ and れ!'},
    'の': {'ru': 'Спираль или улитка. Звучит как «но».', 'en': 'A spiral or snail. Sounds like "no".'},
    'は': {'ru': 'Человечек смеется: «Ха-ха!». Звучит как «ха».', 'en': 'A person laughing: "Ha-ha!". Sounds like "ha".'},
    'ひ': {'ru': 'Улыбка или рот. Звучит как «хи».', 'en': 'A smile or mouth. Sounds like "hi".'},
    'ふ': {'ru': 'Гора Фудзи. Звучит как «фу».', 'en': 'Mount Fuji. Sounds like "fu".'},
    'へ': {'ru': 'Гора или холм. Звучит как «хэ».', 'en': 'A mountain or hill. Sounds like "he".'},
    'ほ': {'ru': 'Человечек удивился. Звучит как «хо».', 'en': 'A surprised person. Sounds like "ho".'},
    'ま': {'ru': 'Человечек сложил руки. Звучит как «ма».', 'en': 'A person folding their arms. Sounds like "ma".'},
    'み': {'ru': 'Человечек бежит. Звучит как «ми».', 'en': 'A person running. Sounds like "mi".'},
    'む': {'ru': 'Корова говорит «Му-у-у». Звучит как «му».', 'en': 'A cow says "Moo". Sounds like "mu".'},
    'め': {'ru': 'Глаз с ресницами. Звучит как «мэ». Внимание: легко спутать с ぬ!', 'en': 'An eye with eyelashes. Sounds like "me". Warning: easily confused with ぬ!'},
    'も': {'ru': 'Рыбацкая сеть. Звучит как «мо».', 'en': 'A fishing net. Sounds like "mo".'},
    'や': {'ru': 'Человечек с поднятыми руками. Звучит как «я».', 'en': 'A person with raised arms. Sounds like "ya".'},
    'ゆ': {'ru': 'Человечек плывет. Звучит как «ю».', 'en': 'A person swimming. Sounds like "yu".'},
    'よ': {'ru': 'Человечек с хвостиком. Звучит как «ё».', 'en': 'A person with a ponytail. Sounds like "yo".'},
    'ら': {'ru': 'Человечек сидит на стуле. Звучит как «ра».', 'en': 'A person sitting on a chair. Sounds like "ra".'},
    'り': {'ru': 'Две вертикальные черты. Звучит как «ри».', 'en': 'Two vertical lines. Sounds like "ri".'},
    'る': {'ru': 'Петля или узел. Звучит как «ру». Внимание: легко спутать с ろ!', 'en': 'A loop or knot. Sounds like "ru". Warning: easily confused with ろ!'},
    'れ': {'ru': 'Человечек машет рукой. Звучит как «рэ». Внимание: похожа на わ и ね!', 'en': 'A person waving their hand. Sounds like "re". Warning: looks like わ and ね!'},
    'ろ': {'ru': 'Рот или улыбка. Звучит как «ро». Внимание: легко спутать с る!', 'en': 'A mouth or smile. Sounds like "ro". Warning: easily confused with る!'},
    'わ': {'ru': 'Рука, которая машет (wa). Звучит как «ва». У わ нет петельки внизу, в отличие от ね и れ.', 'en': 'A hand waving (wa). Sounds like "wa". わ has no loop at the bottom, unlike ね and れ.'},
    'を': {'ru': 'Человечек что-то несет. Звучит как «о» (используется только как частица).', 'en': 'A person carrying something. Sounds like "o" (used only as a particle).'},
    'ん': {'ru': 'Английская «n» или волна. Звучит как «н».', 'en': 'An English "n" or a wave. Sounds like "n".'},
  };

  static const Map<String, Map<String, String>> confusionTips = {
    'わ_れ': {'ru': 'Ой, ты перепутал わ (wa) и れ (re)! У れ есть петелька внизу справа, а у わ нет.', 'en': 'Oops, you confused わ (wa) and れ (re)! れ has a loop at the bottom right, while わ does not.'},
    'わ_ね': {'ru': 'Ой, ты перепутал わ (wa) и ね (ne)! У ね есть закрученный хвостик, как у кошки (neko), а わ — это просто рука.', 'en': 'Oops, you confused わ (wa) and ね (ne)! ね has a curly tail like a cat (neko), while わ is just a hand.'},
    'ぬ_め': {'ru': 'Ой, ты перепутал ぬ (nu) и め (me)! У ぬ есть хвостик-петелька, а め заканчивается просто чертой.', 'en': 'Oops, you confused ぬ (nu) and め (me)! ぬ has a loop-tail, while め ends with a simple stroke.'},
    'る_ろ': {'ru': 'Ой, ты перепутал る (ru) и ろ (ro)! У る есть маленькая петелька внизу, а у ろ — нет.', 'en': 'Oops, you confused る (ru) and ろ (ro)! る has a small loop at the bottom, while ろ does not.'},
  };

  static String getSmartTip(String char, String correctRomaji, String? selectedRomaji) {
    final lang = AppLoc.lang.value; // Получаем текущий язык

    if (selectedRomaji != null) {
      final selectedClean = selectedRomaji.split(' ').last.replaceAll('(', '').replaceAll(')', '').toLowerCase();
      final correctClean = correctRomaji.toLowerCase();
      final pair1 = '${correctClean}_$selectedClean';
      final pair2 = '${selectedClean}_$correctClean';

      if (confusionTips.containsKey(pair1)) return confusionTips[pair1]![lang]!;
      if (confusionTips.containsKey(pair2)) return confusionTips[pair2]![lang]!;

      final baseTip = explanations[char]?[lang] ?? '';
      return lang == 'en' 
          ? 'You chose "$selectedRomaji", but the correct answer is "$correctRomaji". $baseTip'
          : 'Ты выбрал "$selectedRomaji", но правильный ответ — "$correctRomaji". $baseTip';
    }
    return explanations[char]?[lang] ?? (lang == 'en' ? 'This character is read as "$correctRomaji".' : 'Этот знак читается как "$correctRomaji".');
  }

  static String getHint(String char, String correctRomaji) {
    final lang = AppLoc.lang.value;
    final tip = explanations[char]?[lang] ?? '';
    if (tip.isEmpty) return lang == 'en' ? 'Try to remember how this character sounds.' : 'Попробуй вспомнить, как этот знак звучит.';
    return tip;
  }
}