import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/goal.dart';
import '../providers/goal_provider.dart';
import '../providers/user_provider.dart';
import '../theme/app_theme.dart';

class EditGoalPage extends StatefulWidget {
  final Goal goal;

  const EditGoalPage({Key? key, required this.goal}) : super(key: key);

  @override
  State<EditGoalPage> createState() => _EditGoalPageState();
}

class _EditGoalPageState extends State<EditGoalPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _targetController;
  late TextEditingController _currentController;

  final currency = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ');

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.goal.title);
    _targetController = TextEditingController(text: widget.goal.targetAmount.toStringAsFixed(0));
    _currentController = TextEditingController(text: widget.goal.currentAmount.toStringAsFixed(0));
  }

  Future<void> _updateGoal() async {
    if (_formKey.currentState!.validate()) {
      final userId = Provider.of<UserProvider>(context, listen: false).userId;

      if (userId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("User belum login")),
        );
        return;
      }

      final updatedGoal = Goal(
        id: widget.goal.id,
        userId: userId,
        title: _titleController.text,
        targetAmount: double.parse(_targetController.text.replaceAll('.', '').replaceAll(',', '')),
        currentAmount: double.parse(_currentController.text.replaceAll('.', '').replaceAll(',', '')),
        createdAt: widget.goal.createdAt,
      );

      await Provider.of<GoalProvider>(context, listen: false).updateGoal(updatedGoal, userId);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Goal berhasil diperbarui')),
      );

      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _targetController.dispose();
    _currentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Goal')),
      backgroundColor: AppTheme.background,
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Nama Goal',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Nama goal tidak boleh kosong' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _targetController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Target Nominal',
                  border: OutlineInputBorder(),
                  prefixText: 'Rp ',
                ),
                validator: (value) {
                  final parsed = double.tryParse(value?.replaceAll('.', '').replaceAll(',', '') ?? '');
                  if (parsed == null || parsed <= 0) return 'Target tidak valid';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _currentController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Nominal Saat Ini',
                  border: OutlineInputBorder(),
                  prefixText: 'Rp ',
                ),
                validator: (value) {
                  final parsed = double.tryParse(value?.replaceAll('.', '').replaceAll(',', '') ?? '');
                  if (parsed == null || parsed < 0) return 'Jumlah saat ini tidak valid';
                  return null;
                },
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _updateGoal,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Simpan Perubahan'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
