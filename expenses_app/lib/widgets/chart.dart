import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/transaction.dart';
import './bars.dart';

class Chart extends StatelessWidget {
  final List<Transaction> recent;
  Chart(this.recent);

  List<Map<String, Object>> get groupedTransactionValues {
    return List.generate(7, (index) {
      final weekDay = DateTime.now().subtract(
        Duration(days: index),
      );
      var totalSum = 0.0;

      // print(DateFormat.E().format(weekDay));
      // print(totalSum.toStringAsFixed(2));

      for (var i = 0; i < recent.length; i++) {
        if (recent[i].date.day == weekDay.day &&
            recent[i].date.month == weekDay.month &&
            recent[i].date.year == weekDay.year) {
          totalSum += recent[i].cost;
        }
      }
      return {
        'day': DateFormat.E().format(weekDay).substring(0, 1),
        'amount': totalSum,
      };
    }).reversed.toList();
  }

  double get totalamount {
    return groupedTransactionValues.fold(0.0, (sum, item) {
      return sum + item['amount'];
    });
  }

  @override
  Widget build(BuildContext context) {
    // print(groupedTransactionValues);
    return Card(
      elevation: 8,
      margin: EdgeInsets.only(left: 4, top: 1, right: 4, bottom: 8),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Row(
          // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: groupedTransactionValues.map((data) {
            return Flexible(
              fit: FlexFit.tight,
              child: Bars(
                data['day'],
                data['amount'],
                totalamount == 0.0
                    ? 0.0
                    : (data['amount'] as double) / totalamount,
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
