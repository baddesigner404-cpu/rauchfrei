import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/user_data.dart';
import '../providers/user_provider.dart';
import 'main_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  DateTime _quitDate = DateTime.now();
  TimeOfDay _quitTime = TimeOfDay.now();
  
  final _cigPerDayController = TextEditingController(text: '20');
  final _pricePerPackController = TextEditingController(text: '200');
  final _cigInPackController = TextEditingController(text: '20');
  
  bool _isTakingCytisine = false;
  DateTime _cytisineStartDate = DateTime.now();

  Future<void> _pickDateTime() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _quitDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (date != null) {
      final time = await showTimePicker(
        context: context,
        initialTime: _quitTime,
      );
      if (time != null) {
        setState(() {
          _quitDate = date;
          _quitTime = time;
        });
      }
    }
  }

  Future<void> _pickCytisineDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _cytisineStartDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now().add(const Duration(days: 30)),
    );
    if (date != null) {
      setState(() {
        _cytisineStartDate = date;
      });
    }
  }

  void _saveAndStart() {
    final cigPerDay = int.tryParse(_cigPerDayController.text) ?? 20;
    final pricePerPack = double.tryParse(_pricePerPackController.text) ?? 200.0;
    final cigInPack = int.tryParse(_cigInPackController.text) ?? 20;

    final finalQuitDateTime = DateTime(
      _quitDate.year,
      _quitDate.month,
      _quitDate.day,
      _quitTime.hour,
      _quitTime.minute,
    );

    final data = UserData(
      quitDate: finalQuitDateTime,
      cigarettesPerDay: cigPerDay,
      pricePerPack: pricePerPack,
      cigarettesInPack: cigInPack,
      isTakingCytisine: _isTakingCytisine,
      cytisineStartDate: _isTakingCytisine ? _cytisineStartDate : null,
    );

    Provider.of<UserProvider>(context, listen: false).saveUserData(data);
    
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const MainScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Настройка Rauchfrei')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('Когда вы выкурили последнюю сигарету?', style: TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: _pickDateTime,
              child: Text('${_quitDate.day}.${_quitDate.month}.${_quitDate.year} ${_quitTime.format(context)}'),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _cigPerDayController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Сигарет в день (в среднем)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _pricePerPackController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Цена пачки',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextField(
                    controller: _cigInPackController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Штук в пачке',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            SwitchListTile(
              title: const Text('Я принимаю препарат с Цитизином', style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: const Text('Табекс, Десмоксан и т.д.'),
              value: _isTakingCytisine,
              onChanged: (val) => setState(() => _isTakingCytisine = val),
            ),
            if (_isTakingCytisine) ...[
              const SizedBox(height: 10),
              const Text('Когда начат курс?', style: TextStyle(fontSize: 16)),
              ElevatedButton(
                onPressed: _pickCytisineDate,
                child: Text('${_cytisineStartDate.day}.${_cytisineStartDate.month}.${_cytisineStartDate.year}'),
              ),
            ],
            const SizedBox(height: 40),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
              onPressed: _saveAndStart,
              child: const Text('НАЧАТЬ НОВУЮ ЖИЗНЬ', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}
