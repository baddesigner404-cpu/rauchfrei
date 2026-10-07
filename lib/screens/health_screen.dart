import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/health_milestone.dart';
import '../providers/user_provider.dart';

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
      appBar: AppBar(
        title: const Text('Здоровье'),
        centerTitle: true,
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

          return Card(
            margin: const EdgeInsets.only(bottom: 16.0),
            color: isAchieved ? const Color(0xFF1B3320) : const Color(0xFF1A1A1A), // Темно-зеленый если выполнено, иначе темно-серый
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: isAchieved ? const BorderSide(color: Colors.green, width: 1) : BorderSide.none,
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
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
                            color: isAchieved ? Colors.green.shade400 : Colors.white,
                          ),
                        ),
                      ),
                      if (isAchieved)
                        const Icon(Icons.check_circle, color: Colors.green),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    milestone.description,
                    style: const TextStyle(color: Colors.white70),
                  ),
                  const SizedBox(height: 12),
                  LinearProgressIndicator(
                    value: progress,
                    backgroundColor: Colors.white10,
                    color: isAchieved ? Colors.green : Colors.blue,
                    minHeight: 8,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '${(progress * 100).toStringAsFixed(1)}%',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.white54,
                    ),
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
