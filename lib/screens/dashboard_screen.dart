import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled1/repositories/budget_repository.dart';
import 'package:untitled1/repositories/expense_repository.dart';
import 'package:untitled1/repositories/savings_goal_repository.dart';
import 'package:untitled1/repositories/user_repository.dart';


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
        totalExpenses = await expenseRepository.getTotalExpensesForUser(userId!);
      }
    }
  }

  final List<Widget> _screens = [
    DashboardContent(),
    ExpensesScreen(),
    SavingsGoalsScreen(),
    BudgetScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F7FB),
      appBar: AppBar(
        title: Text('Dashboard', style: GoogleFonts.poppins()),
        backgroundColor: Colors.blueAccent,
        elevation: 0,
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
    );
  }
}

class DashboardContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Welcome, Nestor!", style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.bold)),
          SizedBox(height: 10),
          Text("Your quick access panel:", style: GoogleFonts.poppins(fontSize: 16, color: Colors.grey[700])),
          SizedBox(height: 20),
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 15,
              mainAxisSpacing: 15,
              children: [
                DashboardCard(icon: Icons.money, title: "Expenses"),
                DashboardCard(icon: Icons.savings, title: "Savings"),
                DashboardCard(icon: Icons.pie_chart, title: "Budget"),
                DashboardCard(icon: Icons.person, title: "Profile"),
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
  const DashboardCard({required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    return Card(
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
          ],
        ),
      ),
    );
  }
}

// Placeholder Screens
class ExpensesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text("Expenses Screen"));
  }
}

class SavingsGoalsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text("Savings Goals Screen"));
  }
}

class BudgetScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text("Budget Screen"));
  }
}
