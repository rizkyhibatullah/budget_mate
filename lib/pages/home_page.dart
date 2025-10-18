import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../theme/app_theme.dart';
import '../widgets/bottom_nav.dart';
import '../db/db_helper.dart';
import '../models/transaction.dart';
import '../providers/user_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final DBHelper _dbHelper = DBHelper();
  List<TransactionModel> _transactions = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadTransactions());
  }

  Future<void> _loadTransactions() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final userId = userProvider.userId;
    if (userId != null) {
      final data = await _dbHelper.getTransactionsByUser(userId);
      setState(() => _transactions = data);
    }
  }

  double get totalIncome => _transactions
      .where((tx) => tx.isIncome)
      .fold(0.0, (sum, item) => sum + item.amount);

  double get totalExpense => _transactions
      .where((tx) => !tx.isIncome)
      .fold(0.0, (sum, item) => sum + item.amount);

  List<DateTime> get last7Days =>
      List.generate(7, (i) => DateTime.now().subtract(Duration(days: i)))
          .reversed
          .toList();

  Map<DateTime, double> get dailyExpenses {
    final Map<DateTime, double> result = {};
    for (var day in last7Days) {
      final total = _transactions
          .where((tx) =>
              !tx.isIncome &&
              tx.date.year == day.year &&
              tx.date.month == day.month &&
              tx.date.day == day.day)
          .fold(0.0, (sum, tx) => sum + tx.amount);
      result[day] = total;
    }
    return result;
  }

  List<BarChartGroupData> get _barChartData {
    final List<BarChartGroupData> groups = [];
    int index = 0;
    for (var entry in dailyExpenses.entries) {
      groups.add(
        BarChartGroupData(x: index, barRods: [
          BarChartRodData(
            toY: entry.value,
            color: Colors.redAccent,
            width: 14,
            borderRadius: BorderRadius.circular(4),
          )
        ]),
      );
      index++;
    }
    return groups;
  }

  @override
  Widget build(BuildContext context) {
    final balance = totalIncome - totalExpense;
    final currency = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ');
    final maxY =
        (dailyExpenses.values.fold(0.0, (a, b) => a > b ? a : b)) + 20000;

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('BudgetMate'),
        centerTitle: true,
      ),
      bottomNavigationBar: const BottomNav(currentIndex: 0),
      body: RefreshIndicator(
        onRefresh: _loadTransactions,
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            // SALDO
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppTheme.primary,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Saldo Saat Ini',
                      style: TextStyle(color: Colors.white70)),
                  const SizedBox(height: 8),
                  Text(
                    currency.format(balance),
                    style: const TextStyle(
                        fontSize: 24,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // RINGKASAN
            Row(
              children: [
                _summaryCard('Pemasukan', totalIncome, Colors.green),
                const SizedBox(width: 16),
                _summaryCard('Pengeluaran', totalExpense, Colors.red),
              ],
            ),
            const SizedBox(height: 24),

            // GRAFIK
            const Text('Grafik Pengeluaran 7 Hari Terakhir',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            AspectRatio(
              aspectRatio: 1.7,
              child: BarChart(
                BarChartData(
                  maxY: maxY,
                  barGroups: _barChartData,
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                        interval: maxY / 4,
                        getTitlesWidget: (value, meta) {
                          return Text('${(value / 1000).round()}K',
                              style: const TextStyle(fontSize: 10));
                        },
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          final index = value.toInt();
                          if (index >= 0 && index < last7Days.length) {
                            return Text(
                              DateFormat('d').format(last7Days[index]),
                              style: const TextStyle(fontSize: 10),
                            );
                          }
                          return const SizedBox.shrink();
                        },
                      ),
                    ),
                    topTitles:
                        AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles:
                        AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  gridData: FlGridData(show: false),
                  borderData: FlBorderData(show: false),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // TRANSAKSI TERBARU
            const Text('Transaksi Terbaru',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            if (_transactions.isEmpty)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(32),
                  child: Text('Belum ada transaksi'),
                ),
              )
            else
              SizedBox(
                height: MediaQuery.of(context).size.height *
                    0.4, // Bisa juga pakai 300
                child: ListView.separated(
                  itemCount: _transactions.length,
                  itemBuilder: (context, index) {
                    return _transactionTile(_transactions[index]);
                  },
                  separatorBuilder: (context, index) =>
                      const Divider(height: 8),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _summaryCard(String label, double amount, Color color) {
    final currency = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ');
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color),
        ),
        child: Column(
          children: [
            Text(label, style: TextStyle(color: color)),
            const SizedBox(height: 4),
            Text(
              currency.format(amount),
              style: TextStyle(fontWeight: FontWeight.bold, color: color),
            ),
          ],
        ),
      ),
    );
  }

  Widget _transactionTile(TransactionModel tx) {
    final currency = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ');
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 0),
      leading: CircleAvatar(
        backgroundColor: tx.isIncome ? Colors.green : Colors.red,
        child: Icon(
          tx.isIncome ? Icons.arrow_downward : Icons.arrow_upward,
          color: Colors.white,
        ),
      ),
      title: Text(tx.title),
      subtitle: Text(DateFormat.yMMMEd().format(tx.date)),
      trailing: Text(
        currency.format(tx.amount),
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: tx.isIncome ? Colors.green : Colors.red,
        ),
      ),
    );
  }
}
