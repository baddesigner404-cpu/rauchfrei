import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import '../models/cytisine_schedule.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final userData = userProvider.userData;

    if (userData == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final duration = DateTime.now().difference(userData.quitDate);
    final days = duration.inDays;
    final hours = duration.inHours % 24;
    
    // Quick savings calculation
    final daysPassed = duration.inDays + (duration.inHours % 24) / 24.0;
    final packsNotSmoked = (userData.cigarettesPerDay * daysPassed) / userData.cigarettesInPack;
    final savedMoney = packsNotSmoked * userData.pricePerPack;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Rauchfrei'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Время без сигарет:',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(
                '$days дн. $hours ч.',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 48, color: Colors.green, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 30),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      const Text('Сэкономлено', style: TextStyle(fontSize: 18)),
                      const SizedBox(height: 10),
                      Text(
                        '${savedMoney.toStringAsFixed(2)} ₽', // Replace symbol later with preference
                        style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.blue),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              if (userData.isTakingCytisine && userData.cytisineStartDate != null)
                _buildCytisineWidget(userData.cytisineStartDate!),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCytisineWidget(DateTime startDate) {
    final currentDay = CytisineSchedule.getCurrentDayOfCourse(startDate);
    final pillsCount = CytisineSchedule.getPillsForDay(currentDay);
    final interval = CytisineSchedule.getIntervalForDay(currentDay);

    if (pillsCount == 0) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Text('Курс Цитизина завершен! Вы молодец!', textAlign: TextAlign.center),
        ),
      );
    }

    return Card(
      color: const Color(0xFF2A1C0E), // Темно-оранжевый/коричневый для темной темы
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.orange.shade700, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Курс Цитизина: День $currentDay', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.orange)),
            const SizedBox(height: 8),
            Text('Сегодня нужно принять: $pillsCount табл.', style: const TextStyle(color: Colors.white70)),
            Text('Интервал: $interval', style: const TextStyle(color: Colors.white70)),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(
                pillsCount,
                (index) => const Icon(Icons.medication, color: Colors.orange, size: 32),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
