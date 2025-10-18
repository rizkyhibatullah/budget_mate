import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/goal.dart';
import '../providers/goal_provider.dart';
import '../providers/user_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/goal_card.dart';
import '../widgets/bottom_nav.dart';
import 'edit_goal_page.dart';

class GoalsPage extends StatefulWidget {
  const GoalsPage({Key? key}) : super(key: key);

  @override
  State<GoalsPage> createState() => _GoalsPageState();
}

class _GoalsPageState extends State<GoalsPage> {
  late int _userId;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final userProvider = Provider.of<UserProvider>(context);
    _userId = userProvider.userId!;
    _loadGoals();
  }

  Future<void> _loadGoals() async {
    await Provider.of<GoalProvider>(context, listen: false).loadGoals(_userId);
  }

  @override
  Widget build(BuildContext context) {
    final goalProvider = Provider.of<GoalProvider>(context);
    final List<Goal> goals = goalProvider.goals;

    return Scaffold(
      appBar: AppBar(title: const Text('Tujuan Keuangan')),
      backgroundColor: AppTheme.background,
      bottomNavigationBar: const BottomNav(currentIndex: 2),
      body: RefreshIndicator(
        onRefresh: _loadGoals,
        child: goals.isEmpty
            ? const Center(
                child: Text(
                  "Belum ada goal yang dibuat.",
                  style: TextStyle(fontSize: 16),
                ),
              )
            : ListView.separated(
                padding: const EdgeInsets.all(16),
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemCount: goals.length,
                itemBuilder: (context, index) {
                  final goal = goals[index];
                  return GoalCard(
                    goal: goal,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => EditGoalPage(goal: goal),
                        ),
                      ).then((_) => _loadGoals());
                    },
                  );
                },
              ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppTheme.primary,
        onPressed: () {
          Navigator.pushNamed(context, '/add-goal').then((_) => _loadGoals());
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
