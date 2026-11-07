import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_gemma/flutter_gemma.dart';

class LocalLlmService {
  static final LocalLlmService instance = LocalLlmService._();
  LocalLlmService._();

  InferenceModel? _model;
  InferenceChat? _chat;
  bool _isReady = false;
  bool get isReady => _isReady;

  double _downloadProgress = 0.0;
  double get downloadProgress => _downloadProgress;
  
  String _errorMsg = '';
  String get errorMsg => _errorMsg;

  final String _modelUrl = 'https://huggingface.co/litert-community/Qwen2.5-0.5B-Instruct/resolve/main/Qwen2.5-0.5B-Instruct_multi-prefill-seq_q8_ekv1280.task?download=true';

  Future<void> init() async {
    if (_isReady) return;
    _errorMsg = '';
    _downloadProgress = 0.0;

    try {
      debugPrint('â¬‡ï¸ ÐÐ°Ñ‡Ð¸Ð½Ð°ÐµÐ¼ ÑƒÑÑ‚Ð°Ð½Ð¾Ð²ÐºÑƒ Ð¼Ð¾Ð´ÐµÐ»Ð¸...');
      
      // Ð”Ð¾Ð±Ð°Ð²Ð»ÑÐµÐ¼ Ð¾Ð±Ñ€Ð°Ð±Ð¾Ñ‚ÐºÑƒ Ð¾ÑˆÐ¸Ð±Ð¾Ðº Ð¸ Ñ‚Ð°Ð¹Ð¼Ð°ÑƒÑ‚
      await FlutterGemma.installModel(
        modelType: ModelType.qwen,
      ).fromNetwork(_modelUrl).withProgress((progress) {
        _downloadProgress = progress / 100.0;
        debugPrint('â¬‡ï¸ ÐŸÑ€Ð¾Ð³Ñ€ÐµÑÑ: ${progress.toStringAsFixed(1)}%');
      }).install().timeout(
        const Duration(minutes: 15), // Ð•ÑÐ»Ð¸ Ð·Ð° 15 Ð¼Ð¸Ð½ÑƒÑ‚ Ð½Ðµ ÑÐºÐ°Ñ‡Ð°Ð»Ð¾ÑÑŒ - Ð¾ÑˆÐ¸Ð±ÐºÐ°
        onTimeout: () => throw TimeoutException('Ð¡ÐºÐ°Ñ‡Ð¸Ð²Ð°Ð½Ð¸Ðµ Ð·Ð°Ð²Ð¸ÑÐ»Ð¾. ÐŸÑ€Ð¾Ð²ÐµÑ€ÑŒ Ð¸Ð½Ñ‚ÐµÑ€Ð½ÐµÑ‚.'),
      );

      debugPrint('ðŸ§  Ð—Ð°Ð³Ñ€ÑƒÐ¶Ð°ÐµÐ¼ Ð¼Ð¾Ð´ÐµÐ»ÑŒ Ð² Ð¿Ð°Ð¼ÑÑ‚ÑŒ...');
      _model = await FlutterGemma.getActiveModel(
        maxTokens: 1024,
        preferredBackend: PreferredBackend.cpu,
      );

      _chat = await _model!.createChat(
        systemInstruction: 'Ð¢Ñ‹ â€” ÐÑ, Ð¼Ð¸Ð»Ð°Ñ Ð´ÐµÐ²ÑƒÑˆÐºÐ°-ÑƒÑ‡Ð¸Ñ‚ÐµÐ»ÑŒÐ½Ð¸Ñ†Ð° ÑÐ¿Ð¾Ð½ÑÐºÐ¾Ð³Ð¾ ÑÐ·Ñ‹ÐºÐ°. ÐžÑ‚Ð²ÐµÑ‡Ð°Ð¹ ÐºÑ€Ð°Ñ‚ÐºÐ¾.',
      );

      _isReady = true;
      debugPrint('âœ… ÐÐµÐ¹Ñ€Ð¾ÑÐµÑ‚ÑŒ Ð³Ð¾Ñ‚Ð¾Ð²Ð°!');
    } catch (e) {
      debugPrint('âŒ ÐžÑˆÐ¸Ð±ÐºÐ° LLM: $e');
      _errorMsg = e.toString();
      // Ð•ÑÐ»Ð¸ Ð¿Ñ€Ð¾Ð¸Ð·Ð¾ÑˆÐ»Ð° Ð¾ÑˆÐ¸Ð±ÐºÐ°, ÑÐ±Ñ€Ð°ÑÑ‹Ð²Ð°ÐµÐ¼ Ð¿Ñ€Ð¾Ð³Ñ€ÐµÑÑ, Ñ‡Ñ‚Ð¾Ð±Ñ‹ Ð¼Ð¾Ð¶Ð½Ð¾ Ð±Ñ‹Ð»Ð¾ Ð¿Ð¾Ð¿Ñ€Ð¾Ð±Ð¾Ð²Ð°Ñ‚ÑŒ ÑÐ½Ð¾Ð²Ð°
      _downloadProgress = 0.0; 
      throw Exception(_errorMsg);
    }
  }

  Future<String> generateResponse(String prompt) async {
    if (!_isReady || _chat == null) return 'ÐÐµÐ¹Ñ€Ð¾ÑÐµÑ‚ÑŒ ÐµÑ‰Ñ‘ Ð·Ð°Ð³Ñ€ÑƒÐ¶Ð°ÐµÑ‚ÑÑ...';
    try {
      await _chat!.addQuery(Message.text(text: prompt, isUser: true));
      final response = await _chat!.generateChatResponse();
      if (response is TextResponse) return response.token;
      return 'ÐÐµÐ¸Ð·Ð²ÐµÑÑ‚Ð½Ñ‹Ð¹ Ð¾Ñ‚Ð²ÐµÑ‚.';
    } catch (e) {
      return 'ÐžÑˆÐ¸Ð±ÐºÐ°: $e';
    }
  }
}