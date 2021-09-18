import 'dart:io';

import 'package:expenses_tracker/models/transaction.dart';
import 'package:expenses_tracker/widgets/chart.dart';
import 'package:expenses_tracker/widgets/new_transaction.dart';
import 'package:expenses_tracker/widgets/transaction_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';

void main() {
  // WidgetsFlutterBinding().ensureInitialized();
  // SystemChrome.setPreferredOrientations(
  //   [
  //     DeviceOrientation.portraitDown,
  //     DeviceOrientation.portraitDown,
  //   ],
  // );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Expenses Tracker',
      theme: ThemeData(
        fontFamily: 'QuickSand',
        primarySwatch: Colors.purple,
        accentColor: Colors.amber,
        textTheme: ThemeData.light().textTheme.copyWith(
              headline6: TextStyle(
                fontFamily: 'OpenSans',
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
        appBarTheme: AppBarTheme(
            textTheme: ThemeData.light().textTheme.copyWith(
                  headline6: TextStyle(
                    fontFamily: 'OpenSans',
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                )),
      ),
      home: MyHomePage(title: 'Expenses Tracker'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;
  final List<Transaction> _transactions = [
    Transaction(
      id: 't1',
      title: 'New Shoes',
      amount: 69.99,
      date: DateTime.now(),
    ),
    Transaction(
      id: 't2',
      title: 'New Shirt',
      amount: 79.99,
      date: DateTime.now(),
    ),
    Transaction(
      id: 't3',
      title: 'New TV',
      amount: 609.99,
      date: DateTime.now(),
    ),
    Transaction(
      id: 't4',
      title: 'New Phone',
      amount: 179.99,
      date: DateTime.now(),
    ),
    Transaction(
      id: 't4',
      title: 'New Phone',
      amount: 179.99,
      date: DateTime.now(),
    ),
    Transaction(
      id: 't4',
      title: 'New Phone',
      amount: 179.99,
      date: DateTime.now(),
    ),
    Transaction(
      id: 't4',
      title: 'New Phone',
      amount: 179.99,
      date: DateTime.now(),
    ),
    Transaction(
      id: 't4',
      title: 'New Phone',
      amount: 179.99,
      date: DateTime.now(),
    ),
  ];

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool showChart = false;
  List<Transaction> get _recentTransactions {
    return widget._transactions.where((tx) {
      return tx.date.isAfter(
        DateTime.now().subtract(
          Duration(days: 7),
        ),
      );
    }).toList();
  }

  void _deleteTransaction(String id) {
    setState(() {
      widget._transactions.removeWhere((element) => element.id == id);
    });
  }

  void _addNewTransaction(String title, double amount, DateTime date) {
    final Transaction newTransaction = Transaction(
      id: DateTime.now().toString(),
      title: title,
      amount: amount,
      date: date,
    );

    setState(() {
      widget._transactions.add(newTransaction);
    });
  }

  void _startAddnewTx(ctx) {
    showModalBottomSheet(
        context: ctx,
        builder: (bctx) {
          return NewTransaction(_addNewTransaction);
        });
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final bool isLandscape = mediaQuery.orientation == Orientation.landscape;
    final PreferredSizeWidget _appBar = Platform.isIOS
        ? CupertinoNavigationBar(
            middle: Text('Personal Expences'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  child: Icon(CupertinoIcons.add),
                  onTap: () => _startAddnewTx(context),
                ),
              ],
            ),
          )
        : AppBar(
            title: Text(widget.title),
            actions: [
              IconButton(
                onPressed: () => _startAddnewTx(context),
                icon: Icon(Icons.add),
              )
            ],
          );

    final txListWidget = Container(
      height: (mediaQuery.size.height -
              _appBar.preferredSize.height -
              mediaQuery.padding.top) *
          0.75,
      child: TransactionList(widget._transactions, _deleteTransaction),
    );
    final bodyWidget = SafeArea(
      child: SingleChildScrollView(
        child: Column(children: [
          if (isLandscape)
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text(
                'Show Chart: ',
                style: Theme.of(context).textTheme.headline6,
              ),
              Switch.adaptive(
                  activeColor: Theme.of(context).accentColor,
                  value: showChart,
                  onChanged: (val) {
                    setState(() {
                      showChart = val;
                    });
                  })
            ]),
          if (!isLandscape)
            Container(
                height: (mediaQuery.size.height -
                        _appBar.preferredSize.height -
                        mediaQuery.padding.top) *
                    0.3,
                child: Chart(_recentTransactions)),
          if (!isLandscape) txListWidget,
          if (isLandscape)
            showChart
                ? Container(
                    height: (mediaQuery.size.height -
                            _appBar.preferredSize.height -
                            mediaQuery.padding.top) *
                        0.7,
                    child: Chart(_recentTransactions))
                : txListWidget,
        ]),
      ),
    );
    return Platform.isIOS
        ? CupertinoPageScaffold(
            child: bodyWidget,
            navigationBar: _appBar,
          )
        : Scaffold(
            floatingActionButton: FloatingActionButton(
              onPressed: () => _startAddnewTx(context),
              child: Icon(Icons.add),
            ),
            floatingActionButtonLocation: Platform.isIOS
                ? Container()
                : FloatingActionButtonLocation.centerFloat,
            appBar: _appBar,
            body: bodyWidget,
          );
  }
}
