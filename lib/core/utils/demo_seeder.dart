import 'package:student_fin_os/models/account.dart';
import 'package:student_fin_os/models/finance_enums.dart';
import 'package:student_fin_os/models/finance_transaction.dart';
import 'package:student_fin_os/models/savings_goal.dart';
import 'package:student_fin_os/models/split_group.dart';
import 'package:student_fin_os/models/split_expense.dart';
import 'package:student_fin_os/services/in_memory_db.dart';

enum DemoProfileType {
  frugalSaver,
  cafeSpender,
  freelanceHustler,
  tripPlanner,
  debtLearner,
}

class DemoSeeder {
  static void seed(String userId, DemoProfileType type) {
    // 1. Clear database
    InMemoryDb.clear();

    final DateTime now = DateTime.now().toUtc();

    switch (type) {
      case DemoProfileType.frugalSaver:
        _seedFrugalSaver(userId, now);
        break;
      case DemoProfileType.cafeSpender:
        _seedCafeSpender(userId, now);
        break;
      case DemoProfileType.freelanceHustler:
        _seedFreelanceHustler(userId, now);
        break;
      case DemoProfileType.tripPlanner:
        _seedTripPlanner(userId, now);
        break;
      case DemoProfileType.debtLearner:
        _seedDebtLearner(userId, now);
        break;
    }

    InMemoryDb.hasSeeded = true;
  }

  static void _seedFrugalSaver(String userId, DateTime now) {
    final accounts = <Account>[
      Account(
        id: 'fs_acc_1',
        userId: userId,
        name: 'SBI Bank Account',
        type: AccountType.bank,
        provider: 'SBI',
        balance: 12500.0,
        isActive: true,
        icon: 'account_balance',
        transactionIds: const ['fs_tx_1', 'fs_tx_5'],
        createdAt: now.subtract(const Duration(days: 30)),
        updatedAt: now,
      ),
      Account(
        id: 'fs_acc_2',
        userId: userId,
        name: 'PhonePe Wallet',
        type: AccountType.upi,
        provider: 'PhonePe',
        balance: 2200.0,
        isActive: false,
        icon: 'phone_android',
        transactionIds: const ['fs_tx_2'],
        createdAt: now.subtract(const Duration(days: 30)),
        updatedAt: now,
      ),
      Account(
        id: 'fs_acc_3',
        userId: userId,
        name: 'Cash in Hand',
        type: AccountType.cash,
        provider: 'Cash',
        balance: 1500.0,
        isActive: false,
        icon: 'payments',
        transactionIds: const ['fs_tx_3', 'fs_tx_4', 'fs_tx_6'],
        createdAt: now.subtract(const Duration(days: 30)),
        updatedAt: now,
      ),
    ];

    final transactions = <FinanceTransaction>[
      FinanceTransaction(
        id: 'fs_tx_1',
        userId: userId,
        accountId: 'fs_acc_1',
        title: 'Monthly Pocket Money',
        amount: 5000.0,
        type: TransactionType.income,
        category: 'stipend',
        source: 'Parents Bank Transfer',
        channel: 'bank_transfer',
        transactionAt: now.subtract(const Duration(days: 10)),
        createdAt: now.subtract(const Duration(days: 10)),
        updatedAt: now.subtract(const Duration(days: 10)),
      ),
      FinanceTransaction(
        id: 'fs_tx_2',
        userId: userId,
        accountId: 'fs_acc_2',
        title: 'Jio Prepaid Recharge',
        amount: 239.0,
        type: TransactionType.expense,
        category: 'bills',
        source: 'PhonePe Wallet',
        channel: 'upi',
        transactionAt: now.subtract(const Duration(days: 5)),
        createdAt: now.subtract(const Duration(days: 5)),
        updatedAt: now.subtract(const Duration(days: 5)),
      ),
      FinanceTransaction(
        id: 'fs_tx_3',
        userId: userId,
        accountId: 'fs_acc_3',
        title: 'Library Notes Printing',
        amount: 60.0,
        type: TransactionType.expense,
        category: 'education',
        source: 'Cash',
        channel: 'cash',
        transactionAt: now.subtract(const Duration(days: 4)),
        createdAt: now.subtract(const Duration(days: 4)),
        updatedAt: now.subtract(const Duration(days: 4)),
      ),
      FinanceTransaction(
        id: 'fs_tx_4',
        userId: userId,
        accountId: 'fs_acc_3',
        title: 'Groceries Local Mandi',
        amount: 250.0,
        type: TransactionType.expense,
        category: 'grocery',
        source: 'Cash',
        channel: 'cash',
        transactionAt: now.subtract(const Duration(days: 3)),
        createdAt: now.subtract(const Duration(days: 3)),
        updatedAt: now.subtract(const Duration(days: 3)),
      ),
      FinanceTransaction(
        id: 'fs_tx_5',
        userId: userId,
        accountId: 'fs_acc_1',
        title: 'Freelance Design Payout',
        amount: 4000.0,
        type: TransactionType.income,
        category: 'stipend',
        source: 'Direct Deposit',
        channel: 'bank_transfer',
        transactionAt: now.subtract(const Duration(days: 2)),
        createdAt: now.subtract(const Duration(days: 2)),
        updatedAt: now.subtract(const Duration(days: 2)),
      ),
      FinanceTransaction(
        id: 'fs_tx_6',
        userId: userId,
        accountId: 'fs_acc_3',
        title: 'Local Bus Ticket',
        amount: 40.0,
        type: TransactionType.expense,
        category: 'travel',
        source: 'Cash',
        channel: 'cash',
        transactionAt: now.subtract(const Duration(days: 1)),
        createdAt: now.subtract(const Duration(days: 1)),
        updatedAt: now.subtract(const Duration(days: 1)),
      ),
    ];

    final goals = <SavingsGoal>[
      SavingsGoal(
        id: 'fs_g_1',
        userId: userId,
        title: 'College Semester Fees',
        targetAmount: 10000.0,
        savedAmount: 8000.0,
        deadline: now.add(const Duration(days: 45)),
        status: GoalStatus.active,
        priority: 1,
        createdAt: now.subtract(const Duration(days: 20)),
        updatedAt: now,
      ),
      SavingsGoal(
        id: 'fs_g_2',
        userId: userId,
        title: 'New Laptop',
        targetAmount: 30000.0,
        savedAmount: 15000.0,
        deadline: now.add(const Duration(days: 120)),
        status: GoalStatus.active,
        priority: 2,
        createdAt: now.subtract(const Duration(days: 20)),
        updatedAt: now,
      ),
    ];

    InMemoryDb.accounts.addAll(accounts);
    InMemoryDb.transactions.addAll(transactions);
    InMemoryDb.goals.addAll(goals);
  }

  static void _seedCafeSpender(String userId, DateTime now) {
    final accounts = <Account>[
      Account(
        id: 'cs_acc_1',
        userId: userId,
        name: 'HDFC Savings',
        type: AccountType.bank,
        provider: 'HDFC',
        balance: 1800.0,
        isActive: true,
        icon: 'account_balance',
        transactionIds: const ['cs_tx_1', 'cs_tx_2', 'cs_tx_3', 'cs_tx_4', 'cs_tx_7'],
        createdAt: now.subtract(const Duration(days: 15)),
        updatedAt: now,
      ),
      Account(
        id: 'cs_acc_2',
        userId: userId,
        name: 'Paytm Wallet',
        type: AccountType.upi,
        provider: 'Paytm',
        balance: 450.0,
        isActive: false,
        icon: 'wallet',
        transactionIds: const ['cs_tx_5', 'cs_tx_6'],
        createdAt: now.subtract(const Duration(days: 15)),
        updatedAt: now,
      ),
      Account(
        id: 'cs_acc_3',
        userId: userId,
        name: 'Cash in Hand',
        type: AccountType.cash,
        provider: 'Cash',
        balance: 150.0,
        isActive: false,
        icon: 'payments',
        transactionIds: const [],
        createdAt: now.subtract(const Duration(days: 15)),
        updatedAt: now,
      ),
    ];

    final transactions = <FinanceTransaction>[
      FinanceTransaction(
        id: 'cs_tx_1',
        userId: userId,
        accountId: 'cs_acc_1',
        title: 'Monthly Pocket Money',
        amount: 5000.0,
        type: TransactionType.income,
        category: 'stipend',
        source: 'Parents Deposit',
        channel: 'bank_transfer',
        transactionAt: now.subtract(const Duration(days: 8)),
        createdAt: now.subtract(const Duration(days: 8)),
        updatedAt: now.subtract(const Duration(days: 8)),
      ),
      FinanceTransaction(
        id: 'cs_tx_2',
        userId: userId,
        accountId: 'cs_acc_1',
        title: 'Starbucks Caramel Latte',
        amount: 450.0,
        type: TransactionType.expense,
        category: 'food',
        source: 'Starbucks Card GPay',
        channel: 'upi',
        transactionAt: now.subtract(const Duration(days: 6)),
        createdAt: now.subtract(const Duration(days: 6)),
        updatedAt: now.subtract(const Duration(days: 6)),
      ),
      FinanceTransaction(
        id: 'cs_tx_3',
        userId: userId,
        accountId: 'cs_acc_1',
        title: 'Swiggy Dinner Order',
        amount: 750.0,
        type: TransactionType.expense,
        category: 'food',
        source: 'Swiggy UPI',
        channel: 'upi',
        transactionAt: now.subtract(const Duration(days: 5)),
        createdAt: now.subtract(const Duration(days: 5)),
        updatedAt: now.subtract(const Duration(days: 5)),
      ),
      FinanceTransaction(
        id: 'cs_tx_4',
        userId: userId,
        accountId: 'cs_acc_1',
        title: 'Uber Cab to Mall',
        amount: 220.0,
        type: TransactionType.expense,
        category: 'travel',
        source: 'Uber GPay',
        channel: 'upi',
        transactionAt: now.subtract(const Duration(days: 4)),
        createdAt: now.subtract(const Duration(days: 4)),
        updatedAt: now.subtract(const Duration(days: 4)),
      ),
      FinanceTransaction(
        id: 'cs_tx_5',
        userId: userId,
        accountId: 'cs_acc_2',
        title: 'Netflix Subscription',
        amount: 199.0,
        type: TransactionType.expense,
        category: 'entertainment',
        source: 'Netflix Autopay',
        channel: 'card',
        transactionAt: now.subtract(const Duration(days: 3)),
        createdAt: now.subtract(const Duration(days: 3)),
        updatedAt: now.subtract(const Duration(days: 3)),
      ),
      FinanceTransaction(
        id: 'cs_tx_6',
        userId: userId,
        accountId: 'cs_acc_2',
        title: 'Cafe Coffee Day Snacks',
        amount: 280.0,
        type: TransactionType.expense,
        category: 'food',
        source: 'Paytm Wallet Scan',
        channel: 'upi',
        transactionAt: now.subtract(const Duration(days: 2)),
        createdAt: now.subtract(const Duration(days: 2)),
        updatedAt: now.subtract(const Duration(days: 2)),
      ),
      FinanceTransaction(
        id: 'cs_tx_7',
        userId: userId,
        accountId: 'cs_acc_1',
        title: 'Zomato Lunch',
        amount: 320.0,
        type: TransactionType.expense,
        category: 'food',
        source: 'Zomato UPI',
        channel: 'upi',
        transactionAt: now.subtract(const Duration(days: 1)),
        createdAt: now.subtract(const Duration(days: 1)),
        updatedAt: now.subtract(const Duration(days: 1)),
      ),
    ];

    final goals = <SavingsGoal>[
      SavingsGoal(
        id: 'cs_g_1',
        userId: userId,
        title: 'MacBook Pro',
        targetAmount: 80000.0,
        savedAmount: 1500.0,
        deadline: now.add(const Duration(days: 360)),
        status: GoalStatus.active,
        priority: 1,
        createdAt: now.subtract(const Duration(days: 10)),
        updatedAt: now,
      ),
    ];

    final group = SplitGroup(
      id: 'cs_grp_1',
      ownerId: userId,
      name: 'Roommates Room 302',
      memberIds: [userId, 'friend_rahul', 'friend_amit'],
      description: 'Hostel split balances',
      createdAt: now.subtract(const Duration(days: 10)),
      updatedAt: now,
    );

    final splitExpense = SplitExpense(
      id: 'cs_split_1',
      groupId: 'cs_grp_1',
      createdBy: userId,
      title: 'Hostel Pizza Party',
      totalAmount: 1200.0,
      currency: 'INR',
      paidBy: userId,
      owedBy: {
        userId: 400.0,
        'friend_rahul': 400.0,
        'friend_amit': 400.0,
      },
      status: SplitStatus.pending,
      expenseAt: now.subtract(const Duration(days: 3)),
      createdAt: now.subtract(const Duration(days: 3)),
      updatedAt: now,
    );

    InMemoryDb.accounts.addAll(accounts);
    InMemoryDb.transactions.addAll(transactions);
    InMemoryDb.goals.addAll(goals);
    InMemoryDb.splitGroups.add(group);
    InMemoryDb.splitExpenses.add(splitExpense);
  }

  static void _seedFreelanceHustler(String userId, DateTime now) {
    final accounts = <Account>[
      Account(
        id: 'fh_acc_1',
        userId: userId,
        name: 'ICICI Premium Savings',
        type: AccountType.bank,
        provider: 'ICICI',
        balance: 38000.0,
        isActive: true,
        icon: 'account_balance',
        transactionIds: const ['fh_tx_1', 'fh_tx_2', 'fh_tx_4', 'fh_tx_5', 'fh_tx_7'],
        createdAt: now.subtract(const Duration(days: 45)),
        updatedAt: now,
      ),
      Account(
        id: 'fh_acc_2',
        userId: userId,
        name: 'Google Pay Wallet',
        type: AccountType.upi,
        provider: 'GPay',
        balance: 6500.0,
        isActive: false,
        icon: 'payment',
        transactionIds: const ['fh_tx_3', 'fh_tx_6'],
        createdAt: now.subtract(const Duration(days: 45)),
        updatedAt: now,
      ),
      Account(
        id: 'fh_acc_3',
        userId: userId,
        name: 'Cash in Wallet',
        type: AccountType.cash,
        provider: 'Cash',
        balance: 2000.0,
        isActive: false,
        icon: 'payments',
        transactionIds: const [],
        createdAt: now.subtract(const Duration(days: 45)),
        updatedAt: now,
      ),
    ];

    final transactions = <FinanceTransaction>[
      FinanceTransaction(
        id: 'fh_tx_1',
        userId: userId,
        accountId: 'fh_acc_1',
        title: 'UI/UX Web Redesign Payment',
        amount: 18000.0,
        type: TransactionType.income,
        category: 'salary',
        source: 'US Client Bank Transfer',
        channel: 'bank_transfer',
        transactionAt: now.subtract(const Duration(days: 12)),
        createdAt: now.subtract(const Duration(days: 12)),
        updatedAt: now.subtract(const Duration(days: 12)),
      ),
      FinanceTransaction(
        id: 'fh_tx_2',
        userId: userId,
        accountId: 'fh_acc_1',
        title: 'Weekly SIP Mutual Fund',
        amount: 5000.0,
        type: TransactionType.expense,
        category: 'investment',
        source: 'Auto-Debit Mutual Fund',
        channel: 'bank_transfer',
        transactionAt: now.subtract(const Duration(days: 10)),
        createdAt: now.subtract(const Duration(days: 10)),
        updatedAt: now.subtract(const Duration(days: 10)),
      ),
      FinanceTransaction(
        id: 'fh_tx_3',
        userId: userId,
        accountId: 'fh_acc_2',
        title: 'Logo Design Project Payout',
        amount: 5000.0,
        type: TransactionType.income,
        category: 'salary',
        source: 'Razorpay UPI payout',
        channel: 'upi',
        transactionAt: now.subtract(const Duration(days: 8)),
        createdAt: now.subtract(const Duration(days: 8)),
        updatedAt: now.subtract(const Duration(days: 8)),
      ),
      FinanceTransaction(
        id: 'fh_tx_4',
        userId: userId,
        accountId: 'fh_acc_1',
        title: 'Amazon Shopping (Mechanical Keyboard)',
        amount: 3500.0,
        type: TransactionType.expense,
        category: 'shopping',
        source: 'ICICI Debit Card',
        channel: 'card',
        transactionAt: now.subtract(const Duration(days: 6)),
        createdAt: now.subtract(const Duration(days: 6)),
        updatedAt: now.subtract(const Duration(days: 6)),
      ),
      FinanceTransaction(
        id: 'fh_tx_5',
        userId: userId,
        accountId: 'fh_acc_1',
        title: 'Technical Blog Content Stipend',
        amount: 8000.0,
        type: TransactionType.income,
        category: 'salary',
        source: 'Medium Publisher payment',
        channel: 'bank_transfer',
        transactionAt: now.subtract(const Duration(days: 4)),
        createdAt: now.subtract(const Duration(days: 4)),
        updatedAt: now.subtract(const Duration(days: 4)),
      ),
      FinanceTransaction(
        id: 'fh_tx_6',
        userId: userId,
        accountId: 'fh_acc_2',
        title: 'Blinkit Grocery Shopping',
        amount: 850.0,
        type: TransactionType.expense,
        category: 'grocery',
        source: 'Blinkit UPI',
        channel: 'upi',
        transactionAt: now.subtract(const Duration(days: 3)),
        createdAt: now.subtract(const Duration(days: 3)),
        updatedAt: now.subtract(const Duration(days: 3)),
      ),
      FinanceTransaction(
        id: 'fh_tx_7',
        userId: userId,
        accountId: 'fh_acc_1',
        title: 'Hostel Electricity Utility',
        amount: 1200.0,
        type: TransactionType.expense,
        category: 'bills',
        source: 'ICICI GPay Auto',
        channel: 'upi',
        transactionAt: now.subtract(const Duration(days: 2)),
        createdAt: now.subtract(const Duration(days: 2)),
        updatedAt: now.subtract(const Duration(days: 2)),
      ),
    ];

    final goals = <SavingsGoal>[
      SavingsGoal(
        id: 'fh_g_1',
        userId: userId,
        title: 'Index Fund Portfolio',
        targetAmount: 30000.0,
        savedAmount: 22000.0,
        deadline: now.add(const Duration(days: 60)),
        status: GoalStatus.active,
        priority: 1,
        createdAt: now.subtract(const Duration(days: 30)),
        updatedAt: now,
      ),
      SavingsGoal(
        id: 'fh_g_2',
        userId: userId,
        title: 'New iPad Pro',
        targetAmount: 60000.0,
        savedAmount: 25000.0,
        deadline: now.add(const Duration(days: 150)),
        status: GoalStatus.active,
        priority: 2,
        createdAt: now.subtract(const Duration(days: 30)),
        updatedAt: now,
      ),
    ];

    InMemoryDb.accounts.addAll(accounts);
    InMemoryDb.transactions.addAll(transactions);
    InMemoryDb.goals.addAll(goals);
  }

  static void _seedTripPlanner(String userId, DateTime now) {
    final accounts = <Account>[
      Account(
        id: 'tp_acc_1',
        userId: userId,
        name: 'SBI Salary Savings',
        type: AccountType.bank,
        provider: 'SBI',
        balance: 8200.0,
        isActive: true,
        icon: 'account_balance',
        transactionIds: const ['tp_tx_1', 'tp_tx_3', 'tp_tx_4', 'tp_tx_5'],
        createdAt: now.subtract(const Duration(days: 20)),
        updatedAt: now,
      ),
      Account(
        id: 'tp_acc_2',
        userId: userId,
        name: 'PhonePe Wallet',
        type: AccountType.upi,
        provider: 'PhonePe',
        balance: 1500.0,
        isActive: false,
        icon: 'payment',
        transactionIds: const [],
        createdAt: now.subtract(const Duration(days: 20)),
        updatedAt: now,
      ),
      Account(
        id: 'tp_acc_3',
        userId: userId,
        name: 'Cash in Hand',
        type: AccountType.cash,
        provider: 'Cash',
        balance: 500.0,
        isActive: false,
        icon: 'payments',
        transactionIds: const ['tp_tx_2'],
        createdAt: now.subtract(const Duration(days: 20)),
        updatedAt: now,
      ),
    ];

    final transactions = <FinanceTransaction>[
      FinanceTransaction(
        id: 'tp_tx_1',
        userId: userId,
        accountId: 'tp_acc_1',
        title: 'Monthly Pocket Money',
        amount: 6000.0,
        type: TransactionType.income,
        category: 'stipend',
        source: 'Parents Deposit',
        channel: 'bank_transfer',
        transactionAt: now.subtract(const Duration(days: 10)),
        createdAt: now.subtract(const Duration(days: 10)),
        updatedAt: now.subtract(const Duration(days: 10)),
      ),
      FinanceTransaction(
        id: 'tp_tx_2',
        userId: userId,
        accountId: 'tp_acc_3',
        title: 'Rapido Bike Ride',
        amount: 80.0,
        type: TransactionType.expense,
        category: 'travel',
        source: 'Cash',
        channel: 'cash',
        transactionAt: now.subtract(const Duration(days: 8)),
        createdAt: now.subtract(const Duration(days: 8)),
        updatedAt: now.subtract(const Duration(days: 8)),
      ),
      FinanceTransaction(
        id: 'tp_tx_3',
        userId: userId,
        accountId: 'tp_acc_1',
        title: 'Airbnb Outstation Booking (Goa)',
        amount: 4500.0,
        type: TransactionType.expense,
        category: 'travel',
        source: 'Direct Card Booking',
        channel: 'card',
        transactionAt: now.subtract(const Duration(days: 5)),
        createdAt: now.subtract(const Duration(days: 5)),
        updatedAt: now.subtract(const Duration(days: 5)),
      ),
      FinanceTransaction(
        id: 'tp_tx_4',
        userId: userId,
        accountId: 'tp_acc_1',
        title: 'Beachside Dinner Party (Goa)',
        amount: 1500.0,
        type: TransactionType.expense,
        category: 'food',
        source: 'Restaurant GPay',
        channel: 'upi',
        transactionAt: now.subtract(const Duration(days: 4)),
        createdAt: now.subtract(const Duration(days: 4)),
        updatedAt: now.subtract(const Duration(days: 4)),
      ),
      FinanceTransaction(
        id: 'tp_tx_5',
        userId: userId,
        accountId: 'tp_acc_1',
        title: 'Uber Cab Airport Split',
        amount: 350.0,
        type: TransactionType.expense,
        category: 'travel',
        source: 'Uber UPI',
        channel: 'upi',
        transactionAt: now.subtract(const Duration(days: 2)),
        createdAt: now.subtract(const Duration(days: 2)),
        updatedAt: now.subtract(const Duration(days: 2)),
      ),
    ];

    final goals = <SavingsGoal>[
      SavingsGoal(
        id: 'tp_g_1',
        userId: userId,
        title: 'Goa Summer Trip',
        targetAmount: 15000.0,
        savedAmount: 12000.0,
        deadline: now.add(const Duration(days: 30)),
        status: GoalStatus.active,
        priority: 1,
        createdAt: now.subtract(const Duration(days: 25)),
        updatedAt: now,
      ),
    ];

    final group = SplitGroup(
      id: 'tp_grp_1',
      ownerId: userId,
      name: 'Goa Trip 2026 Gang',
      memberIds: [userId, 'friend_ankit', 'friend_shreya', 'friend_vikram'],
      description: 'Trip split expenses',
      createdAt: now.subtract(const Duration(days: 15)),
      updatedAt: now,
    );

    final split1 = SplitExpense(
      id: 'tp_split_1',
      groupId: 'tp_grp_1',
      createdBy: userId,
      title: 'Airbnb Villa Stay',
      totalAmount: 12000.0,
      currency: 'INR',
      paidBy: userId,
      owedBy: {
        userId: 3000.0,
        'friend_ankit': 3000.0,
        'friend_shreya': 3000.0,
        'friend_vikram': 3000.0,
      },
      status: SplitStatus.pending,
      expenseAt: now.subtract(const Duration(days: 5)),
      createdAt: now.subtract(const Duration(days: 5)),
      updatedAt: now,
    );

    final split2 = SplitExpense(
      id: 'tp_split_2',
      groupId: 'tp_grp_1',
      createdBy: 'friend_ankit',
      title: 'Airport Cab Rent',
      totalAmount: 4000.0,
      currency: 'INR',
      paidBy: 'friend_ankit',
      owedBy: {
        userId: 1000.0,
        'friend_ankit': 1000.0,
        'friend_shreya': 1000.0,
        'friend_vikram': 1000.0,
      },
      status: SplitStatus.pending,
      expenseAt: now.subtract(const Duration(days: 4)),
      createdAt: now.subtract(const Duration(days: 4)),
      updatedAt: now,
    );

    InMemoryDb.accounts.addAll(accounts);
    InMemoryDb.transactions.addAll(transactions);
    InMemoryDb.goals.addAll(goals);
    InMemoryDb.splitGroups.add(group);
    InMemoryDb.splitExpenses.addAll([split1, split2]);
  }

  static void _seedDebtLearner(String userId, DateTime now) {
    final accounts = <Account>[
      Account(
        id: 'dl_acc_1',
        userId: userId,
        name: 'HDFC Basic Student Account',
        type: AccountType.bank,
        provider: 'HDFC',
        balance: 950.0,
        isActive: true,
        icon: 'account_balance',
        transactionIds: const ['dl_tx_1', 'dl_tx_2', 'dl_tx_3', 'dl_tx_4'],
        createdAt: now.subtract(const Duration(days: 15)),
        updatedAt: now,
      ),
      Account(
        id: 'dl_acc_2',
        userId: userId,
        name: 'Paytm Wallet Balance',
        type: AccountType.upi,
        provider: 'Paytm',
        balance: 120.0,
        isActive: false,
        icon: 'wallet',
        transactionIds: const [],
        createdAt: now.subtract(const Duration(days: 15)),
        updatedAt: now,
      ),
      Account(
        id: 'dl_acc_3',
        userId: userId,
        name: 'Cash in Drawer',
        type: AccountType.cash,
        provider: 'Cash',
        balance: 50.0,
        isActive: false,
        icon: 'payments',
        transactionIds: const ['dl_tx_5', 'dl_tx_6'],
        createdAt: now.subtract(const Duration(days: 15)),
        updatedAt: now,
      ),
    ];

    final transactions = <FinanceTransaction>[
      FinanceTransaction(
        id: 'dl_tx_1',
        userId: userId,
        accountId: 'dl_acc_1',
        title: 'Monthly Pocket Stipend',
        amount: 6000.0,
        type: TransactionType.income,
        category: 'stipend',
        source: 'Parents Deposit',
        channel: 'bank_transfer',
        transactionAt: now.subtract(const Duration(days: 10)),
        createdAt: now.subtract(const Duration(days: 10)),
        updatedAt: now.subtract(const Duration(days: 10)),
      ),
      FinanceTransaction(
        id: 'dl_tx_2',
        userId: userId,
        accountId: 'dl_acc_1',
        title: 'Laptop Monthly Buy EMI',
        amount: 3500.0,
        type: TransactionType.expense,
        category: 'bills',
        source: 'EMI Auto-Debit HDFC',
        channel: 'bank_transfer',
        transactionAt: now.subtract(const Duration(days: 8)),
        createdAt: now.subtract(const Duration(days: 8)),
        updatedAt: now.subtract(const Duration(days: 8)),
      ),
      FinanceTransaction(
        id: 'dl_tx_3',
        userId: userId,
        accountId: 'dl_acc_1',
        title: 'Hostel Room rent',
        amount: 4500.0,
        type: TransactionType.expense,
        category: 'bills',
        source: 'Direct Transfer HDFC',
        channel: 'bank_transfer',
        transactionAt: now.subtract(const Duration(days: 7)),
        createdAt: now.subtract(const Duration(days: 7)),
        updatedAt: now.subtract(const Duration(days: 7)),
      ),
      FinanceTransaction(
        id: 'dl_tx_4',
        userId: userId,
        accountId: 'dl_acc_1',
        title: 'Coursera Full-Stack Certificate Course',
        amount: 1999.0,
        type: TransactionType.expense,
        category: 'education',
        source: 'GPay HDFC',
        channel: 'upi',
        transactionAt: now.subtract(const Duration(days: 5)),
        createdAt: now.subtract(const Duration(days: 5)),
        updatedAt: now.subtract(const Duration(days: 5)),
      ),
      FinanceTransaction(
        id: 'dl_tx_5',
        userId: userId,
        accountId: 'dl_acc_3',
        title: 'Stationery and Pens shop',
        amount: 350.0,
        type: TransactionType.expense,
        category: 'education',
        source: 'Cash',
        channel: 'cash',
        transactionAt: now.subtract(const Duration(days: 4)),
        createdAt: now.subtract(const Duration(days: 4)),
        updatedAt: now.subtract(const Duration(days: 4)),
      ),
      FinanceTransaction(
        id: 'dl_tx_6',
        userId: userId,
        accountId: 'dl_acc_3',
        title: 'Engineering Notes Printing',
        amount: 80.0,
        type: TransactionType.expense,
        category: 'education',
        source: 'Cash',
        channel: 'cash',
        transactionAt: now.subtract(const Duration(days: 2)),
        createdAt: now.subtract(const Duration(days: 2)),
        updatedAt: now.subtract(const Duration(days: 2)),
      ),
    ];

    final goals = <SavingsGoal>[
      SavingsGoal(
        id: 'dl_g_1',
        userId: userId,
        title: 'Laptop Loan Settlement',
        targetAmount: 20000.0,
        savedAmount: 2000.0,
        deadline: now.add(const Duration(days: 180)),
        status: GoalStatus.active,
        priority: 1,
        createdAt: now.subtract(const Duration(days: 10)),
        updatedAt: now,
      ),
    ];

    InMemoryDb.accounts.addAll(accounts);
    InMemoryDb.transactions.addAll(transactions);
    InMemoryDb.goals.addAll(goals);
  }
}
