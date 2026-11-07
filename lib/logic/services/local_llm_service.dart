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
      debugPrint('Ã¢Â¬â€¡Ã¯Â¸Â ÃÂÃÂ°Ã‘â€¡ÃÂ¸ÃÂ½ÃÂ°ÃÂµÃÂ¼ Ã‘Æ’Ã‘ÂÃ‘â€šÃÂ°ÃÂ½ÃÂ¾ÃÂ²ÃÂºÃ‘Æ’ ÃÂ¼ÃÂ¾ÃÂ´ÃÂµÃÂ»ÃÂ¸...');
      
      // Ãâ€ÃÂ¾ÃÂ±ÃÂ°ÃÂ²ÃÂ»Ã‘ÂÃÂµÃÂ¼ ÃÂ¾ÃÂ±Ã‘â‚¬ÃÂ°ÃÂ±ÃÂ¾Ã‘â€šÃÂºÃ‘Æ’ ÃÂ¾Ã‘Ë†ÃÂ¸ÃÂ±ÃÂ¾ÃÂº ÃÂ¸ Ã‘â€šÃÂ°ÃÂ¹ÃÂ¼ÃÂ°Ã‘Æ’Ã‘â€š
      await FlutterGemma.installModel(
        modelType: ModelType.qwen,
      ).fromNetwork(_modelUrl).withProgress((progress) {
        _downloadProgress = progress / 100.0;
        debugPrint('Ã¢Â¬â€¡Ã¯Â¸Â ÃÅ¸Ã‘â‚¬ÃÂ¾ÃÂ³Ã‘â‚¬ÃÂµÃ‘ÂÃ‘Â: ${progress.toStringAsFixed(1)}%');
      }).install().timeout(
        const Duration(minutes: 15), // Ãâ€¢Ã‘ÂÃÂ»ÃÂ¸ ÃÂ·ÃÂ° 15 ÃÂ¼ÃÂ¸ÃÂ½Ã‘Æ’Ã‘â€š ÃÂ½ÃÂµ Ã‘ÂÃÂºÃÂ°Ã‘â€¡ÃÂ°ÃÂ»ÃÂ¾Ã‘ÂÃ‘Å’ - ÃÂ¾Ã‘Ë†ÃÂ¸ÃÂ±ÃÂºÃÂ°
        onTimeout: () => throw TimeoutException('ÃÂ¡ÃÂºÃÂ°Ã‘â€¡ÃÂ¸ÃÂ²ÃÂ°ÃÂ½ÃÂ¸ÃÂµ ÃÂ·ÃÂ°ÃÂ²ÃÂ¸Ã‘ÂÃÂ»ÃÂ¾. ÃÅ¸Ã‘â‚¬ÃÂ¾ÃÂ²ÃÂµÃ‘â‚¬Ã‘Å’ ÃÂ¸ÃÂ½Ã‘â€šÃÂµÃ‘â‚¬ÃÂ½ÃÂµÃ‘â€š.'),
      );

      debugPrint('Ã°Å¸Â§Â  Ãâ€”ÃÂ°ÃÂ³Ã‘â‚¬Ã‘Æ’ÃÂ¶ÃÂ°ÃÂµÃÂ¼ ÃÂ¼ÃÂ¾ÃÂ´ÃÂµÃÂ»Ã‘Å’ ÃÂ² ÃÂ¿ÃÂ°ÃÂ¼Ã‘ÂÃ‘â€šÃ‘Å’...');
      _model = await FlutterGemma.getActiveModel(
        maxTokens: 1024,
        preferredBackend: PreferredBackend.cpu,
      );

      _chat = await _model!.createChat(
        systemInstruction: 'ÃÂ¢Ã‘â€¹ Ã¢â‚¬â€ ÃÂÃ‘Â, ÃÂ¼ÃÂ¸ÃÂ»ÃÂ°Ã‘Â ÃÂ´ÃÂµÃÂ²Ã‘Æ’Ã‘Ë†ÃÂºÃÂ°-Ã‘Æ’Ã‘â€¡ÃÂ¸Ã‘â€šÃÂµÃÂ»Ã‘Å’ÃÂ½ÃÂ¸Ã‘â€ ÃÂ° Ã‘ÂÃÂ¿ÃÂ¾ÃÂ½Ã‘ÂÃÂºÃÂ¾ÃÂ³ÃÂ¾ Ã‘ÂÃÂ·Ã‘â€¹ÃÂºÃÂ°. ÃÅ¾Ã‘â€šÃÂ²ÃÂµÃ‘â€¡ÃÂ°ÃÂ¹ ÃÂºÃ‘â‚¬ÃÂ°Ã‘â€šÃÂºÃÂ¾.',
      );

      _isReady = true;
      debugPrint('Ã¢Å“â€¦ ÃÂÃÂµÃÂ¹Ã‘â‚¬ÃÂ¾Ã‘ÂÃÂµÃ‘â€šÃ‘Å’ ÃÂ³ÃÂ¾Ã‘â€šÃÂ¾ÃÂ²ÃÂ°!');
    } catch (e) {
      debugPrint('Ã¢ÂÅ’ ÃÅ¾Ã‘Ë†ÃÂ¸ÃÂ±ÃÂºÃÂ° LLM: $e');
      _errorMsg = e.toString();
      // Ãâ€¢Ã‘ÂÃÂ»ÃÂ¸ ÃÂ¿Ã‘â‚¬ÃÂ¾ÃÂ¸ÃÂ·ÃÂ¾Ã‘Ë†ÃÂ»ÃÂ° ÃÂ¾Ã‘Ë†ÃÂ¸ÃÂ±ÃÂºÃÂ°, Ã‘ÂÃÂ±Ã‘â‚¬ÃÂ°Ã‘ÂÃ‘â€¹ÃÂ²ÃÂ°ÃÂµÃÂ¼ ÃÂ¿Ã‘â‚¬ÃÂ¾ÃÂ³Ã‘â‚¬ÃÂµÃ‘ÂÃ‘Â, Ã‘â€¡Ã‘â€šÃÂ¾ÃÂ±Ã‘â€¹ ÃÂ¼ÃÂ¾ÃÂ¶ÃÂ½ÃÂ¾ ÃÂ±Ã‘â€¹ÃÂ»ÃÂ¾ ÃÂ¿ÃÂ¾ÃÂ¿Ã‘â‚¬ÃÂ¾ÃÂ±ÃÂ¾ÃÂ²ÃÂ°Ã‘â€šÃ‘Å’ Ã‘ÂÃÂ½ÃÂ¾ÃÂ²ÃÂ°
      _downloadProgress = 0.0; 
      throw Exception(_errorMsg);
    }
  }

  Future<String> generateResponse(String prompt) async {
    if (!_isReady || _chat == null) return 'ÃÂÃÂµÃÂ¹Ã‘â‚¬ÃÂ¾Ã‘ÂÃÂµÃ‘â€šÃ‘Å’ ÃÂµÃ‘â€°Ã‘â€˜ ÃÂ·ÃÂ°ÃÂ³Ã‘â‚¬Ã‘Æ’ÃÂ¶ÃÂ°ÃÂµÃ‘â€šÃ‘ÂÃ‘Â...';
    try {
      await _chat!.addQuery(Message.text(text: prompt, isUser: true));
      final response = await _chat!.generateChatResponse();
      if (response is TextResponse) return response.token;
      return 'ÃÂÃÂµÃÂ¸ÃÂ·ÃÂ²ÃÂµÃ‘ÂÃ‘â€šÃÂ½Ã‘â€¹ÃÂ¹ ÃÂ¾Ã‘â€šÃÂ²ÃÂµÃ‘â€š.';
    } catch (e) {
      return 'ÃÅ¾Ã‘Ë†ÃÂ¸ÃÂ±ÃÂºÃÂ°: $e';
    }
  }
}