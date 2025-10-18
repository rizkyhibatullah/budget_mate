import 'package:flutter/material.dart';
import '../pages/home_page.dart';
import '../pages/transaction_list_page.dart';
import '../pages/goals_page.dart';
import '../pages/settings_page.dart';
import '../theme/app_theme.dart';

class BottomNav extends StatelessWidget {
  final int currentIndex;

  const BottomNav({Key? key, required this.currentIndex}) : super(key: key);

  void _onItemTapped(BuildContext context, int index) {
    if (index == currentIndex) return;

    Widget targetPage;
    switch (index) {
      case 0:
        targetPage = const HomePage();
        break;
      case 1:
        targetPage = const TransactionListPage();
        break;
      case 2:
        targetPage = const GoalsPage();
        break;
      case 3:
        targetPage = const SettingsPage();
        break;
      default:
        targetPage = const HomePage();
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => targetPage),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: (index) => _onItemTapped(context, index),
      selectedItemColor: AppTheme.primary,
      unselectedItemColor: Colors.grey,
      showUnselectedLabels: true,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_rounded),
          label: 'Beranda',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.list_alt_rounded),
          label: 'Transaksi',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.flag_rounded),
          label: 'Goals',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings_rounded),
          label: 'Pengaturan',
        ),
      ],
    );
  }
}
