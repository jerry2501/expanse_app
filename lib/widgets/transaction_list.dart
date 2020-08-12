import 'package:expanse_app/models/transaction.dart';
import 'package:expanse_app/widgets/transaction_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> transaction;
  final Function deleteTransaction;

  const TransactionList({Key key, this.transaction,this.deleteTransaction}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return (transaction.isEmpty)?
    LayoutBuilder(
      builder: (ctx,constrains){
        return Column(
          children:<Widget>[
            Text('No Transactions added yet!',style:Theme.of(context).textTheme.title),
            const SizedBox(height:20,),
            Container(
                height: constrains.maxHeight*0.60,
                child: Image.asset('assets/images/waiting.png',fit: BoxFit.cover,)),
          ],
        );
      },
    ): ListView.builder(
        itemBuilder: (BuildContext context,int index){
          return TransactionItem(transaction: transaction[index], deleteTransaction: deleteTransaction);
        },
        itemCount: transaction.length,
    );
  }
}

