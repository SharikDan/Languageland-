import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:ayas_languageland/logic/services/local_llm_service.dart';
import 'package:ayas_languageland/logic/services/audio_service.dart';
import 'package:ayas_languageland/logic/services/ai_service.dart';
import 'package:ayas_languageland/logic/services/app_localizations.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<Map<String, dynamic>> _messages = [];
  bool _isTyping = false, _isModelLoading = true;
  double _progress = 0.0;
  String _errorMsg = '';
  Timer? _progressTimer;

  @override
  void initState() {
    super.initState();
    _messages.add({'isUser': false, 'text': 'Hello! I am Aya. 🤖 (Loading neurons...)'});
    if (!kIsWeb) { _loadModel(); } else {
      setState(() {
        _isModelLoading = false;
        _messages.add({'isUser': false, 'text': 'Hello! I am Aya. In the browser I work in lightweight mode. But on the phone I will become a real AI!'});
      });
    }
  }

  Future<void> _loadModel() async {
    _progressTimer = Timer.periodic(const Duration(milliseconds: 500), (timer) { if (mounted && !LocalLlmService.instance.isReady) setState(() => _progress = LocalLlmService.instance.downloadProgress); });
    try {
      await LocalLlmService.instance.init();
      if (mounted) { setState(() { _isModelLoading = false; _messages.add({'isUser': false, 'text': 'Yay! My neurons are loaded.'}); }); _scrollToBottom(); }
    } catch (e) { if (mounted) setState(() { _isModelLoading = false; _errorMsg = 'Error: $e'; }); } finally { _progressTimer?.cancel(); }
  }

  @override
  void dispose() { _progressTimer?.cancel(); super.dispose(); }

  void _sendMessage(String text) async {
    if (text.trim().isEmpty || _isModelLoading) return;
    setState(() { _messages.add({'isUser': true, 'text': text}); _isTyping = true; });
    _controller.clear(); _scrollToBottom(); AudioService.playSound('tap.mp3');
    String response;
    if (kIsWeb) { await Future.delayed(const Duration(milliseconds: 600)); response = AyaAi.getResponse(text); } else { response = await LocalLlmService.instance.generateResponse(text); }
    setState(() { _isTyping = false; _messages.add({'isUser': false, 'text': response}); }); _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) { if (_scrollController.hasClients) { _scrollController.animateTo(_scrollController.position.maxScrollExtent, duration: const Duration(milliseconds: 300), curve: Curves.easeOut); } });
  }

  @override
  Widget build(BuildContext context) {
    const accent = Color(0xFFE91E63);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF0F0F17) : const Color(0xFFFFF5F8);
    final cardColor = isDark ? const Color(0xFF1C1C28) : Colors.white;
    final textColor = isDark ? const Color(0xFFEDEDF2) : const Color(0xFF2C2C2C);
    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Column(
          children: [
            Container(padding: const EdgeInsets.all(24), decoration: BoxDecoration(color: cardColor, borderRadius: const BorderRadius.vertical(bottom: Radius.circular(32))), child: Row(children: [Container(width: 50, height: 50, decoration: BoxDecoration(color: accent.withValues(alpha: 0.1), shape: BoxShape.circle), child: const Icon(Icons.smart_toy, color: accent, size: 30)), const SizedBox(width: 16), Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const Text('Aya (AI)', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)), Text(_isModelLoading ? 'Loading...' : 'Online', style: TextStyle(fontSize: 12, color: _isModelLoading ? Colors.orange : Colors.green.shade600, fontWeight: FontWeight.bold))])])),
            if (_isModelLoading) Padding(padding: const EdgeInsets.all(24.0), child: LinearProgressIndicator(value: _progress > 0 ? _progress : null)),
            if (_errorMsg.isNotEmpty) Expanded(child: Center(child: Text(_errorMsg, style: const TextStyle(color: Colors.red)))),
            if (_errorMsg.isEmpty) Expanded(child: ListView.builder(controller: _scrollController, padding: const EdgeInsets.all(24), itemCount: _messages.length, itemBuilder: (context, index) { final msg = _messages[index]; final isUser = msg['isUser'] as bool; return Align(alignment: isUser ? Alignment.centerRight : Alignment.centerLeft, child: Container(margin: const EdgeInsets.only(bottom: 16), padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14), constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.65), decoration: BoxDecoration(color: isUser ? accent : cardColor, borderRadius: BorderRadius.circular(20)), child: Text(msg['text'], style: TextStyle(fontSize: 16, color: isUser ? Colors.white : textColor, height: 1.4)))); })),
            if (_isTyping) Padding(padding: const EdgeInsets.only(left: 32, bottom: 16), child: Text('Aya is thinking...', style: TextStyle(color: Colors.grey.shade600, fontStyle: FontStyle.italic))),
            if (_errorMsg.isEmpty) Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: cardColor, borderRadius: const BorderRadius.vertical(top: Radius.circular(32))), child: Row(children: [Expanded(child: TextField(controller: _controller, enabled: !_isModelLoading, decoration: InputDecoration(hintText: _isModelLoading ? 'Waiting...' : 'Type a message...', filled: true, fillColor: isDark ? const Color(0xFF23232F) : const Color(0xFFFFF5F8), border: OutlineInputBorder(borderRadius: BorderRadius.circular(999), borderSide: BorderSide.none)), onSubmitted: _sendMessage)), const SizedBox(width: 12), Container(decoration: BoxDecoration(color: _isModelLoading ? Colors.grey : accent, shape: BoxShape.circle), child: IconButton(icon: const Icon(Icons.send_rounded, color: Colors.white), onPressed: _isModelLoading ? null : () => _sendMessage(_controller.text)))])),
          ],
        ),
      ),
    );
  }
}