import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:budget_mate/models/transaction.dart';
import 'package:budget_mate/providers/transaction_provider.dart';
import 'package:budget_mate/providers/user_provider.dart';
import 'package:budget_mate/pages/edit_transaction_page.dart';
import 'package:budget_mate/theme/app_theme.dart';
import 'package:intl/intl.dart';

class TransactionDetailPage extends StatelessWidget {
  final TransactionModel transaction;

  const TransactionDetailPage({Key? key, required this.transaction}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currency = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Transaksi'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => EditTransactionPage(transaction: transaction),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () async {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text('Hapus Transaksi?'),
                  content: const Text('Yakin ingin menghapus transaksi ini?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(ctx, false),
                      child: const Text('Batal'),
                    ),
                    ElevatedButton(
                      onPressed: () => Navigator.pop(ctx, true),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                      child: const Text('Hapus'),
                    ),
                  ],
                ),
              );

              if (confirm == true) {
                final userId = Provider.of<UserProvider>(context, listen: false).userId;
                if (userId != null) {
                  await Provider.of<TransactionProvider>(context, listen: false)
                      .deleteTransaction(transaction.id!, userId);

                  if (context.mounted) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Transaksi berhasil dihapus')),
                    );
                  }
                }
              }
            },
          ),
        ],
      ),
      backgroundColor: AppTheme.background,
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              transaction.title,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Chip(
                  label: Text(transaction.isIncome ? 'Pemasukan' : 'Pengeluaran'),
                  backgroundColor: transaction.isIncome ? Colors.green[100] : Colors.red[100],
                ),
                const SizedBox(width: 12),
                Chip(
                  label: Text(transaction.category),
                  backgroundColor: Colors.blueGrey[100],
                ),
              ],
            ),
            const SizedBox(height: 24),
            Text(
              currency.format(transaction.amount),
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: transaction.isIncome ? Colors.green : Colors.red,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.calendar_today, size: 20),
                const SizedBox(width: 8),
                Text(DateFormat.yMMMMEEEEd().format(transaction.date)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
