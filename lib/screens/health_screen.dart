import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/health_milestone.dart';
import '../providers/user_provider.dart';
import '../widgets/glass_card.dart';

class HealthScreen extends StatelessWidget {
  const HealthScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final userData = userProvider.userData;

    if (userData == null) {
      return const Center(child: CircularProgressIndicator());
    }

    final now = DateTime.now();
    final durationPassed = now.difference(userData.quitDate);

    return Scaffold(
      backgroundColor: Colors.transparent, // Фон берется из MainScreen
      appBar: AppBar(
        title: const Text('Здоровье', style: TextStyle(fontWeight: FontWeight.w600)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: healthMilestones.length,
        itemBuilder: (context, index) {
          final milestone = healthMilestones[index];
          final requiredMillis = milestone.requiredDuration.inMilliseconds;
          final passedMillis = durationPassed.inMilliseconds;
          
          double progress = passedMillis / requiredMillis;
          if (progress > 1.0) progress = 1.0;
          if (progress < 0.0) progress = 0.0;

          final bool isAchieved = progress == 1.0;

          return Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: GlassCard(
              borderColor: isAchieved ? Colors.green.withOpacity(0.3) : Colors.white10,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          milestone.title,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: isAchieved ? Colors.greenAccent : Colors.white,
                          ),
                        ),
                      ),
                      if (isAchieved)
                        const Icon(Icons.check_circle, color: Colors.greenAccent),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(milestone.description, style: const TextStyle(color: Colors.white70)),
                  const SizedBox(height: 16),
                  LinearProgressIndicator(
                    value: progress,
                    backgroundColor: Colors.white10,
                    color: isAchieved ? Colors.greenAccent : Colors.blueAccent,
                    minHeight: 8,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '${(progress * 100).toStringAsFixed(1)}%',
                    style: const TextStyle(fontSize: 12, color: Colors.white70),
                    textAlign: TextAlign.right,
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
