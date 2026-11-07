import 'dart:math';
import 'package:ayas_languageland/data/kana_tips.dart';
import 'package:ayas_languageland/logic/services/app_localizations.dart';

// Локальный ИИ / Local AI (Web fallback)
class AyaAi {
  static final Random _random = Random();

  static String getResponse(String input) {
    final text = input.toLowerCase().trim();
    final isEn = AppLoc.lang.value == 'en';

    // 1. Поиск знаков каны / Search for kana
    final kanaRegex = RegExp(r'[ぁ-んァ-ヶ]');
    final match = kanaRegex.firstMatch(input);
    if (match != null) {
      final char = match.group(0)!;
      final tip = KanaTips.explanations[char];
      if (tip != null) return isEn ? 'About "$char": $tip' : 'О, ты спрашиваешь про знак "$char"! $tip';
    }

    // 2. Приветствия / Greetings
    if (RegExp(r'привет|здравствуй|хай|ку|йо|прив|hello|hi').hasMatch(text)) {
      final responses = isEn 
        ? ['Hello! I am Aya. Ready to learn?', 'Hi there! How are you today?', 'Konnichiwa! Let us study!']
        : ['Привет-привет! 👋 Я Ая. Готова покорять с тобой Languageland?', 'Охаё! (Доброе утро!) Как настроение?', 'Привет! Рада тебя видеть. С чего начнем?'];
      return responses[_random.nextInt(responses.length)];
    }
    
    // 3. Да / Yes
    if (RegExp(r'^да$|^ага$|^конечно$|^угу$|^yes$|^yeah$|^ок$').hasMatch(text)) {
      final responses = isEn
        ? ['Awesome! Let us learn some kanji.', 'Great! I love your enthusiasm.', 'Okay! Go to the Kana tab and start training!']
        : ['Отлично! Тогда давай учить кандзи.', 'Супер! Люблю твой энтузиазм.', 'Окей! Открывай вкладку Кана и погнали тренироваться!'];
      return responses[_random.nextInt(responses.length)];
    }
    
    // 4. Нет / No
    if (RegExp(r'^нет$|^неа$|^no$|^nope$').hasMatch(text)) {
      final responses = isEn
        ? ['Oh, maybe a break?', 'Okay, take your time!', 'No worries. We can chat instead.']
        : ['Ой, а что случилось? Может, сделаем перерыв?', 'Хорошо, не торопись.', 'Без проблем. Тогда можем просто поболтать.'];
      return responses[_random.nextInt(responses.length)];
    }

    // 5. Как дела / How are you
    if (RegExp(r'как дела|как ты|чего делаешь|how are you').hasMatch(text)) {
      final responses = isEn
        ? ['I am great! Studying new symbols.', 'Doing well! Just drinking some green tea. You?', 'All good! Ready to learn.']
        : ['Всё отлично! Разбираю новые кандзи.', 'Хорошо! Пью зелёный чай. А у тебя как?', 'Супер! Готова к новым урокам.'];
      return responses[_random.nextInt(responses.length)];
    }

    // 6. Аниме / Anime
    if (RegExp(r'аниме|наруто|тян|anime').hasMatch(text)) {
      return isEn ? 'I love anime! Attack on Titan is my favorite.' : 'Ой, аниме! 🍿 Я обожаю «Атаку Титанов» и «Наруто». А ты какое смотришь?';
    }

    // 7. Помощь / Help
    if (RegExp(r'помоги|как учить|не понимаю|help').hasMatch(text)) {
      return isEn ? 'Do not worry! Just study 10 symbols a day.' : 'Не переживай! Учить язык — это марафон. Проходи по 10 знаков в день и повторяй в SRS.';
    }

    // 8. Прощание / Bye
    if (RegExp(r'пока|бай|до свидания|bye').hasMatch(text)) {
      return isEn ? 'See you later! 👋' : 'Пока-пока! Не забывай заходить, я буду скучать. 👋';
    }

    // 9. Комплименты / Compliments
    if (RegExp(r'молодец|круто|умница|good job').hasMatch(text)) {
      return isEn ? 'Thank you! You are doing great too!' : 'Спасибо! Ты тоже огромный молодец. Продолжай в том же духе! 💪';
    }

    // 10. Кто ты / Who are you
    if (RegExp(r'кто ты|как тебя зовут|what is your name').hasMatch(text)) {
      return isEn ? 'I am Aya, your AI guide!' : 'Я Ая! Твой цифровой проводник в мир японского языка. Живу прямо в этом приложении. 🤖';
    }

    // 11. Fallback
    final fallbacks = isEn 
      ? ['Hmm, I did not get that. Try asking about Japanese!', 'My AI brain is still small. Ask me about Kanji!', 'I am not sure what to say. Tell me about your day!']
      : ['Хм, я пока не поняла. Я ещё маленькая ИИ.', 'Мой искусственный интеллект ещё учится. Спроси меня про Кандзи!', 'Я не знаю, что ответить. Расскажи, как проходит твой день?'];
    return fallbacks[_random.nextInt(fallbacks.length)];
  }
}