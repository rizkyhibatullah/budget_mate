import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/goal.dart';
import '../providers/goal_provider.dart';
import '../providers/user_provider.dart';
import '../theme/app_theme.dart';

class AddGoalPage extends StatefulWidget {
  const AddGoalPage({Key? key}) : super(key: key);

  @override
  State<AddGoalPage> createState() => _AddGoalPageState();
}

class _AddGoalPageState extends State<AddGoalPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _targetController = TextEditingController();
  final currency = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ');

  bool _isSaving = false;

  Future<void> _saveGoal() async {
    if (!_formKey.currentState!.validate()) return;

    final userId = Provider.of<UserProvider>(context, listen: false).userId;
    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("User belum login")),
      );
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      final goal = Goal(
        userId: userId,
        title: _titleController.text.trim(),
        targetAmount: double.parse(
          _targetController.text.replaceAll('.', '').replaceAll(',', ''),
        ),
        currentAmount: 0,
        createdAt: DateTime.now(),
      );

      await Provider.of<GoalProvider>(context, listen: false).addGoal(goal, userId);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Goal berhasil ditambahkan')),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      print('❌ Error saat menyimpan goal: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Terjadi kesalahan. Gagal menambahkan goal')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tambah Goal')),
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
              const SizedBox(height: 20),
              TextFormField(
                controller: _targetController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Target Nominal',
                  border: OutlineInputBorder(),
                  prefixText: 'Rp ',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Masukkan nominal target';
                  final parsed = double.tryParse(
                      value.replaceAll('.', '').replaceAll(',', ''));
                  if (parsed == null || parsed <= 0) return 'Nominal tidak valid';
                  return null;
                },
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: _isSaving
                    ? const Center(child: CircularProgressIndicator())
                    : ElevatedButton(
                        onPressed: _saveGoal,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primary,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text('Simpan Goal'),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
