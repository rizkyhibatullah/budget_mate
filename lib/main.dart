import 'package:budget_mate/pages/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; 

import 'theme/app_theme.dart';
import 'pages/splash_page.dart';
import 'pages/add_transaction_page.dart';
import 'pages/add_goal_page.dart';
import 'pages/login_page.dart';

import 'providers/transaction_provider.dart';
import 'providers/goal_provider.dart';
import 'providers/user_provider.dart'; // ✅ Tambahkan ini

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const BudgetMateApp());
}

class BudgetMateApp extends StatelessWidget {
  const BudgetMateApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => TransactionProvider()),
        ChangeNotifierProvider(create: (_) => GoalProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'BudgetMate',
        theme: AppTheme.lightTheme,
        initialRoute: '/',
        routes: {
          '/': (context) => const SplashPage(),
          '/add-transaction': (context) => const AddTransactionPage(),
          '/add-goal': (context) => const AddGoalPage(),
          '/login': (context) => const LoginPage(),
          '/profile': (context) => const ProfilePage(),
        },
      ),
    );
  }
}
