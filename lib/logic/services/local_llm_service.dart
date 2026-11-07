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
      debugPrint('⬇️ Устанавливаем модель...');
      
      await FlutterGemma.installModel(
        modelType: ModelType.qwen,
      ).fromNetwork(_modelUrl).withProgress((progress) {
        _downloadProgress = progress / 100.0;
      }).install();

      debugPrint('🧠 Загружаем модель в память...');
      _model = await FlutterGemma.getActiveModel(
        maxTokens: 1024,
        preferredBackend: PreferredBackend.gpu,
      );

      _chat = await _model!.createChat(
        systemInstruction: 'Ты — Ая, милая девушка-учительница японского языка. Отвечай кратко.',
      );

      _isReady = true;
      debugPrint('✅ Нейросеть готова!');
    } catch (e) {
      debugPrint('❌ Ошибка LLM: $e');
      _errorMsg = e.toString();
      // Не удаляем модель, просто сообщаем об ошибке
      throw Exception(_errorMsg);
    }
  }

  Future<String> generateResponse(String prompt) async {
    if (!_isReady || _chat == null) return 'Нейросеть ещё загружается...';
    try {
      await _chat!.addQuery(Message.text(text: prompt, isUser: true));
      final response = await _chat!.generateChatResponse();
      if (response is TextResponse) return response.token;
      return 'Неизвестный ответ.';
    } catch (e) {
      return 'Ошибка: $e';
    }
  }
}