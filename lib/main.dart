import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'providers/user_provider.dart';
import 'screens/onboarding_screen.dart';
import 'screens/main_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Включаем полноэкранный режим (скрываем статус-бар и нижний индикатор)
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

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
      title: 'No Smoking No Vaping',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF070707),
        primaryColor: Colors.white,
        cardColor: Colors.transparent,
        colorScheme: const ColorScheme.dark(
          primary: Colors.white,
          secondary: Colors.grey,
        ),
        textTheme: ThemeData.dark().textTheme.apply(
          fontFamily: '.SF Pro Text',
          bodyColor: Colors.grey.shade400,
          displayColor: Colors.grey.shade400,
        ),
        cardTheme: const CardThemeData(
          color: Colors.transparent,
          elevation: 0,
          margin: EdgeInsets.zero,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          scrolledUnderElevation: 0, // Убирает "свечение" при скролле
          surfaceTintColor: Colors.transparent,
        ),
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
