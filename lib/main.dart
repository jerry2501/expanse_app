import 'dart:io';

import 'package:expanse_app/models/transaction.dart';
import 'package:expanse_app/widgets/chart.dart';
import 'package:expanse_app/widgets/new_transaction.dart';
import 'package:expanse_app/widgets/transaction_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


void main() {
  //Only Portrait mode
//  WidgetsFlutterBinding.ensureInitialized();
//  SystemChrome.setPreferredOrientations(
//    [DeviceOrientation.portraitUp,DeviceOrientation.portraitDown]
//  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Personal Expanses',
      theme:ThemeData(
        primarySwatch: Colors.purple,
        accentColor: Colors.amber,
        fontFamily: 'Quicksand',
        textTheme: ThemeData.light().textTheme.copyWith(
          title: TextStyle(
            fontFamily: 'OpenSans',
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
          button: TextStyle(
            color: Colors.white,
          ),
        ),
        appBarTheme: AppBarTheme(textTheme: ThemeData.light().textTheme.copyWith(
            title:TextStyle(fontFamily: 'OpenSans',fontSize: 20,fontWeight: FontWeight.bold),
        ),
        )
      ),
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver{
  void startAddNewTransaction(BuildContext ctx){
    showModalBottomSheet(
      context:ctx,
      builder: (_){
        return GestureDetector(
            child: NewTransaction(onPressed: _addNewTransaction,),
          onTap: (){},
          behavior: HitTestBehavior.opaque,
        );
      }
    );
  }

  final List<Transaction> _userTransaction=[
//    Transaction(id: 't1',title: 'New Shoes',amount: 69.99,date: DateTime.now(),),
//    Transaction(id: 't2',title: 'Weekly Groceries',amount: 16.53,date: DateTime.now(),),
  ];
   List<Transaction> get _recentTransactions{
     return _userTransaction.where((tx){
       return tx.date.isAfter(DateTime.now().subtract(Duration(days: 7)));
     }).toList();
   }
  void _addNewTransaction(String title,double amount,DateTime chosenDate){
    final newTx=Transaction(id:DateTime.now().toString(),title: title,amount: amount,date:chosenDate);
    setState(() {
      _userTransaction.add(newTx);
    });
  }

  void _deleteTransaction(String id){
     setState(() {
       _userTransaction.removeWhere((tx){
         return tx.id==id;
       });
     });
  }

  bool _showChart=false;

   List<Widget> _buildLandsacpeContent(MediaQueryData mediaQuery,AppBar appBar,Widget txList){
     return [Row(
       mainAxisAlignment: MainAxisAlignment.center,
       children: <Widget>[
         Text('Show Chart',style: Theme.of(context).textTheme.title,),
         Switch.adaptive(
           activeColor: Theme.of(context).accentColor,
           value: _showChart,
           onChanged: (val){
             setState(() {
               _showChart=val;
             });
           },
         ),
       ],
     ),
       _showChart?Container(
           height: (mediaQuery.size.height-appBar.preferredSize.height-mediaQuery.padding.top)*0.7,
           child: Chart(_recentTransactions))
           :txList,
     ];
   }
   List<Widget> _buildPotraitContent(MediaQueryData mediaQuery,AppBar appBar,Widget txList){
     return [Container(
          height: (mediaQuery.size.height-appBar.preferredSize.height-mediaQuery.padding.top)*0.3,
         child: Chart(_recentTransactions)),
       txList,
     ];
   }
   @override
  void initState() {
    // TODO: implement initState
     WidgetsBinding.instance.addObserver(this);
    super.initState();
  }
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
   print(state);
  }
   @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
     final mediaQuery=MediaQuery.of(context);
    final isLandscape=MediaQuery.of(context).orientation==Orientation.landscape;
     final PreferredSizeWidget appbar=Platform.isIOS?CupertinoNavigationBar(
       middle:Text('Personal Expanses'),
       trailing: Row(
         mainAxisSize: MainAxisSize.min,
         children: <Widget>[
           GestureDetector(
             child: Icon(CupertinoIcons.add),
             onTap:()=> startAddNewTransaction(context),
           ),
         ],
       ),
     ):AppBar(
       title: Text('Personal Expanses'),
       actions: <Widget>[
         IconButton(
           icon: Icon(Icons.add),
           onPressed: (){
             startAddNewTransaction(context);
           },
         ),
       ],
     );
     final txList=Container(
         height: (MediaQuery.of(context).size.height-appbar.preferredSize.height-MediaQuery.of(context).padding.top)*0.7,
         child: TransactionList(transaction: _userTransaction,deleteTransaction: _deleteTransaction,));

     final pageBody=SafeArea(
       child: SingleChildScrollView(
         child: Column(
           mainAxisAlignment: MainAxisAlignment.start,
           crossAxisAlignment: CrossAxisAlignment.stretch,
           children:<Widget>[
             if(isLandscape) ..._buildLandsacpeContent(mediaQuery,appbar,txList),
             if(!isLandscape) ..._buildPotraitContent(mediaQuery,appbar,txList),
           ],
         ),
       ),
     );
    return Platform.isIOS?CupertinoPageScaffold(
      child: pageBody,
      navigationBar: appbar,
    ):Scaffold(
      appBar: appbar,
      body: pageBody,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton:Platform.isIOS?Container():FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: (){
          startAddNewTransaction(context);
        },
      ),
    );
  }
}
