import 'package:flutter/material.dart';
import 'dart:ui';
import 'dashboard_screen.dart';
import 'health_screen.dart';
import 'settings_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const DashboardScreen(),
    const HealthScreen(),
    const SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true, // Важно для стекла под навигацией
      body: Stack(
        children: [
          // Ambient Gradient Background
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF0F1A15), // Легкий темно-зеленый оттенок
                  Color(0xFF070707),
                  Color(0xFF0A0F1A), // Легкий темно-синий оттенок
                ],
              ),
            ),
          ),
          // Контент
          _screens[_currentIndex],
        ],
      ),
      bottomNavigationBar: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20.0, sigmaY: 20.0),
          child: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            selectedItemColor: Colors.white,
            unselectedItemColor: Colors.grey.shade600,
            backgroundColor: Colors.white.withOpacity(0.05), // Легкая стеклянная заливка
            elevation: 0,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.timer),
                label: 'Прогресс',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.favorite),
                label: 'Здоровье',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.settings),
                label: 'Настройки',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

