import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:budget_mate/models/transaction.dart';

class TransactionCard extends StatelessWidget {
  final TransactionModel transaction;
  final VoidCallback? onTap;

  const TransactionCard({
    Key? key,
    required this.transaction,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currency = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ');
    final date = DateFormat.yMMMd().format(transaction.date);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        leading: CircleAvatar(
          radius: 24,
          backgroundColor: transaction.isIncome ? Colors.green[100] : Colors.red[100],
          child: Icon(
            transaction.isIncome ? Icons.arrow_downward : Icons.arrow_upward,
            color: transaction.isIncome ? Colors.green : Colors.red,
          ),
        ),
        title: Text(
          transaction.title,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text('$date • ${transaction.category}'),
        trailing: Text(
          (transaction.isIncome ? '+ ' : '- ') + currency.format(transaction.amount),
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: transaction.isIncome ? Colors.green : Colors.red,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
