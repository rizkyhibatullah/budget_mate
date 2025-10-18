import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../db/db_helper.dart';
import '../models/transaction.dart';
import '../providers/user_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/bottom_nav.dart';
import '../widgets/transaction_card.dart';
import 'transaction_detail_page.dart';

class TransactionListPage extends StatefulWidget {
  const TransactionListPage({Key? key}) : super(key: key);

  @override
  State<TransactionListPage> createState() => _TransactionListPageState();
}

class _TransactionListPageState extends State<TransactionListPage> {
  final DBHelper _dbHelper = DBHelper();
  List<TransactionModel> _transactions = [];
  int? _userId;

  @override
  void initState() {
    super.initState();
    _loadUserIdAndTransactions();
  }

  Future<void> _loadUserIdAndTransactions() async {
    final userId = Provider.of<UserProvider>(context, listen: false).userId;
    if (userId == null) return;

    setState(() => _userId = userId);
    await _loadTransactions();
  }

  Future<void> _loadTransactions() async {
    if (_userId == null) return;

    final data = await _dbHelper.getTransactionsByUser(_userId!);
    setState(() => _transactions = data);
  }

  Future<void> _deleteTransaction(int id) async {
    await _dbHelper.deleteTransaction(id);
    _loadTransactions();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Transaksi berhasil dihapus")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Semua Transaksi')),
      backgroundColor: AppTheme.background,
      bottomNavigationBar: const BottomNav(currentIndex: 1),
      body: RefreshIndicator(
        onRefresh: _loadTransactions,
        child: _transactions.isEmpty
            ? const Center(child: Text("Belum ada transaksi."))
            : ListView.separated(
                padding: const EdgeInsets.all(16),
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemCount: _transactions.length,
                itemBuilder: (context, index) {
                  final tx = _transactions[index];
                  return Dismissible(
                    key: Key(tx.id.toString()),
                    direction: DismissDirection.startToEnd,
                    background: Container(
                      padding: const EdgeInsets.only(left: 20),
                      alignment: Alignment.centerLeft,
                      color: Colors.red,
                      child: const Icon(Icons.delete, color: Colors.white),
                    ),
                    onDismissed: (_) => _deleteTransaction(tx.id!),
                    child: TransactionCard(
                      transaction: tx,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => TransactionDetailPage(transaction: tx),
                          ),
                        ).then((_) => _loadTransactions());
                      },
                    ),
                  );
                },
              ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppTheme.primary,
        onPressed: () {
          Navigator.pushNamed(context, '/add-transaction').then((_) => _loadTransactions());
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
