import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import '../utils/reload.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
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
