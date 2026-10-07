import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_tts/flutter_tts.dart';

class AiGuruScreen extends StatefulWidget {
  const AiGuruScreen({Key? key}) : super(key: key);

  @override
  State<AiGuruScreen> createState() => _AiGuruScreenState();
}

class _AiGuruScreenState extends State<AiGuruScreen> {
  final TextEditingController _textController = TextEditingController();
  final List<Map<String, String>> _messages = [];
  final ScrollController _scrollController = ScrollController();
  
  bool _isLoading = false;
  ChatSession? _chatSession;
  FlutterTts flutterTts = FlutterTts();

  // Ключ берется из SharedPreferences (Настройки)
  static const String _defaultApiKey = '';

  @override
  void initState() {
    super.initState();
    _initTts();
    _initChat();
  }

  Future<void> _initTts() async {
    await flutterTts.setLanguage("ru-RU");
    await flutterTts.setSpeechRate(0.5);
    await flutterTts.setVolume(1.0);
    await flutterTts.setPitch(1.0);
  }

  Future<void> _initChat() async {
    final prefs = await SharedPreferences.getInstance();
    String apiKey = prefs.getString('gemini_api_key') ?? '';
    if (apiKey.isEmpty) {
      apiKey = _defaultApiKey;
    }

    final model = GenerativeModel(
      model: 'gemini-2.5-flash',
      apiKey: apiKey,
      systemInstruction: Content.system(
        "Ты — жесткий, бескомпромиссный ИИ-наставник. Твоя единственная цель — не дать человеку закурить. "
        "Пользователь пытается бросить курить. Если он ищет оправдания (стресс, усталость, \"всего одну\"), "
        "ты должен категорически запретить это. Никаких поблажек. Разговаривай уверенно, жестко, но по делу, "
        "как строгий тренер. Не используй маркдаун для выделения текста, пиши простым текстом, так как твой текст будет озвучиваться голосом."
      ),
    );

    _chatSession = model.startChat();
    
    // Initial greeting
    const greeting = "Привет. Я твой ИИ-наставник. Если захочешь сорваться и покурить — пиши мне. Я быстро вправлю тебе мозги.";
    setState(() {
      _messages.add({'role': 'model', 'text': greeting});
    });
    _speak(greeting);
  }

  Future<void> _speak(String text) async {
    await flutterTts.speak(text);
  }

  Future<void> _sendMessage(String text) async {
    if (text.trim().isEmpty || _chatSession == null) return;

    setState(() {
      _messages.add({'role': 'user', 'text': text});
      _isLoading = true;
    });
    _textController.clear();
    _scrollToBottom();

    try {
      final response = await _chatSession!.sendMessage(Content.text(text));
      final responseText = response.text ?? "Оставайся сильным. Не кури.";
      
      setState(() {
        _messages.add({'role': 'model', 'text': responseText});
      });
      _speak(responseText);
    } catch (e) {
      setState(() {
        _messages.add({'role': 'model', 'text': 'Ошибка подключения. Но ты всё равно не должен курить!'});
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    flutterTts.stop();
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text('AI Гуру', style: TextStyle(fontWeight: FontWeight.w600)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                final isUser = msg['role'] == 'user';
                return Align(
                  alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: isUser ? Colors.white24 : Colors.black45,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.white10),
                    ),
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.8,
                    ),
                    child: Text(
                      msg['text']!,
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                );
              },
            ),
          ),
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: CircularProgressIndicator(color: Colors.white),
            ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _textController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Хочу курить...',
                      hintStyle: const TextStyle(color: Colors.white54),
                      filled: true,
                      fillColor: Colors.black45,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                    ),
                    onSubmitted: _sendMessage,
                  ),
                ),
                const SizedBox(width: 8),
                CircleAvatar(
                  backgroundColor: Colors.white,
                  child: IconButton(
                    icon: const Icon(Icons.send, color: Colors.black),
                    onPressed: () => _sendMessage(_textController.text),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
