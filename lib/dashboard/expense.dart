import 'package:emperiosquartet/chart/month_function.dart';
import 'package:emperiosquartet/chart/month_widget.dart';
import 'package:emperiosquartet/sidebar/navbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class ExpenseInsightPage extends StatelessWidget {
  final CollectionReference budgetRef =
      FirebaseFirestore.instance.collection('users');

  ExpenseInsightPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const Navbar(),
      appBar: AppBar(
        title: const Text(
          'EXPENSE INSIGHT',
          style: TextStyle(
            color: Colors.black, // AppBar title color
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        backgroundColor:
            const Color.fromARGB(255, 245, 246, 248), // AppBar background color
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const ExpenseTrendSection(),
              const SizedBox(height: 20),
              BudgetOverviewSection(budgetRef: budgetRef),
              const SizedBox(height: 20),
              HighestExpensesSection(budgetRef: budgetRef),
            ],
          ),
        ),
      ),
    );
  }
}

class ExpenseTrendSection extends StatefulWidget {
  const ExpenseTrendSection({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ExpenseTrendSectionState createState() => _ExpenseTrendSectionState();
}

class _ExpenseTrendSectionState extends State<ExpenseTrendSection> {
  bool showMonthly = true;
  final IncomeController incomeController = Get.put(IncomeController());

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white, // Card background color
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
              color: const Color.fromARGB(255, 9, 9, 9).withOpacity(0.3),
              blurRadius: 5), // Card shadow color
        ],
      ),
      child: Column(
        children: [
          Container(
            height: 350,
            width: double.infinity,
            color: Colors.orange[50], // Placeholder chart background color
            child: const RevenueVsProfitMarginChart(),
          ),
        ],
      ),
    );
  }
}

class BudgetOverviewSection extends StatelessWidget {
  final _auth = FirebaseAuth.instance;
  User? get user => _auth.currentUser;
  final CollectionReference budgetRef;

  BudgetOverviewSection({super.key, required this.budgetRef});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      future: budgetRef.doc(user!.uid).collection('budgets').doc('main').get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Text("Error: ${snapshot.error}");
        }

        var data = snapshot.data?.data() as Map<String, dynamic>?;

        if (data == null) {
          return _buildDefaultLayout('Month');
        }

        String month = data['month'] ?? 'Month';
        double totalBudget = (data['total'] ?? 0).toDouble();
        double spentAmount = (data['spent'] ?? 0).toDouble();
        bool budgetOverspent = (data['budgetOverspent'] ?? false);
        double remainingAmount = totalBudget - spentAmount;
        double spentPercentage =
            totalBudget > 0 ? spentAmount / totalBudget : 0;

        return _buildBudgetLayout(month, totalBudget, spentAmount,
            remainingAmount, spentPercentage, budgetOverspent);
      },
    );
  }

  Widget _buildDefaultLayout(String month) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white, // Default layout background color
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
              color: Colors.green.withOpacity(0.3),
              blurRadius: 5), // Default shadow color
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(month.toUpperCase(),
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.green)), // Month text color
          const Text('PHP 0',
              style: TextStyle(color: Colors.grey)), // Default text color
          const LinearProgressIndicator(value: 0, backgroundColor: Colors.grey),
          const SizedBox(height: 5),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                  child: Text('PHP 0 Spent',
                      style: TextStyle(
                          color:
                              Color.fromARGB(255, 13, 13, 13)))), // Spent color
              Flexible(
                  child: Text('PHP 0 Remains',
                      style:
                          TextStyle(color: Colors.green))), // Remaining color
            ],
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _buildBudgetLayout(
      String month,
      double totalBudget,
      double spentAmount,
      double remainingAmount,
      double spentPercentage,
      bool budgetOverspent) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
              color: Colors.purple.withOpacity(0.3),
              blurRadius: 5), // Custom shadow color
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(month.toUpperCase(),
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 12, 12, 12))), // Custom text color
          Text('PHP $totalBudget',
              style: const TextStyle(color: Colors.black)), // Custom text color
          LinearProgressIndicator(
            value: spentPercentage,
            backgroundColor: Colors.grey[300],
            color: spentPercentage > 0.75
                ? Colors.red
                : Colors.green, // Dynamic progress bar color
          ),
          const SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                  child: Text('PHP $spentAmount Spent',
                      style: const TextStyle(
                          color: Colors.red))), // Spent text color
              Flexible(
                  child: Text('PHP $remainingAmount Remains',
                      style: const TextStyle(
                          color: Colors.green))), // Remaining text color
            ],
          ),
          const SizedBox(height: 10),
          if (budgetOverspent && spentPercentage > 0.89)
            Container(
              padding: const EdgeInsets.all(10),
              margin: const EdgeInsets.only(top: 8),
              decoration: BoxDecoration(
                color: Colors.red[100], // Warning background color
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(Icons.warning,
                      color: Colors.red), // Warning icon color
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Budget Check: Watch Your Spending ${(remainingAmount / totalBudget * 100).toStringAsFixed(1)}% left.',
                      style: const TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold), // Warning text color
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class HighestExpensesSection extends StatelessWidget {
  final _auth = FirebaseAuth.instance;
  User? get user => _auth.currentUser;
  final CollectionReference budgetRef;

  HighestExpensesSection({super.key, required this.budgetRef});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      future: budgetRef.doc(user!.uid).collection('budgets').doc('main').get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        }
        if (!snapshot.hasData || snapshot.data?.data() == null) {
          return _buildDefaultExpensesUI('Month');
        }

        var data = snapshot.data!.data() as Map<String, dynamic>?;

        if (data == null || !data.containsKey('purchasedItems')) {
          return _buildDefaultExpensesUI(' Month');
        }

        String month = data['month'] ?? ' Month';
        var purchasedItems = data['purchasedItems'] as List<dynamic>?;

        double groceries = 0, shopping = 0, utilities = 0;

        for (var item in purchasedItems ?? []) {
          if (item is Map<String, dynamic>) {
            String category = item['category'] ?? '';
            double categoryAmount = (item['amount'] ?? 0).toDouble();

            if (category == 'Groceries') {
              groceries += categoryAmount;
            } else if (category == 'Shopping') {
              shopping += categoryAmount;
            } else if (category == 'Utilities') {
              utilities += categoryAmount;
            }
          }
        }

        return _buildExpensesUI(month, groceries, shopping, utilities);
      },
    );
  }

  Widget _buildExpensesUI(
      String month, double groceries, double shopping, double utilities) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
              color: Colors.orange.withOpacity(0.3),
              blurRadius: 5), // Custom shadow color
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(month.toUpperCase(),
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 8, 8, 8))), // Custom text color
          const Text('HIGHEST EXPENSES', style: TextStyle(color: Colors.grey)),
          const SizedBox(height: 10),
          ExpenseCategoryTile(category: 'Groceries', amount: groceries.toInt()),
          ExpenseCategoryTile(category: 'Shopping', amount: shopping.toInt()),
          ExpenseCategoryTile(category: 'Utilities', amount: utilities.toInt()),
        ],
      ),
    );
  }

  Widget _buildDefaultExpensesUI(String month) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(color: Colors.grey.withOpacity(0.3), blurRadius: 5),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(month.toUpperCase(),
              style: const TextStyle(
                  fontWeight: FontWeight.bold, color: Colors.blue)),
          const Text('HIGHEST EXPENSES', style: TextStyle(color: Colors.grey)),
          const SizedBox(height: 10),
          const ExpenseCategoryTile(category: 'Groceries', amount: 0),
          const ExpenseCategoryTile(category: 'Shopping', amount: 0),
          const ExpenseCategoryTile(category: 'Utilities', amount: 0),
        ],
      ),
    );
  }
}

class ExpenseCategoryTile extends StatelessWidget {
  final String category;
  final int amount;

  const ExpenseCategoryTile({
    super.key,
    required this.category,
    required this.amount,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(category,
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(
                        255, 9, 9, 9))), // Custom category text color
            Text('PHP $amount',
                style: const TextStyle(
                    color: Colors.black)), // Custom amount text color
          ],
        ),
        LinearProgressIndicator(
          value: amount / 10000,
          backgroundColor: Colors.grey[300],
          color: category == 'Groceries'
              ? Colors.green
              : (category == 'Shopping'
                  ? Colors.red
                  : Colors.orange), // Progress bar color based on category
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}
