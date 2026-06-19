import 'package:flutter/foundation.dart';
import 'package:student_fin_os/models/finance_enums.dart';
import 'package:student_fin_os/models/split_expense.dart';
import 'package:student_fin_os/models/split_group.dart';
import 'package:student_fin_os/services/in_memory_db.dart';
import 'package:student_fin_os/services/lambda_api_service.dart';

class SplitService {
  SplitService(this._apiService);

  final LambdaApiService _apiService;

  Stream<List<SplitGroup>> watchGroups(String userId) async* {
    if (!_apiService.isConfigured) {
      final List<SplitGroup> list = InMemoryDb.splitGroups
          .where((SplitGroup g) => g.memberIds.contains(userId))
          .toList()
        ..sort((SplitGroup a, SplitGroup b) => b.updatedAt.compareTo(a.updatedAt));
      yield list;
      return;
    }

    try {
      final dynamic response = await _apiService.get('/splits/groups?userId=$userId');
      if (response is List) {
        final List<SplitGroup> list = response
            .map((dynamic e) => SplitGroup.fromMap(e['id'] ?? e['groupId'] ?? '', e as Map<String, dynamic>))
            .toList();
        yield list;
      } else {
        yield <SplitGroup>[];
      }
    } catch (e) {
      debugPrint('[SplitService] API watchGroups error: $e');
      final List<SplitGroup> list = InMemoryDb.splitGroups
          .where((SplitGroup g) => g.memberIds.contains(userId))
          .toList()
        ..sort((SplitGroup a, SplitGroup b) => b.updatedAt.compareTo(a.updatedAt));
      yield list;
    }
  }

  Future<void> createGroup(String userId, SplitGroup group) async {
    InMemoryDb.splitGroups.removeWhere((SplitGroup g) => g.id == group.id);
    InMemoryDb.splitGroups.add(group);

    if (_apiService.isConfigured) {
      try {
        await _apiService.post('/splits/groups', group.toMap());
      } catch (e) {
        debugPrint('[SplitService] API createGroup error: $e');
      }
    }
  }

  Stream<List<SplitExpense>> watchGroupExpenses({
    required String userId,
    required String groupId,
  }) async* {
    if (!_apiService.isConfigured) {
      final List<SplitExpense> list = InMemoryDb.splitExpenses
          .where((SplitExpense e) => e.groupId == groupId)
          .toList()
        ..sort((SplitExpense a, SplitExpense b) => b.expenseAt.compareTo(a.expenseAt));
      yield list;
      return;
    }

    try {
      final dynamic response = await _apiService.get('/splits/expenses?userId=$userId&groupId=$groupId');
      if (response is List) {
        final List<SplitExpense> list = response
            .map((dynamic e) => SplitExpense.fromMap(e['id'] ?? e['expenseId'] ?? '', e as Map<String, dynamic>))
            .toList();
        yield list;
      } else {
        yield <SplitExpense>[];
      }
    } catch (e) {
      debugPrint('[SplitService] API watchGroupExpenses error: $e');
      final List<SplitExpense> list = InMemoryDb.splitExpenses
          .where((SplitExpense e) => e.groupId == groupId)
          .toList()
        ..sort((SplitExpense a, SplitExpense b) => b.expenseAt.compareTo(a.expenseAt));
      yield list;
    }
  }

  Future<void> addGroupExpense(String userId, SplitExpense expense) async {
    InMemoryDb.splitExpenses.removeWhere((SplitExpense e) => e.id == expense.id);
    InMemoryDb.splitExpenses.add(expense);

    final int groupIdx = InMemoryDb.splitGroups.indexWhere((SplitGroup g) => g.id == expense.groupId);
    if (groupIdx != -1) {
      final SplitGroup group = InMemoryDb.splitGroups[groupIdx];
      InMemoryDb.splitGroups[groupIdx] = SplitGroup(
        id: group.id,
        ownerId: group.ownerId,
        name: group.name,
        memberIds: group.memberIds,
        description: group.description,
        createdAt: group.createdAt,
        updatedAt: DateTime.now().toUtc(),
      );
    }

    if (_apiService.isConfigured) {
      try {
        await _apiService.post('/splits/expenses', expense.toMap());
      } catch (e) {
        debugPrint('[SplitService] API addGroupExpense error: $e');
      }
    }
  }

  Future<void> markSettled({
    required String userId,
    required String expenseId,
  }) async {
    final int idx = InMemoryDb.splitExpenses.indexWhere((SplitExpense e) => e.id == expenseId);
    if (idx != -1) {
      final SplitExpense expense = InMemoryDb.splitExpenses[idx];
      InMemoryDb.splitExpenses[idx] = SplitExpense(
        id: expense.id,
        groupId: expense.groupId,
        createdBy: expense.createdBy,
        title: expense.title,
        totalAmount: expense.totalAmount,
        currency: expense.currency,
        paidBy: expense.paidBy,
        owedBy: expense.owedBy,
        status: SplitStatus.settled,
        expenseAt: expense.expenseAt,
        createdAt: expense.createdAt,
        updatedAt: DateTime.now().toUtc(),
      );
    }

    if (_apiService.isConfigured) {
      try {
        await _apiService.post('/splits/expenses/settle', <String, dynamic>{
          'userId': userId,
          'expenseId': expenseId,
        });
      } catch (e) {
        debugPrint('[SplitService] API markSettled error: $e');
      }
    }
  }

  Map<String, double> netBalances(
    List<SplitExpense> expenses,
    List<String> memberIds,
  ) {
    final Map<String, double> totals = <String, double>{
      for (final String id in memberIds) id: 0,
    };

    for (final SplitExpense expense in expenses) {
      totals.update(expense.paidBy, (double value) => value + expense.totalAmount,
          ifAbsent: () => expense.totalAmount);

      expense.owedBy.forEach((String memberId, double amount) {
        totals.update(memberId, (double value) => value - amount,
            ifAbsent: () => -amount);
      });
    }

    return totals;
  }
}
