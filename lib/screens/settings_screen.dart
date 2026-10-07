import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text('Настройки', style: TextStyle(fontWeight: FontWeight.w600)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          ListTile(
            leading: const Icon(Icons.edit, color: Colors.white70),
            title: const Text('Изменить данные', style: TextStyle(color: Colors.white)),
            subtitle: const Text('Дата отказа, кол-во сигарет', style: TextStyle(color: Colors.white54)),
            onTap: () {
              // TODO: Возврат на онбординг или открытие модального окна
            },
          ),
          const Divider(color: Colors.white10),
          ListTile(
            leading: const Icon(Icons.delete_forever, color: Colors.white70),
            title: const Text('Сбросить прогресс', style: TextStyle(color: Colors.white)),
            onTap: () {
              // TODO: Диалог подтверждения и очистка
            },
          ),
        ],
      ),
    );
  }
}
