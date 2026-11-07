import 'dart:math';
import 'package:ayas_languageland/data/kana_tips.dart';
import 'package:ayas_languageland/logic/services/app_localizations.dart';

// Ð›Ð¾ÐºÐ°Ð»ÑŒÐ½Ñ‹Ð¹ Ð˜Ð˜ / Local AI (Web fallback)
class AyaAi {
  static final Random _random = Random();

  static String getResponse(String input) {
    final text = input.toLowerCase().trim();
    final isEn = AppLoc.lang.value == 'en';

    // 1. ÐŸÐ¾Ð¸ÑÐº Ð·Ð½Ð°ÐºÐ¾Ð² ÐºÐ°Ð½Ñ‹ / Search for kana
    final kanaRegex = RegExp(r'[ã-ã‚“ã‚¡-ãƒ¶]');
    final match = kanaRegex.firstMatch(input);
    if (match != null) {
      final char = match.group(0)!;
      final tip = KanaTips.explanations[char];
      if (tip != null) return isEn ? 'About "$char": $tip' : 'Ðž, Ñ‚Ñ‹ ÑÐ¿Ñ€Ð°ÑˆÐ¸Ð²Ð°ÐµÑˆÑŒ Ð¿Ñ€Ð¾ Ð·Ð½Ð°Ðº "$char"! $tip';
    }

    // 2. ÐŸÑ€Ð¸Ð²ÐµÑ‚ÑÑ‚Ð²Ð¸Ñ / Greetings
    if (RegExp(r'Ð¿Ñ€Ð¸Ð²ÐµÑ‚|Ð·Ð´Ñ€Ð°Ð²ÑÑ‚Ð²ÑƒÐ¹|Ñ…Ð°Ð¹|ÐºÑƒ|Ð¹Ð¾|Ð¿Ñ€Ð¸Ð²|hello|hi').hasMatch(text)) {
      final responses = isEn 
        ? ['Hello! I am Aya. Ready to learn?', 'Hi there! How are you today?', 'Konnichiwa! Let us study!']
        : ['ÐŸÑ€Ð¸Ð²ÐµÑ‚-Ð¿Ñ€Ð¸Ð²ÐµÑ‚! ðŸ‘‹ Ð¯ ÐÑ. Ð“Ð¾Ñ‚Ð¾Ð²Ð° Ð¿Ð¾ÐºÐ¾Ñ€ÑÑ‚ÑŒ Ñ Ñ‚Ð¾Ð±Ð¾Ð¹ Languageland?', 'ÐžÑ…Ð°Ñ‘! (Ð”Ð¾Ð±Ñ€Ð¾Ðµ ÑƒÑ‚Ñ€Ð¾!) ÐšÐ°Ðº Ð½Ð°ÑÑ‚Ñ€Ð¾ÐµÐ½Ð¸Ðµ?', 'ÐŸÑ€Ð¸Ð²ÐµÑ‚! Ð Ð°Ð´Ð° Ñ‚ÐµÐ±Ñ Ð²Ð¸Ð´ÐµÑ‚ÑŒ. Ð¡ Ñ‡ÐµÐ³Ð¾ Ð½Ð°Ñ‡Ð½ÐµÐ¼?'];
      return responses[_random.nextInt(responses.length)];
    }
    
    // 3. Ð”Ð° / Yes
    if (RegExp(r'^Ð´Ð°$|^Ð°Ð³Ð°$|^ÐºÐ¾Ð½ÐµÑ‡Ð½Ð¾$|^ÑƒÐ³Ñƒ$|^yes$|^yeah$|^Ð¾Ðº$').hasMatch(text)) {
      final responses = isEn
        ? ['Awesome! Let us learn some kanji.', 'Great! I love your enthusiasm.', 'Okay! Go to the Kana tab and start training!']
        : ['ÐžÑ‚Ð»Ð¸Ñ‡Ð½Ð¾! Ð¢Ð¾Ð³Ð´Ð° Ð´Ð°Ð²Ð°Ð¹ ÑƒÑ‡Ð¸Ñ‚ÑŒ ÐºÐ°Ð½Ð´Ð·Ð¸.', 'Ð¡ÑƒÐ¿ÐµÑ€! Ð›ÑŽÐ±Ð»ÑŽ Ñ‚Ð²Ð¾Ð¹ ÑÐ½Ñ‚ÑƒÐ·Ð¸Ð°Ð·Ð¼.', 'ÐžÐºÐµÐ¹! ÐžÑ‚ÐºÑ€Ñ‹Ð²Ð°Ð¹ Ð²ÐºÐ»Ð°Ð´ÐºÑƒ ÐšÐ°Ð½Ð° Ð¸ Ð¿Ð¾Ð³Ð½Ð°Ð»Ð¸ Ñ‚Ñ€ÐµÐ½Ð¸Ñ€Ð¾Ð²Ð°Ñ‚ÑŒÑÑ!'];
      return responses[_random.nextInt(responses.length)];
    }
    
    // 4. ÐÐµÑ‚ / No
    if (RegExp(r'^Ð½ÐµÑ‚$|^Ð½ÐµÐ°$|^no$|^nope$').hasMatch(text)) {
      final responses = isEn
        ? ['Oh, maybe a break?', 'Okay, take your time!', 'No worries. We can chat instead.']
        : ['ÐžÐ¹, Ð° Ñ‡Ñ‚Ð¾ ÑÐ»ÑƒÑ‡Ð¸Ð»Ð¾ÑÑŒ? ÐœÐ¾Ð¶ÐµÑ‚, ÑÐ´ÐµÐ»Ð°ÐµÐ¼ Ð¿ÐµÑ€ÐµÑ€Ñ‹Ð²?', 'Ð¥Ð¾Ñ€Ð¾ÑˆÐ¾, Ð½Ðµ Ñ‚Ð¾Ñ€Ð¾Ð¿Ð¸ÑÑŒ.', 'Ð‘ÐµÐ· Ð¿Ñ€Ð¾Ð±Ð»ÐµÐ¼. Ð¢Ð¾Ð³Ð´Ð° Ð¼Ð¾Ð¶ÐµÐ¼ Ð¿Ñ€Ð¾ÑÑ‚Ð¾ Ð¿Ð¾Ð±Ð¾Ð»Ñ‚Ð°Ñ‚ÑŒ.'];
      return responses[_random.nextInt(responses.length)];
    }

    // 5. ÐšÐ°Ðº Ð´ÐµÐ»Ð° / How are you
    if (RegExp(r'ÐºÐ°Ðº Ð´ÐµÐ»Ð°|ÐºÐ°Ðº Ñ‚Ñ‹|Ñ‡ÐµÐ³Ð¾ Ð´ÐµÐ»Ð°ÐµÑˆÑŒ|how are you').hasMatch(text)) {
      final responses = isEn
        ? ['I am great! Studying new symbols.', 'Doing well! Just drinking some green tea. You?', 'All good! Ready to learn.']
        : ['Ð’ÑÑ‘ Ð¾Ñ‚Ð»Ð¸Ñ‡Ð½Ð¾! Ð Ð°Ð·Ð±Ð¸Ñ€Ð°ÑŽ Ð½Ð¾Ð²Ñ‹Ðµ ÐºÐ°Ð½Ð´Ð·Ð¸.', 'Ð¥Ð¾Ñ€Ð¾ÑˆÐ¾! ÐŸÑŒÑŽ Ð·ÐµÐ»Ñ‘Ð½Ñ‹Ð¹ Ñ‡Ð°Ð¹. Ð Ñƒ Ñ‚ÐµÐ±Ñ ÐºÐ°Ðº?', 'Ð¡ÑƒÐ¿ÐµÑ€! Ð“Ð¾Ñ‚Ð¾Ð²Ð° Ðº Ð½Ð¾Ð²Ñ‹Ð¼ ÑƒÑ€Ð¾ÐºÐ°Ð¼.'];
      return responses[_random.nextInt(responses.length)];
    }

    // 6. ÐÐ½Ð¸Ð¼Ðµ / Anime
    if (RegExp(r'Ð°Ð½Ð¸Ð¼Ðµ|Ð½Ð°Ñ€ÑƒÑ‚Ð¾|Ñ‚ÑÐ½|anime').hasMatch(text)) {
      return isEn ? 'I love anime! Attack on Titan is my favorite.' : 'ÐžÐ¹, Ð°Ð½Ð¸Ð¼Ðµ! ðŸ¿ Ð¯ Ð¾Ð±Ð¾Ð¶Ð°ÑŽ Â«ÐÑ‚Ð°ÐºÑƒ Ð¢Ð¸Ñ‚Ð°Ð½Ð¾Ð²Â» Ð¸ Â«ÐÐ°Ñ€ÑƒÑ‚Ð¾Â». Ð Ñ‚Ñ‹ ÐºÐ°ÐºÐ¾Ðµ ÑÐ¼Ð¾Ñ‚Ñ€Ð¸ÑˆÑŒ?';
    }

    // 7. ÐŸÐ¾Ð¼Ð¾Ñ‰ÑŒ / Help
    if (RegExp(r'Ð¿Ð¾Ð¼Ð¾Ð³Ð¸|ÐºÐ°Ðº ÑƒÑ‡Ð¸Ñ‚ÑŒ|Ð½Ðµ Ð¿Ð¾Ð½Ð¸Ð¼Ð°ÑŽ|help').hasMatch(text)) {
      return isEn ? 'Do not worry! Just study 10 symbols a day.' : 'ÐÐµ Ð¿ÐµÑ€ÐµÐ¶Ð¸Ð²Ð°Ð¹! Ð£Ñ‡Ð¸Ñ‚ÑŒ ÑÐ·Ñ‹Ðº â€” ÑÑ‚Ð¾ Ð¼Ð°Ñ€Ð°Ñ„Ð¾Ð½. ÐŸÑ€Ð¾Ñ…Ð¾Ð´Ð¸ Ð¿Ð¾ 10 Ð·Ð½Ð°ÐºÐ¾Ð² Ð² Ð´ÐµÐ½ÑŒ Ð¸ Ð¿Ð¾Ð²Ñ‚Ð¾Ñ€ÑÐ¹ Ð² SRS.';
    }

    // 8. ÐŸÑ€Ð¾Ñ‰Ð°Ð½Ð¸Ðµ / Bye
    if (RegExp(r'Ð¿Ð¾ÐºÐ°|Ð±Ð°Ð¹|Ð´Ð¾ ÑÐ²Ð¸Ð´Ð°Ð½Ð¸Ñ|bye').hasMatch(text)) {
      return isEn ? 'See you later! ðŸ‘‹' : 'ÐŸÐ¾ÐºÐ°-Ð¿Ð¾ÐºÐ°! ÐÐµ Ð·Ð°Ð±Ñ‹Ð²Ð°Ð¹ Ð·Ð°Ñ…Ð¾Ð´Ð¸Ñ‚ÑŒ, Ñ Ð±ÑƒÐ´Ñƒ ÑÐºÑƒÑ‡Ð°Ñ‚ÑŒ. ðŸ‘‹';
    }

    // 9. ÐšÐ¾Ð¼Ð¿Ð»Ð¸Ð¼ÐµÐ½Ñ‚Ñ‹ / Compliments
    if (RegExp(r'Ð¼Ð¾Ð»Ð¾Ð´ÐµÑ†|ÐºÑ€ÑƒÑ‚Ð¾|ÑƒÐ¼Ð½Ð¸Ñ†Ð°|good job').hasMatch(text)) {
      return isEn ? 'Thank you! You are doing great too!' : 'Ð¡Ð¿Ð°ÑÐ¸Ð±Ð¾! Ð¢Ñ‹ Ñ‚Ð¾Ð¶Ðµ Ð¾Ð³Ñ€Ð¾Ð¼Ð½Ñ‹Ð¹ Ð¼Ð¾Ð»Ð¾Ð´ÐµÑ†. ÐŸÑ€Ð¾Ð´Ð¾Ð»Ð¶Ð°Ð¹ Ð² Ñ‚Ð¾Ð¼ Ð¶Ðµ Ð´ÑƒÑ…Ðµ! ðŸ’ª';
    }

    // 10. ÐšÑ‚Ð¾ Ñ‚Ñ‹ / Who are you
    if (RegExp(r'ÐºÑ‚Ð¾ Ñ‚Ñ‹|ÐºÐ°Ðº Ñ‚ÐµÐ±Ñ Ð·Ð¾Ð²ÑƒÑ‚|what is your name').hasMatch(text)) {
      return isEn ? 'I am Aya, your AI guide!' : 'Ð¯ ÐÑ! Ð¢Ð²Ð¾Ð¹ Ñ†Ð¸Ñ„Ñ€Ð¾Ð²Ð¾Ð¹ Ð¿Ñ€Ð¾Ð²Ð¾Ð´Ð½Ð¸Ðº Ð² Ð¼Ð¸Ñ€ ÑÐ¿Ð¾Ð½ÑÐºÐ¾Ð³Ð¾ ÑÐ·Ñ‹ÐºÐ°. Ð–Ð¸Ð²Ñƒ Ð¿Ñ€ÑÐ¼Ð¾ Ð² ÑÑ‚Ð¾Ð¼ Ð¿Ñ€Ð¸Ð»Ð¾Ð¶ÐµÐ½Ð¸Ð¸. ðŸ¤–';
    }

    // 11. Fallback
    final fallbacks = isEn 
      ? ['Hmm, I did not get that. Try asking about Japanese!', 'My AI brain is still small. Ask me about Kanji!', 'I am not sure what to say. Tell me about your day!']
      : ['Ð¥Ð¼, Ñ Ð¿Ð¾ÐºÐ° Ð½Ðµ Ð¿Ð¾Ð½ÑÐ»Ð°. Ð¯ ÐµÑ‰Ñ‘ Ð¼Ð°Ð»ÐµÐ½ÑŒÐºÐ°Ñ Ð˜Ð˜.', 'ÐœÐ¾Ð¹ Ð¸ÑÐºÑƒÑÑÑ‚Ð²ÐµÐ½Ð½Ñ‹Ð¹ Ð¸Ð½Ñ‚ÐµÐ»Ð»ÐµÐºÑ‚ ÐµÑ‰Ñ‘ ÑƒÑ‡Ð¸Ñ‚ÑÑ. Ð¡Ð¿Ñ€Ð¾ÑÐ¸ Ð¼ÐµÐ½Ñ Ð¿Ñ€Ð¾ ÐšÐ°Ð½Ð´Ð·Ð¸!', 'Ð¯ Ð½Ðµ Ð·Ð½Ð°ÑŽ, Ñ‡Ñ‚Ð¾ Ð¾Ñ‚Ð²ÐµÑ‚Ð¸Ñ‚ÑŒ. Ð Ð°ÑÑÐºÐ°Ð¶Ð¸, ÐºÐ°Ðº Ð¿Ñ€Ð¾Ñ…Ð¾Ð´Ð¸Ñ‚ Ñ‚Ð²Ð¾Ð¹ Ð´ÐµÐ½ÑŒ?'];
    return fallbacks[_random.nextInt(fallbacks.length)];
  }
}