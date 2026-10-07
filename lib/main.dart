import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/user_provider.dart';
import 'screens/onboarding_screen.dart';
import 'screens/main_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: const RauchfreiApp(),
    ),
  );
}

class RauchfreiApp extends StatelessWidget {
  const RauchfreiApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rauchfrei',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF050505),
        primaryColor: Colors.green,
        cardColor: const Color(0xFF1A1A1A),
        colorScheme: const ColorScheme.dark(
          primary: Colors.green,
          secondary: Colors.orange,
        ),
        textTheme: ThemeData.dark().textTheme.apply(fontFamily: '.SF Pro Text'),
        useMaterial3: true,
      ),
      home: Consumer<UserProvider>(
        builder: (context, provider, child) {
          if (!provider.isLoaded) {
            return const Scaffold(body: Center(child: CircularProgressIndicator()));
          }
          if (provider.isFirstLaunch) {
            return const OnboardingScreen();
          }
          return const MainScreen();
        },
      ),
    );
  }
}
