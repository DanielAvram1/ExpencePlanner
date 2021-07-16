import 'dart:math';

import 'package:expenceplanner/models/transaction.dart';
import 'package:expenceplanner/widgets/chart_bar.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Chart extends StatelessWidget {
  final List<Transaction> recentTransactions;

  Chart(this.recentTransactions);

  List<Map<String, Object>> get groupedTransactionValues {
    return List.generate(7, (index) {
      final weekDay = DateTime.now().subtract(Duration(days: index));
      double totalSum = 0;
      for(var tx in recentTransactions) {
        if (tx.date.day == weekDay.day && 
            tx.date.month == weekDay.month && 
            tx.date.year == weekDay.year)
          totalSum += tx.amount;
      }

      print(DateFormat.E().format(weekDay));
      print(totalSum);

      return {
        'day' : DateFormat.E().format(weekDay).substring(0,1),
       'amount': totalSum
      };
    }).reversed.toList();
  }

  double get totalSpending {
    return groupedTransactionValues.fold(0.0, (accum, item) => accum += (item['amount'] as double));
  }

  @override
  Widget build(BuildContext context) {
    print(groupedTransactionValues);
    return Card(
      elevation: 6,
      margin: EdgeInsets.all(20),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: groupedTransactionValues.map((data) =>
            Flexible(
                fit: FlexFit.tight,
                child: ChartBar(
                data['day'] as String, 
                data['amount'] as double, 
                totalSpending == 0.0 ? 0.0 : (data['amount'] as double) / totalSpending),
            )
          ).toList(),
        ),
      ),
    );
  }
}