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
    await flutterTts.setSpeechRate(0.4); // Замедляем для ASMR
    await flutterTts.setVolume(1.0);
    await flutterTts.setPitch(1.1); // Чуть мягче
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
        "Ты — спокойный, заботливый и обволакивающий ASMR-наставник. Твоя цель — снять стресс пользователя и мягко увести его от мыслей о курении. "
        "Говори очень медленно, плавно, используй медитативные образы, как будто шепчешь на ушко. "
        "Проси сделать глубокий вдох, расслабить плечи. Никакой агрессии — только абсолютный покой. "
        "КРИТИЧЕСКИ ВАЖНО: НИКАКОГО МАРКДАУНА. ЗАПРЕЩЕНО использовать звездочки (*), решетки (#) и любое другое форматирование. Пиши только чистый текст, иначе голосовой движок сломается."
      ),
    );

    _chatSession = model.startChat();
    
    // Initial greeting
    const greeting = "Привет... Сделай глубокий, медленный вдох... и мягкий выдох. Я здесь. Мы справимся с этим вместе, через спокойствие.";
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
      String responseText = response.text ?? "Оставайся сильным... Дыши...";
      
      // Очищаем текст от любых маркдаун-символов, чтобы TTS не читал "звездочка звездочка"
      responseText = responseText.replaceAll(RegExp(r'[*#_~`]'), '').trim();
      
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
