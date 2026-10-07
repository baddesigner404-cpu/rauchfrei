import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../providers/user_provider.dart';
import '../utils/reload.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final TextEditingController _apiKeyController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadApiKey();
  }

  Future<void> _loadApiKey() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _apiKeyController.text = prefs.getString('gemini_api_key') ?? '';
    });
  }

  Future<void> _saveApiKey(String key) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('gemini_api_key', key.trim());
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('API-ключ сохранен!'), backgroundColor: Colors.green),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: GestureDetector(
          onDoubleTap: () => reloadWebPage(),
          child: const Text('Настройки', style: TextStyle(fontWeight: FontWeight.w600)),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
        padding: const EdgeInsets.all(16.0),
        children: [
          const Text('AI Гуру', style: TextStyle(color: Colors.white70, fontSize: 14, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          TextField(
            controller: _apiKeyController,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              labelText: 'Gemini API Key',
              labelStyle: TextStyle(color: Colors.white54),
              enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white24)),
              focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
            ),
            onSubmitted: _saveApiKey,
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () => _saveApiKey(_apiKeyController.text),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white10,
              foregroundColor: Colors.white,
            ),
            child: const Text('Сохранить ключ'),
          ),
          const SizedBox(height: 32),
          const Divider(color: Colors.white10),
          ListTile(
            leading: const Icon(Icons.edit, color: Colors.white70),
            title: const Text('Изменить данные', style: TextStyle(color: Colors.white)),
            subtitle: const Text('Пройти настройку заново', style: TextStyle(color: Colors.white54)),
            onTap: () => _showResetDialog(context, 'Изменить данные?'),
          ),
          const Divider(color: Colors.white10),
          ListTile(
            leading: const Icon(Icons.delete_forever, color: Colors.white70),
            title: const Text('Сбросить прогресс', style: TextStyle(color: Colors.white)),
            onTap: () => _showResetDialog(context, 'Сбросить прогресс?'),
          ),
        ],
      ),
    );
  }

  Future<void> _showResetDialog(BuildContext context, String title) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A1A),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(title, style: const TextStyle(color: Colors.white)),
        content: const Text('Все ваши текущие данные и счетчики будут удалены. Вам придется заново вводить данные.', style: TextStyle(color: Colors.white70)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Отмена', style: TextStyle(color: Colors.white54)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Сбросить', style: TextStyle(color: Colors.redAccent)),
          ),
        ],
      ),
    );

    if (confirm == true && context.mounted) {
      await Provider.of<UserProvider>(context, listen: false).clearUserData();
    }
  }
}
