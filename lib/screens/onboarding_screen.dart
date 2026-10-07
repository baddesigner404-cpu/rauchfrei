import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/user_data.dart';
import '../providers/user_provider.dart';
import 'main_screen.dart';
import '../widgets/glass_card.dart';

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
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF0F1A15),
                  Color(0xFF070707),
                  Color(0xFF0A0F1A),
                ],
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 20),
                  Center(
                    child: GlassCard(
                      child: Container(
                        width: 100,
                        height: 100,
                        padding: const EdgeInsets.all(8.0),
                        child: Image.asset('assets/images/logo.png', fit: BoxFit.contain),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'No Smoking\nNo Vaping',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 40),
                  GlassCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text('Когда вы выкурили последнюю сигарету/вейп?', style: TextStyle(fontSize: 16, color: Colors.white70)),
                        const SizedBox(height: 12),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white10,
                            foregroundColor: Colors.white,
                          ),
                          onPressed: _pickDateTime,
                          child: Text('${_quitDate.day}.${_quitDate.month}.${_quitDate.year} ${_quitTime.format(context)}'),
                        ),
                        const SizedBox(height: 20),
                        TextField(
                          controller: _cigPerDayController,
                          keyboardType: TextInputType.number,
                          style: const TextStyle(color: Colors.white),
                          decoration: const InputDecoration(
                            labelText: 'Стиков/сигарет в день (в среднем)',
                            labelStyle: TextStyle(color: Colors.white54),
                            enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white24)),
                            focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _pricePerPackController,
                                keyboardType: TextInputType.number,
                                style: const TextStyle(color: Colors.white),
                                decoration: const InputDecoration(
                                  labelText: 'Цена пачки / жижи',
                                  labelStyle: TextStyle(color: Colors.white54),
                                  enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white24)),
                                  focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: TextField(
                                controller: _cigInPackController,
                                keyboardType: TextInputType.number,
                                style: const TextStyle(color: Colors.white),
                                decoration: const InputDecoration(
                                  labelText: 'Штук в пачке',
                                  labelStyle: TextStyle(color: Colors.white54),
                                  enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white24)),
                                  focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  GlassCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SwitchListTile(
                          title: const Text('Я принимаю препарат с Цитизином', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                          subtitle: const Text('Табекс, Десмоксан и т.д.', style: TextStyle(color: Colors.white54)),
                          value: _isTakingCytisine,
                          activeColor: Colors.white,
                          onChanged: (val) => setState(() => _isTakingCytisine = val),
                        ),
                        if (_isTakingCytisine) ...[
                          const SizedBox(height: 10),
                          const Text('Когда начат курс?', style: TextStyle(fontSize: 16, color: Colors.white70)),
                          const SizedBox(height: 8),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white10,
                              foregroundColor: Colors.white,
                            ),
                            onPressed: _pickCytisineDate,
                            child: Text('${_cytisineStartDate.day}.${_cytisineStartDate.month}.${_cytisineStartDate.year}'),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    onPressed: _saveAndStart,
                    child: const Text('НАЧАТЬ НОВУЮ ЖИЗНЬ', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
