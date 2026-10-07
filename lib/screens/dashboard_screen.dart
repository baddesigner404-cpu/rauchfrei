import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import '../models/cytisine_schedule.dart';
import '../widgets/glass_card.dart';
import '../utils/reload.dart';

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
      backgroundColor: Colors.transparent, // Важно для стекла! Фон будет в MainScreen
      appBar: AppBar(
        title: GestureDetector(
          onDoubleTap: () {
            reloadWebPage();
          },
          child: const Text('Rauchfrei', style: TextStyle(fontWeight: FontWeight.w600)),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 10),
              GlassCard(
                child: Column(
                  children: [
                    const Text(
                      'Время без сигарет',
                      style: TextStyle(fontSize: 16, color: Colors.white70),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '$days дн. $hours ч.',
                      style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              GlassCard(
                child: Column(
                  children: [
                    const Text('Сэкономлено', style: TextStyle(fontSize: 16, color: Colors.white70)),
                    const SizedBox(height: 10),
                    Text(
                      '${savedMoney.toStringAsFixed(0)} ₽', 
                      style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
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
      return const GlassCard(
        child: Text('Курс поддержки завершен!', textAlign: TextAlign.center, style: TextStyle(color: Colors.white)),
      );
    }

    return GlassCard(
      borderColor: Colors.white.withOpacity(0.2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Курс поддержки: День $currentDay', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
          const SizedBox(height: 12),
          Text('Сегодня нужно принять: $pillsCount шт.', style: const TextStyle(color: Colors.white70)),
          const SizedBox(height: 4),
          Text('Интервал: $interval', style: const TextStyle(color: Colors.white70)),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(
              pillsCount,
              (index) => const Icon(Icons.circle, size: 24, color: Colors.white70),
            ),
          ),
        ],
      ),
    );
  }
}
