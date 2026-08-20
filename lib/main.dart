import 'package:flutter/material.dart';
import 'theme/app_colors.dart';
import 'screens/home_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const FoodStartupApp());
}

class FoodStartupApp extends StatelessWidget {
  const FoodStartupApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Velora — Taste, Reimagined',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: AppColors.bgCream,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primaryFlame,
          primary: AppColors.primaryFlame,
          secondary: AppColors.secondaryGold,
          surface: AppColors.bgCream,
        ),
      ),
      home: const HomeScreen(),
    );
  }
}
