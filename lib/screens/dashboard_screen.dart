import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled1/repositories/budget_repository.dart';
import 'package:untitled1/repositories/expense_repository.dart';
import 'package:untitled1/repositories/savings_goal_repository.dart';
import 'package:untitled1/repositories/user_repository.dart';

import 'package:untitled1/screens/add_category_screen.dart';

import 'add_budger_screen.dart';
import 'add_expense_screeen.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: DashboardScreen(),
  ));
}

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentIndex = 0;
  final UserRepository userRepository = UserRepository();
  final ExpenseRepository expenseRepository = ExpenseRepository();
  final SavingsGoalRepository savingsGoalRepository = SavingsGoalRepository();
  final BudgetRepository budgetRepository = BudgetRepository();
  int? userId;
  String userName = "Nestor";
  double totalExpenses = 0.0;
  double totalBudget = 0.0;
  double savingsProgress = 0.0;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    userId = await userRepository.getCurrentUserId();
    if (userId != null) {
      var user = await userRepository.getUserById(userId!);
      if (user != null) {
        setState(() {
          userName = user.username;
        });

        // Load financial data
        final expenses = await expenseRepository.getTotalExpensesForUser(userId!);
        final now = DateTime.now();
        final budget = await budgetRepository.getTotalBudgetForUser(userId!, now.month, now.year);

        final savings = await savingsGoalRepository.getSavingsProgressForUser(userId!);

        setState(() {
          totalExpenses = expenses;
          totalBudget = budget;
          savingsProgress = savings;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Define screens here to access the state
    final List<Widget> _screens = [
      DashboardContent(
        userName: userName,
        totalExpenses: totalExpenses,
        totalBudget: totalBudget,
        savingsProgress: savingsProgress,
        onCardTap: (index) {
          setState(() {
            _currentIndex = index + 1; // +1 because first screen is dashboard
          });
        },
      ),
      ExpensesScreen(onAddExpense: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AddExpenseScreen()),
        ).then((_) => _loadUserData()); // Refresh data after returning
      }),
      SavingsGoalsScreen(),
      BudgetScreen(onAddBudget: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AddBudgetScreen()),
        ).then((_) => _loadUserData()); // Refresh data after returning
      }),
    ];

    return Scaffold(
      backgroundColor: Color(0xFFF5F7FB),
      appBar: AppBar(
        title: Text('Dashboard', style: GoogleFonts.poppins()),
        backgroundColor: Colors.blueAccent,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.category),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddCategoryScreen()),
              ).then((_) => _loadUserData());
            },
            tooltip: 'Add Category',
          ),
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _loadUserData,
            tooltip: 'Refresh Data',
          ),
        ],
      ),
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.blueAccent,
        unselectedItemColor: Colors.grey,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: "Dashboard"),
          BottomNavigationBarItem(icon: Icon(Icons.money), label: "Expenses"),
          BottomNavigationBarItem(icon: Icon(Icons.savings), label: "Savings"),
          BottomNavigationBarItem(icon: Icon(Icons.pie_chart), label: "Budget"),
        ],
      ),
      floatingActionButton: _getFloatingActionButton(),
    );
  }

  Widget? _getFloatingActionButton() {
    // Show different FAB based on selected tab
    switch (_currentIndex) {
      case 1: // Expenses
        return FloatingActionButton(
          child: Icon(Icons.add),
          backgroundColor: Colors.blueAccent,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddExpenseScreen()),
            ).then((_) => _loadUserData());
          },
        );
      case 2: // Savings
        return FloatingActionButton(
          child: Icon(Icons.add),
          backgroundColor: Colors.blueAccent,
          onPressed: () {
            // Navigate to add savings goal screen
            // Add your navigation code here
          },
        );
      case 3: // Budget
        return FloatingActionButton(
          child: Icon(Icons.add),
          backgroundColor: Colors.blueAccent,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddBudgetScreen()),
            ).then((_) => _loadUserData());
          },
        );
      default:
        return null;
    }
  }
}

class DashboardContent extends StatelessWidget {
  final String userName;
  final double totalExpenses;
  final double totalBudget;
  final double savingsProgress;
  final Function(int) onCardTap;

  const DashboardContent({
    required this.userName,
    required this.totalExpenses,
    required this.totalBudget,
    required this.savingsProgress,
    required this.onCardTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Welcome, $userName!",
              style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.bold)),
          SizedBox(height: 10),

          // Summary card
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Financial Summary",
                      style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600)),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Total Budget:", style: GoogleFonts.poppins()),
                      Text("\$${totalBudget.toStringAsFixed(2)}",
                          style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Total Expenses:", style: GoogleFonts.poppins()),
                      Text("\$${totalExpenses.toStringAsFixed(2)}",
                          style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
                    ],
                  ),
                  SizedBox(height: 10),
                  LinearProgressIndicator(
                    value: totalBudget > 0 ? (totalExpenses / totalBudget).clamp(0.0, 1.0) : 0,
                    backgroundColor: Colors.grey[200],
                    valueColor: AlwaysStoppedAnimation<Color>(
                      totalExpenses > totalBudget ? Colors.red : Colors.green,
                    ),
                  ),
                ],
              ),
            ),
          ),

          SizedBox(height: 20),
          Text("Your quick access panel:",
              style: GoogleFonts.poppins(fontSize: 16, color: Colors.grey[700])),
          SizedBox(height: 20),

          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 15,
              mainAxisSpacing: 15,
              children: [
                DashboardCard(
                  icon: Icons.money,
                  title: "Expenses",
                  value: "\$${totalExpenses.toStringAsFixed(2)}",
                  onTap: () => onCardTap(0),
                ),
                DashboardCard(
                  icon: Icons.savings,
                  title: "Savings",
                  value: "${(savingsProgress * 100).toStringAsFixed(0)}%",
                  onTap: () => onCardTap(1),
                ),
                DashboardCard(
                  icon: Icons.pie_chart,
                  title: "Budget",
                  value: "\$${totalBudget.toStringAsFixed(2)}",
                  onTap: () => onCardTap(2),
                ),
                DashboardCard(
                  icon: Icons.category,
                  title: "Categories",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AddCategoryScreen()),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class DashboardCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? value;
  final VoidCallback onTap;

  const DashboardCard({
    required this.icon,
    required this.title,
    this.value,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        elevation: 4,
        child: Container(
          padding: EdgeInsets.all(15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 40, color: Colors.blueAccent),
              SizedBox(height: 10),
              Text(title, style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600)),
              if (value != null) ...[
                SizedBox(height: 5),
                Text(
                  value!,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.grey[700],
                  ),
                ),
              ]
            ],
          ),
        ),
      ),
    );
  }
}

// Updated Placeholder Screens with navigation
class ExpensesScreen extends StatelessWidget {
  final VoidCallback onAddExpense;

  const ExpensesScreen({required this.onAddExpense});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Your Expenses",
            style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          // Add your expense list here
          // When content is empty, show a message
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.receipt_long, size: 60, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    "No expenses yet",
                    style: GoogleFonts.poppins(fontSize: 18, color: Colors.grey[700]),
                  ),
                  SizedBox(height: 8),
                  ElevatedButton.icon(
                    onPressed: onAddExpense,
                    icon: Icon(Icons.add),
                    label: Text('Add Expense', style: GoogleFonts.poppins()),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SavingsGoalsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Your Savings Goals",
            style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          // Add your savings goals list here
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.savings, size: 60, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    "No savings goals yet",
                    style: GoogleFonts.poppins(fontSize: 18, color: Colors.grey[700]),
                  ),
                  SizedBox(height: 8),
                  ElevatedButton.icon(
                    onPressed: () {
                      // Navigate to add savings goal screen
                    },
                    icon: Icon(Icons.add),
                    label: Text('Add Savings Goal', style: GoogleFonts.poppins()),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class BudgetScreen extends StatelessWidget {
  final VoidCallback onAddBudget;

  const BudgetScreen({required this.onAddBudget});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Your Budgets",
            style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          // Add your budget list here
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.pie_chart, size: 60, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    "No budgets yet",
                    style: GoogleFonts.poppins(fontSize: 18, color: Colors.grey[700]),
                  ),
                  SizedBox(height: 8),
                  ElevatedButton.icon(
                    onPressed: onAddBudget,
                    icon: Icon(Icons.add),
                    label: Text('Add Budget', style: GoogleFonts.poppins()),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}