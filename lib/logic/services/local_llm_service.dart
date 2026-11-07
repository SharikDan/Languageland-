import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_gemma/flutter_gemma.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

class LocalLlmService {
  static final LocalLlmService instance = LocalLlmService._();
  LocalLlmService._();

  InferenceModel? _model;
  InferenceChat? _chat;
  bool _isReady = false;
  bool get isReady => _isReady;

  double _downloadProgress = 0.0;
  double get downloadProgress => _downloadProgress;
  bool _isInitializing = false;

  final String _modelUrl = 'https://huggingface.co/litert-community/Qwen2.5-1.5B-Instruct/resolve/main/Qwen2.5-1.5B-Instruct_multi-prefill-seq_q8_ekv1280.task?download=true';
  final String _modelFileName = 'qwen_model.task';

  Future<void> init() async {
    if (_isReady || _isInitializing || kIsWeb) return;
    _isInitializing = true;

    try {
      final dir = await getApplicationDocumentsDirectory();
      final modelFile = File('${dir.path}/$_modelFileName');

      if (!await modelFile.exists()) {
        debugPrint('⬇️ Начинаем скачивание модели...');
        final request = http.Request('GET', Uri.parse(_modelUrl));
        final response = await http.Client().send(request);
        
        if (response.statusCode != 200) throw Exception('Ошибка скачивания: ${response.statusCode}');

        final total = response.contentLength ?? 0;
        int received = 0;
        final sink = modelFile.openWrite();

        await for (final chunk in response.stream) {
          sink.add(chunk);
          received += chunk.length;
          if (total > 0) _downloadProgress = received / total;
        }
        await sink.close();
      }

      debugPrint('🧠 Загружаем модель в память...');
      _model = await FlutterGemmaPlugin.instance.createModel(
        modelType: ModelType.qwen,
        maxTokens: 1024,
        preferredBackend: PreferredBackend.gpu,
      );

      _chat = await _model!.createChat(
        systemInstruction: 'Ты — Ая, милая девушка-учительница японского языка. Отвечай кратко.',
      );

      _isReady = true;
      _isInitializing = false;
    } catch (e) {
      _isInitializing = false;
      debugPrint('❌ Ошибка LLM: $e');
      throw Exception('Ошибка загрузки: $e');
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