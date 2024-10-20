import 'package:expense_tracker/widgets/chart/chart.dart';
import 'package:expense_tracker/widgets/expenses_list/expenses_list.dart';
import 'package:expense_tracker/widgets/new_expense.dart';
import 'package:flutter/material.dart';
import 'package:expense_tracker/models/expense.dart';

class Expenses extends StatefulWidget {
  const Expenses({super.key});

  @override
  State<Expenses> createState() => _ExpensesState();
}

class _ExpensesState extends State<Expenses> {
  final List<Expense> _registeredExpenses = [
    Expense(
        title: 'Flutter Course',
        amount: 19.99,
        date: DateTime.now(),
        category: Category.work),
    Expense(
        title: 'Lunch',
        amount: 1.99,
        date: DateTime.now(),
        category: Category.food),
    Expense(
        title: 'Coffee',
        amount: 1.99,
        date: DateTime.now(),
        category: Category.leisure),
    Expense(
        title: 'Cinema',
        amount: 2.99,
        date: DateTime.now(),
        category: Category.leisure),
    Expense(
        title: 'Tickets on plane',
        amount: 46.49,
        date: DateTime.now(),
        category: Category.travel),
  ];

  void _openAppExpenseOverlay() {
    showModalBottomSheet(
        useSafeArea: true,
        constraints: const BoxConstraints.expand(),
        isScrollControlled: true,
        context: context,
        builder: (ctx) {
          return NewExpense(onAddExpense: _addExpense);
        });
  }

  void _addExpense(Expense expense) {
    setState(() {
      _registeredExpenses.add(expense);
    });
  }

  void _removeExpense(Expense expense) {
    final expenseIndex = _registeredExpenses.indexOf(expense);
    setState(() {
      _registeredExpenses.remove(expense);
    });
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      duration: const Duration(seconds: 3),
      content: const Text('Expense deleted!'),
      action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            setState(() {
              _registeredExpenses.insert(expenseIndex, expense);
            });
          }),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    Widget mainContent =
        const Center(child: Text('No expense found. Start adding some!'));

    if (_registeredExpenses.isNotEmpty) {
      mainContent = ExpensesList(
          expenses: _registeredExpenses, onRemoveExpense: _removeExpense);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Expense Tracker'),
        actions: [
          IconButton(
            onPressed: _openAppExpenseOverlay,
            icon: const Icon(Icons.add),
          )
        ],
      ),
      body: width < 600
          ? Column(
              children: [
                Chart(expenses: _registeredExpenses),
                Expanded(
                  child: mainContent,
                ),
              ],
            )
          : Row(
              children: [
                Expanded(child: Chart(expenses: _registeredExpenses)),
                Expanded(
                  child: mainContent,
                ),
              ],
            ),

      // * --------- FOR Momento ---------
      // body: Center(
      //   child: Stack(
      //     alignment: Alignment.center,
      //     children: [
      //       // Background Circle
      //       Container(
      //         width: 250,
      //         height: 250,
      //         decoration: BoxDecoration(
      //           // shape: BoxShape.circle,
      //           gradient: RadialGradient(
      //             colors: [Colors.yellow, Colors.orange],
      //           ),
      //           boxShadow: [
      //             BoxShadow(
      //               color: Colors.black.withOpacity(0.5),
      //               blurRadius: 10,
      //               spreadRadius: 5,
      //               offset: Offset(0, 3),
      //             ),
      //           ],
      //         ),
      //       ),
      //       // Image in the center
      //       Container(
      //         width: 200,
      //         height: 200,
      //         decoration: BoxDecoration(
      //           // shape: BoxShape.circle,
      //           border: Border.all(
      //             color: Colors.white,
      //             width: 8,
      //           ),
      //         ),
      //         // child: ClipOval(
      //         child: ClipRect(
      //           child: Image.asset(
      //             'assets/da5f3976d8e94521b10740bf5dc2fbf8.png',
      //             fit: BoxFit.cover,
      //           ),
      //         ),
      //       ),
      //     ],
      //   ),
      // ),
      // * -------------------------------
    );
  }
}
