import 'package:student_fin_os/models/account.dart';
import 'package:student_fin_os/models/finance_transaction.dart';
import 'package:student_fin_os/models/savings_goal.dart';
import 'package:student_fin_os/models/split_group.dart';
import 'package:student_fin_os/models/split_expense.dart';
import 'package:student_fin_os/models/ai_insight.dart';

class InMemoryDb {
  InMemoryDb._();

  static final List<Account> accounts = <Account>[];
  static final List<FinanceTransaction> transactions = <FinanceTransaction>[];
  static final List<SavingsGoal> goals = <SavingsGoal>[];
  static final List<SplitGroup> splitGroups = <SplitGroup>[];
  static final List<SplitExpense> splitExpenses = <SplitExpense>[];
  static final List<AiInsight> insights = <AiInsight>[];
  static final List<Map<String, dynamic>> notifications = <Map<String, dynamic>>[];
  
  static bool hasSeeded = false;

  static void clear() {
    accounts.clear();
    transactions.clear();
    goals.clear();
    splitGroups.clear();
    splitExpenses.clear();
    insights.clear();
    notifications.clear();
    hasSeeded = false;
  }
}
