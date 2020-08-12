import 'package:expanse_app/models/transaction.dart';
import 'package:expanse_app/widgets/chart_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Chart extends StatelessWidget {
  final List<Transaction> recentTransactions;

  Chart(this.recentTransactions);
  List<Map<String,Object>> get groupedTransactiosValues{

    return List.generate(7,
            (index){
              final weekDay=DateTime.now().subtract(Duration(days: index),);
              double totalSum=0.0;
              for(int i=0;i<recentTransactions.length;i++){
                if(recentTransactions[i].date.day==weekDay.day && recentTransactions[i].date.month==weekDay.month && recentTransactions[i].date.year==weekDay.year){
                  totalSum+=recentTransactions[i].amount;
                }
              }
              return {'day':DateFormat.E().format(weekDay).substring(0,1),'amount':totalSum};
            }).reversed.toList();
  }

  double get totalSpending{
    return groupedTransactiosValues.fold(0.0,(sum,item){
      return sum+item['amount'];
    });
  }
  @override
  Widget build(BuildContext context) {
    print(groupedTransactiosValues);
    return Card(
      elevation: 6,
      margin: EdgeInsets.all(20),
      child:Container(
        padding: EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: groupedTransactiosValues.map((data){
            return Flexible(
              fit: FlexFit.tight,
              child: ChartBar(data['day'],data['amount'],
                  totalSpending==0.0?0.0:(data['amount'] as double)/totalSpending),
            );
          }).toList(),
        ),
      ),
    );
  }
}
