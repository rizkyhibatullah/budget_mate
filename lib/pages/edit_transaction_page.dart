import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:budget_mate/models/transaction.dart';
import 'package:budget_mate/db/db_helper.dart';
import 'package:budget_mate/theme/app_theme.dart';
import 'package:provider/provider.dart';
import 'package:budget_mate/providers/user_provider.dart';

class EditTransactionPage extends StatefulWidget {
  final TransactionModel transaction;

  const EditTransactionPage({Key? key, required this.transaction}) : super(key: key);

  @override
  State<EditTransactionPage> createState() => _EditTransactionPageState();
}

class _EditTransactionPageState extends State<EditTransactionPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _amountController;
  late TextEditingController _categoryController;
  late DateTime _selectedDate;
  late bool _isIncome;
  bool _isSaving = false;

  final DBHelper _dbHelper = DBHelper();

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.transaction.title);
    _amountController = TextEditingController(text: widget.transaction.amount.toString());
    _categoryController = TextEditingController(text: widget.transaction.category);
    _selectedDate = widget.transaction.date;
    _isIncome = widget.transaction.isIncome;
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  Future<void> _saveChanges() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isSaving = true);

      final userId = Provider.of<UserProvider>(context, listen: false).userId;
      if (userId == null) return;

      final updatedTransaction = TransactionModel(
        id: widget.transaction.id,
        title: _titleController.text.trim(),
        amount: double.parse(_amountController.text),
        category: _categoryController.text.trim(),
        date: _selectedDate,
        isIncome: _isIncome,
        userId: userId, // penting!
      );

      await _dbHelper.updateTransaction(updatedTransaction);

      if (context.mounted) {
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Transaksi')),
      backgroundColor: AppTheme.background,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              ToggleButtons(
                isSelected: [_isIncome, !_isIncome],
                onPressed: (index) {
                  setState(() => _isIncome = index == 0);
                },
                borderRadius: BorderRadius.circular(12),
                selectedColor: Colors.white,
                fillColor: _isIncome ? Colors.green : Colors.red,
                children: const [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text('Pemasukan'),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text('Pengeluaran'),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Judul'),
                validator: (val) =>
                    val == null || val.isEmpty ? 'Judul tidak boleh kosong' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Nominal'),
                validator: (val) =>
                    val == null || val.isEmpty ? 'Nominal tidak boleh kosong' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _categoryController,
                decoration: const InputDecoration(labelText: 'Kategori'),
                validator: (val) =>
                    val == null || val.isEmpty ? 'Kategori tidak boleh kosong' : null,
              ),
              const SizedBox(height: 16),
              ListTile(
                tileColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                title: const Text('Tanggal'),
                subtitle: Text(DateFormat.yMMMMd().format(_selectedDate)),
                trailing: IconButton(
                  icon: const Icon(Icons.calendar_today),
                  onPressed: _pickDate,
                ),
              ),
              const SizedBox(height: 24),
              _isSaving
                  ? const CircularProgressIndicator()
                  : ElevatedButton.icon(
                      icon: const Icon(Icons.save),
                      label: const Text('Simpan Perubahan'),
                      onPressed: _saveChanges,
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(48),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
